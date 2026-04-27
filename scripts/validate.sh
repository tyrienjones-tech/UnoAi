#!/usr/bin/env bash
# UnoAi structural-integrity validator (per DEC-026 + Procedure 9).
#
# Pure bash, no external deps. Runs from repo root: `bash scripts/validate.sh`.
# Wired into `.githooks/pre-commit` after gitleaks.
#
# Checks (eight, see DEC-026 acceptance):
#   1. DEC numbering: sequential, no gaps, no duplicates (DEC-001..DEC-NNN)
#   2. RFI numbering: sequential, no gaps, no duplicates
#   3. INC numbering: sequential, no gaps, no duplicates
#   4. MS numbering:  sequential
#   5. Closes: RFI-NNN cross-references in DECISION.md resolve to real RFIs
#   6. Supersedes: DEC-NNN cross-references resolve to real prior DECs
#   7. state/current.md "Latest XXX" counters match actual highest entry
#   8. Session lifecycle: every session-start has a matching session-end from
#      a prior session (allows ONE open session — the current one)
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
