# Redcube Campus

Inoffizielle App für die Hochschule München

## Installation

[<img src="https://play.google.com/intl/en_gb/badges/images/generic/en_badge_web_generic.png" alt="Get it on Google Play" width="150" />](https://play.google.com/store/apps/details?id=de.moritzhuber.betterHm)<br>

Google Play and the Google Play logo are trademarks of Google LLC.

Wer einen Link zu den nightly-builds vom master branch haben will, kontaktiert mich bitte direkt.

## Features

- Dashboard mit nützlichen Infos, aktuell:
    - Kurzlinks z.b. zu Moodle, ZPA, Nine, etc.
    - MVG abfahrten an den Münchner Hochschulstandorten
    - HM-Kinoprogramm
- Kalender, der beliebige ical-Kalenderdateien anzeigen kann (z.B. die Stundenpläne von ZPA oder NINE)
- Essensplan der Mensen des Münchner Studentenwerks

## Roadmap
- [Offene Issues => konkrete Planung](https://github.com/dev-redcube/betterHM/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)
- [Potenzielle Ideen => Hilfe bei Umsetzung willkommen](https://github.com/orgs/dev-redcube/projects/2/views/6)
- Im obigen Projekt steht auch manchmal konkreteres 

## Setup

### Lokal:

Dies ist unter der Annahme, dass [flutter](https://flutter.dev) bereits installiert ist

```bash
# clone the repo
git clone https://github.com/dev-redcube/betterHM redcube_campus
cd redcube_campus

# setup commit hooks, get dependencies, run build-runner
make setup
```

sollten nach `git pull` Fehler auftreten, hilft meist, erneut `make setup` oder `make buildrunner` auszuführen, um den
Code-generator nochmal laufen zu lassen
