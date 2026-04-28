#!/usr/bin/env bash
# UnoAi structural-integrity validator (per DEC-026 + Procedure 9).
#
# Pure bash, no external deps. Runs from repo root: `bash scripts/validate.sh`.
# Wired into `.githooks/pre-commit` after gitleaks.
#
# Checks (eleven — see DEC-026 + INC-006 + MS-005 Scope A + MS-006 Scope G + MS-009 Section 5):
#   1. DEC numbering: sequential, no gaps, no duplicates (DEC-001..DEC-NNN)
#   2. RFI numbering: sequential, no gaps, no duplicates
#   3. INC numbering: sequential, no gaps, no duplicates
#   4. MS numbering:  sequential
#   5. Closes: RFI-NNN cross-references in DECISION.md resolve to real RFIs
#   6. Supersedes: DEC-NNN cross-references resolve to real prior DECs
#   7. state/current.md "Latest XXX" counters match actual highest entry
#   8. Session lifecycle: every session-start has a matching session-end from
#      a prior session (allows ONE open session — the current one)
#   9. MS chain: every "Depends on: MS-NNN" line in METHOD_STATEMENT.md
#      resolves to an MS that (a) exists in METHOD_STATEMENT.md AND (b) has
#      a corresponding DONE entry (matched via "Method statement: MS-NNN"
#      line in DONE.md). "DONE exists" is the v1 semantics per RFI-010
#      default (a); check 11 below tightens this to "DONE signed."
#  10. README ↔ state sync: README.md "## Status" first non-empty line and
#      state/current.md "## Phase" "Current:" line must contain the same
#      "Phase X status" identifier (case-insensitive substring match).
#      Hard-fail on parse error per DEC-026's fail-closed precedent.
#  11. DONE sign-off: every "Depends on: MS-NNN" reference resolves to an MS
#      whose DONE-NNN has a populated "Operator sign-off:" field (not the
#      literal "pending"). Sign-off field expected to carry the DEC-032
#      magic-string "DONE-NNN signed off by operator on YYYY-MM-DD" applied
#      by Builder at next session sign-in after operator chat sign-off.
#      Tightens check 9's DONE-exists semantics to DONE-signed. Shipped at
#      MS-009 Section 5 once retroactive cleanup of DONE-002..006 sign-off
#      fields landed (deferred from MS-007 Scope D3 / DEC-032 closing note).
#
# Sign-in / sign-out heading-line regex (strict):
#   ^### [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} session (start|end)$
#
# Code-block awareness: form templates contain example entries inside ``` fences
# (MS-005, INC-001, RFI-001, DONE-004 examples). Real entries live outside
# fences. The validator skips ``` blocks via a toggle.
#
# Integer-literal note: bash treats leading-zero numerics as octal in arithmetic
# and printf, so "025" becomes 21 and "008" raises "invalid octal." All
# numeric comparisons / formatting use 10#$x to force base-10.

set -u

FAILS=()
fail() { FAILS+=("$1"); }

# Format an integer as a zero-padded 3-digit string ($1 = decimal int).
fmt() { printf '%03d' "$1"; }

