setup:
	# copy pre-commit to git folder
	/bin/cp -f hooks/pre-commit.sh .git/hooks/pre-commit
	chmod +x .git/hooks/pre-commit

	flutter clean
	flutter pub get

	# run build_runner
	find . -name "*.g.dart" -type f -delete
	find . -name "*.mocks.dart" -type f -delete
	dart run build_runner build --delete-conflicting-outputs

analyze:
	flutter analyze

fix:
	dart fix --apply

format:
	dart format .

buildrunner:
	dart run build_runner build --delete-conflicting-outputs

lang:
	dart run slang

apk:
	flutter build apk

linux:
	flutter build linux
