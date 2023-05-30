# copy pre-commit to git folder
/bin/cp -f hooks/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# get dependencies
flutter pub get

# run build runner, for translations, database, etc.
dart run build_runner build --delete-conflicting-outputs