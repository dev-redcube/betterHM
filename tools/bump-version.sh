BUMP="$1"

#CURRENT_BUILD_NUMBER=$(grep "^version: .*+[0-9]\+$" pubspec.yaml | cut -d "+" -f2)
#NEXT_BUILD_NUMBER=$CURRENT_BUILD_NUMBER

#set $((NEXT_BUILD_NUMBER++))

CURRENT_VERSION=$(grep -o -P "(?<=version: )\d+\.\d+\.\d+" pubspec.yaml)
MAJOR=$(echo "$CURRENT_VERSION" | cut -d '.' -f1)
MINOR=$(echo "$CURRENT_VERSION" | cut -d '.' -f2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d '.' -f3)

echo "$CURRENT_VERSION"

if [[ "$BUMP" == "major" ]]; then
  MAJOR=$((MAJOR + 1))
  MINOR=0
  PATCH=0
elif [ "$BUMP" == "minor" ]; then
  MINOR=$((MINOR + 1))
  PATCH=0
elif [ "$BUMP" == "patch" ]; then
  PATCH=$((PATCH + 1))
else
    echo 'Expected <major|minor|patch> for the server argument'
    exit 1;
fi

NEXT_VERSION=$MAJOR.$MINOR.$PATCH

sed -i -e "s/version: $CURRENT_VERSION/version: $NEXT_VERSION/" pubspec.yaml

echo "APP_VERSION=v$NEXT_VERSION" >> "$GITHUB_ENV"