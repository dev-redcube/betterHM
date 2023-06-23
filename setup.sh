# copy pre-commit to git folder
/bin/cp -f hooks/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

flutter clean

# get dependencies
flutter pub get

# run build runner, for translations, database, etc.
find . -name "*.g.dart" -type f -delete
find . -name "*.mocks.dart" -type f -delete
dart run build_runner build --delete-conflicting-outputs