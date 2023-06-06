# Better HM

Inoffizielle App für die Hochschule München

## Installation

[<img src="https://play.google.com/intl/en_gb/badges/images/generic/en_badge_web_generic.png" alt="Get it on Google Play" width="150" />](https://play.google.com/store/apps/details?id=de.moritzhuber.betterHm)<br>

Google Play and the Google Play logo are trademarks of Google LLC.

Wer neue Features etwas früher ausprobieren möchte, kann sich gerne zur Beta anmelden (entweder im PlayStore
oder [hier](https://play.google.com/apps/testing/de.moritzhuber.betterHm)). Die Beta ist prinzipiell stabil, kann aber
vereinzelt Bugs enthalten.

Wer einen Link zu den nightly-builds vom master branch haben will, kontaktiert mich bitte direkt.

## Features

- Essensplan aller Mensen des Münchner Studentenwerks
- bald: Dashboard mit aktuellen Informationen

## Setup

Dies ist unter der Annahme, dass [flutter](https://flutter.dev) bereits installiert ist

```bash
# clone the repo
git clone https://github.com/Huber1/betterHM better_hm
cd better_hm

# setup commit hooks, get dependencies, run build-runner
./setup.sh
```