# Print real ### XXX-NNN headings (outside ``` fences) as decimal integers.
# $1=prefix, $2=file. Output one int per line, leading zeros stripped.
real_headings() {
  awk -v prefix="$1" '
    /^```/ { in_block = !in_block; next }
    !in_block && $0 ~ "^### " prefix "-[0-9]+" {
      match($0, prefix "-[0-9]+")
      n = substr($0, RSTART + length(prefix) + 1, RLENGTH - length(prefix) - 1)
      sub(/^0+/, "", n); if (n == "") n = "0"
      print n
    }
  ' "$2"
}

# Check that a list of integers (on stdin, one per line) is a strict 1..N
# sequence with no gaps or duplicates. $1=label.
# Two passes: (a) uniq -d catches duplicates with one fail per dup; (b) walk
# the deduped list to find gaps. Avoids cascading "out-of-step" noise after
# a single duplicate.
check_sequential() {
  local label="$1"
  local nums; nums=$(cat)
  if [ -z "$nums" ]; then
    fail "$label: no entries found in source file"
    return
  fi
  local sorted; sorted=$(printf '%s\n' "$nums" | sort -n)

  # Pass 1: duplicates.
  while IFS= read -r dup; do
    [ -n "$dup" ] && fail "$label: duplicate entry $label-$(fmt "$dup")"
  done < <(printf '%s\n' "$sorted" | uniq -d)

  # Pass 2: gaps (against deduped list).
  local expected=1
  while IFS= read -r n; do
    if [ "$n" -gt "$expected" ]; then
      fail "$label: numbering gap — expected $label-$(fmt "$expected"), found $label-$(fmt "$n")"
      expected="$n"
    fi
    expected=$((expected + 1))
  done < <(printf '%s\n' "$sorted" | uniq)
}

# Check 1-4: numbering for DEC / RFI / INC / MS.
# Use process substitution (not pipes) so FAILS array modifications inside
# check_sequential propagate to the parent shell. With `cmd | fn`, bash runs
# fn in a subshell and discards its variable mutations.
check_sequential DEC < <(real_headings DEC  forms/DECISION.md)
check_sequential RFI < <(real_headings RFI  forms/RFI.md)
check_sequential INC < <(real_headings INC  forms/INCIDENT.md)
check_sequential MS  < <(real_headings MS   forms/METHOD_STATEMENT.md)

# Helper: walk DECISION.md outside ``` fences, emit "DEC-NNN|<line>" pairs
# tagging each cross-reference line with its enclosing DEC heading.
walk_dec_xrefs() {
  awk '
    /^```/ { in_block = !in_block; next }
    !in_block && /^### DEC-[0-9]+/ {
      match($0, "DEC-[0-9]+")
      current = substr($0, RSTART, RLENGTH)
    }
    !in_block && (/Closes:.*RFI-[0-9]+/ || /Supersedes:.*DEC-[0-9]+/) {
      print current "|" $0
    }
  ' forms/DECISION.md
}

# Check 5: Closes: RFI-NNN cross-references resolve.
existing_rfis=$(real_headings RFI forms/RFI.md | sort -un)
while IFS='|' read -r src line; do
  [ -z "$line" ] && continue
  case "$line" in *Closes:*RFI-*) ;; *) continue ;; esac
  target=$(printf '%s' "$line" | sed -n 's/.*Closes:[^R]*RFI-\([0-9][0-9]*\).*/\1/p')
  [ -z "$target" ] && continue
  target=$((10#$target))
  if ! grep -qx "$target" <<< "$existing_rfis"; then
    fail "DEC cross-reference: $src has 'Closes: RFI-$(fmt "$target")' which does not exist in forms/RFI.md"
  fi
done < <(walk_dec_xrefs)

# Check 6: Supersedes: DEC-NNN cross-references resolve.
existing_decs=$(real_headings DEC forms/DECISION.md | sort -un)
while IFS='|' read -r src line; do
  [ -z "$line" ] && continue
  case "$line" in *Supersedes:*DEC-*) ;; *) continue ;; esac
  target=$(printf '%s' "$line" | sed -n 's/.*Supersedes:[^D]*DEC-\([0-9][0-9]*\).*/\1/p')
  [ -z "$target" ] && continue
  target=$((10#$target))
  if ! grep -qx "$target" <<< "$existing_decs"; then
    fail "DEC cross-reference: $src has 'Supersedes: DEC-$(fmt "$target")' which does not exist"
  fi
done < <(walk_dec_xrefs)

# Check 7: state/current.md counters match actual highest of each type.
state_file="state/current.md"
if [ ! -f "$state_file" ]; then
  fail "state/current.md missing — required by DEC-026"
else
  for kind in MS DEC RFI INC; do
    line=$(grep -E "^Latest $kind:" "$state_file" || true)
    if [ -z "$line" ]; then
      fail "state/current.md: 'Latest $kind:' line missing or unrecognized format"
      continue
    fi
    stated=$(printf '%s' "$line" | sed -n "s/.*$kind-\([0-9][0-9]*\).*/\1/p")
    if [ -z "$stated" ]; then
      fail "state/current.md: 'Latest $kind:' line could not be parsed (expected '$kind-NNN' identifier)"
      continue
    fi
    stated=$((10#$stated))
    case "$kind" in
      DEC) actual_file=forms/DECISION.md ;;
      RFI) actual_file=forms/RFI.md ;;
      INC) actual_file=forms/INCIDENT.md ;;
      MS)  actual_file=forms/METHOD_STATEMENT.md ;;
    esac
    actual=$(real_headings "$kind" "$actual_file" | sort -n | tail -1)
    [ -z "$actual" ] && actual=0
    if [ "$stated" -ne "$actual" ]; then
      fail "state/current.md 'Latest $kind' counter ($kind-$(fmt "$stated")) does not match actual highest entry ($kind-$(fmt "$actual"))"
    fi
  done
fi

# Check 9: MS chain dependency (per DEC-026 + INC-006).
# Field-format strict: only `- **Depends on:** MS-NNN` lines counted (skips
# prose mentions of "Depends on:" elsewhere in MS bodies). One Depends-on
# field per MS; "Depends on: none" / unset = no dependency.
done_mses=$(awk '
  /^```/ { in_block = !in_block; next }
  !in_block && /^### / {
    if (in_done && ms != "") print ms
    in_done = ($0 ~ /^### DONE-[0-9]+/); ms = ""
  }
  in_done && /^- \*\*Method statement:\*\*/ {
    if (match($0, /MS-[0-9]+/)) ms = substr($0, RSTART, RLENGTH)
  }
  END { if (in_done && ms != "") print ms }
' forms/DONE.md | sort -u)

existing_mses=$(awk '
  /^```/ { in_block = !in_block; next }
  !in_block && /^### MS-[0-9]+/ {
    if (match($0, /MS-[0-9]+/)) print substr($0, RSTART, RLENGTH)
  }
' forms/METHOD_STATEMENT.md | sort -u)

while IFS='|' read -r src target; do
  [ -z "$target" ] && continue
  if ! grep -qx "$target" <<< "$existing_mses"; then
    fail "MS chain: $src cannot proceed — depends on $target which does not exist in METHOD_STATEMENT.md"
  elif ! grep -qx "$target" <<< "$done_mses"; then
    fail "MS chain: $src cannot proceed — depends on $target which exists but is not yet DONE in DONE.md"
  fi
done < <(awk '
  /^```/ { in_block = !in_block; next }
  !in_block && /^### MS-[0-9]+/ {
    if (match($0, /MS-[0-9]+/)) current = substr($0, RSTART, RLENGTH)
  }
  !in_block && /^- \*\*Depends on:\*\*/ && !/[Nn]one/ {
    if (match($0, /MS-[0-9]+/)) print current "|" substr($0, RSTART, RLENGTH)
  }
' forms/METHOD_STATEMENT.md)

# Check 8: session lifecycle.
sitelog=forms/SITE_LOG.md
re='^### [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2} session (start|end)$'
counts=$(awk -v re="$re" '
  /^```/ { in_block = !in_block; next }
  !in_block && $0 ~ re {
    if ($0 ~ /session start$/) s++
    else if ($0 ~ /session end$/) e++
  }
  END { print (s+0) " " (e+0) }
' "$sitelog")
starts=${counts% *}
ends=${counts#* }
diff=$((starts - ends))
if [ "$diff" -lt 0 ]; then
  fail "SITE_LOG session lifecycle: more session-end entries ($ends) than session-start entries ($starts)"
elif [ "$diff" -gt 1 ]; then
  fail "SITE_LOG session lifecycle: $diff session-start entries without matching session-end (expected at most 1 open session — the current one)"
fi

# Check 10: README ↔ state sync (per MS-006 Scope G + DEC-026 hard-fail).
# Extract "Phase X status" identifier from state/current.md (## Phase, "Current:"
# line) and from README.md (## Status, first non-empty line). Compare via
# case-insensitive substring containment — wording variation allowed; phase
# identifier must match.
state_phase=$(awk '
  /^## Phase[[:space:]]*$/ { in_phase = 1; next }
  in_phase && /^## / { in_phase = 0 }
  in_phase && /^Current:/ {
    sub(/^Current:[[:space:]]*/, "")
    if (match($0, /[Pp]hase[[:space:]]+[A-Za-z0-9]+([[:space:]]+[A-Za-z]+)?/)) {
      print tolower(substr($0, RSTART, RLENGTH))
      exit
    }
  }
' state/current.md)
readme_phase=$(awk '
  /^## Status[[:space:]]*$/ { in_status = 1; next }
  in_status && /^## / { in_status = 0 }
  in_status && /[A-Za-z]/ {
    if (match($0, /[Pp]hase[[:space:]]+[A-Za-z0-9]+([[:space:]]+[A-Za-z]+)?/)) {
      print tolower(substr($0, RSTART, RLENGTH))
      exit
    }
  }
' README.md)
if [ -z "$state_phase" ]; then
  fail "README ↔ state: could not extract phase from state/current.md — expected 'Current:' line in '## Phase' section. File format may be corrupted."
fi
if [ -z "$readme_phase" ]; then
  fail "README ↔ state: could not extract phase from README.md — expected a 'Phase X status' line in '## Status' section."
fi
if [ -n "$state_phase" ] && [ -n "$readme_phase" ] && [ "$state_phase" != "$readme_phase" ]; then
  fail "README Status section out of sync with state/current.md. README says '$readme_phase'; state says '$state_phase'."
fi

# Check 11: DONE sign-off enforcement (per MS-007 Scope D3 + DEC-032 + MS-009 Section 5).
# Build the set of MSes whose DONE entry carries a non-pending Operator sign-off
# field (i.e. a DEC-032 magic-string was applied), parallel to check 9's done_mses.
# Then walk the same Depends on: MS-NNN lines and verify each target's DONE is signed.
# Skip targets that check 9 already failed on (DONE missing) to avoid double-fail noise.
signed_mses=$(awk '
  /^```/ { in_block = !in_block; next }
  !in_block && /^### / {
    if (in_done && ms != "" && status == "signed") print ms
    in_done = ($0 ~ /^### DONE-[0-9]+/); ms = ""; status = "unsigned"
  }
  in_done && /^- \*\*Method statement:\*\*/ {
    if (match($0, /MS-[0-9]+/)) ms = substr($0, RSTART, RLENGTH)
  }
  in_done && /^\*\*Operator sign-off:\*\*/ {
    rest = $0
    sub(/^\*\*Operator sign-off:\*\*[[:space:]]*/, "", rest)
    if (rest !~ /^[Pp]ending\.?[[:space:]]*$/) status = "signed"
  }
  END { if (in_done && ms != "" && status == "signed") print ms }
' forms/DONE.md | sort -u)

while IFS='|' read -r src target; do
  [ -z "$target" ] && continue
  # Skip if check 9 already failed on this target (DONE missing).
  grep -qx "$target" <<< "$done_mses" || continue
  if ! grep -qx "$target" <<< "$signed_mses"; then
    fail "DONE sign-off: $src cannot proceed — depends on $target whose DONE entry has 'Operator sign-off: pending' (not signed). DEC-032 magic-string must be applied at next session sign-in."
  fi
done < <(awk '
  /^```/ { in_block = !in_block; next }
  !in_block && /^### MS-[0-9]+/ {
    if (match($0, /MS-[0-9]+/)) current = substr($0, RSTART, RLENGTH)
  }
  !in_block && /^- \*\*Depends on:\*\*/ && !/[Nn]one/ {
    if (match($0, /MS-[0-9]+/)) print current "|" substr($0, RSTART, RLENGTH)
  }
' forms/METHOD_STATEMENT.md)

# Output.
if [ "${#FAILS[@]}" -eq 0 ]; then
  echo "VALIDATOR: PASS"
  exit 0
else
  echo "VALIDATOR: FAIL"
  for f in "${FAILS[@]}"; do
    echo "  - $f"
  done
  exit 1
fi
