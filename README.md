<a href="https://github.com/gzaber/memorization_app/actions"><img src="https://img.shields.io/github/actions/workflow/status/gzaber/memorization_app/main.yaml" alt="build"></a>
<a href="https://codecov.io/gh/gzaber/memorization_app"><img src="https://codecov.io/gh/gzaber/memorization_app/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/gzaber/memorization_app" alt="license MIT"></a>

# memorization_app

A mobile application designed to support learning vocabulary and definitions.  
Learning materials can be downloaded from the Google Sheets files published on the web as CSV files.

## Table of contents

- [Screenshots](#screenshots)
- [Features](#features)
- [Packages used](#packages-used)
- [Setup](#setup)
- [Test](#test)
- [Run](#run)

## Screenshots

[<img alt="decks overview page" width="250px" src=".screenshots/decks_overview_page.png" />](.screenshots/decks_overview_page.png)
&nbsp;
[<img alt="deck page" width="250px" src=".screenshots/deck_page.png" />](.screenshots/deck_page.png)
&nbsp;
[<img alt="manage deck page" width="250px" src=".screenshots/manage_deck_page.png" />](.screenshots/manage_deck_page.png)

[<img alt="manage deck recording" width="250px" src=".screenshots/manage_deck_recording.gif" />](.screenshots/manage_deck_recording.gif)
&nbsp;
[<img alt="deck recording" width="250px" src=".screenshots/deck_recording.gif" />](.screenshots/deck_recording.gif)
&nbsp;
[<img alt="settings recording" width="250px" src=".screenshots/settings_recording.gif" />](.screenshots/settings_recording.gif)

## Features

- create, update, delete deck
- download entries from GoogleSheets
- different layouts for entries
- light / dark theme
- different font sizes
- supported locales: en, pl

## Packages used

- bloc
- csv
- hive
- http

## Setup

Clone or download this repository.  
Use the following command to install all the dependencies:

```
$ flutter pub get
```

## Test

Run the tests using your IDE or using the following command:

```
$ flutter test --coverage
```

For local Dart packages run the following commands in the package root directory:

```
$ dart pub global activate coverage
$ dart pub global run coverage:test_with_coverage
```

## Run

Create Google Sheets file. Fill in the first two columns with data. Publish file on the web as a CSV file. Use generated link in the application.

[<img alt="Google Sheets data" width="200px" src=".screenshots/gs_data.png" />](.screenshots/gs_data.png)

Run the application using your IDE or using the following command:

```
$ flutter run
```
