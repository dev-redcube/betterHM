flutter analyze .

# Get all staged dart files
staged=$(git -P diff --name-only --cached --diff-filter=AM | grep -E '\.dart$')

# exit if nothing matches
[[ -z "$staged" ]] && exit 0

# shellcheck disable=SC2086
dart fix --apply $staged

# shellcheck disable=SC2086
dart format $staged

# shellcheck disable=SC2086
git add $staged
