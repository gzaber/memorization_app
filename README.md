<a href="https://github.com/gzaber/memorization_app/actions"><img src="https://img.shields.io/github/workflow/status/gzaber/memorization_app/main" alt="build"></a>
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

[<img alt="Decks overview" width="200px" src=".screenshots/decks_overview.png" />](.screenshots/decks_overview.png)
[<img alt="Create deck" width="200px" src=".screenshots/manage_deck_create.png" />](.screenshots/manage_deck_create.png)
[<img alt="CSV link dialog" width="200px" src=".screenshots/manage_deck_csv_link_dialog.png" />](.screenshots/manage_deck_csv_link_dialog.png)
[<img alt="Horizontal layout" width="200px" src=".screenshots/deck_horizontal_layout.png" />](.screenshots/deck_horizontal_layout.png)
[<img alt="Menu items" width="200px" src=".screenshots/deck_menu.png" />](.screenshots/deck_menu.png)
[<img alt="Entry layout dialog" width="200px" src=".screenshots/deck_entry_layout_dialog.png" />](.screenshots/deck_entry_layout_dialog.png)
[<img alt="Expand / collapse layout" width="200px" src=".screenshots/deck_expand_collapse_layout.png" />](.screenshots/deck_expand_collapse_layout.png)
[<img alt="Update deck" width="200px" src=".screenshots/manage_deck_update.png" />](.screenshots/manage_deck_update.png)
[<img alt="Delete deck" width="200px" src=".screenshots/deck_delete.png" />](.screenshots/deck_delete.png)
[<img alt="Settings" width="200px" src=".screenshots/settings.png" />](.screenshots/settings.png)
[<img alt="Settings dark theme" width="200px" src=".screenshots/settings_dark.png" />](.screenshots/settings_dark.png)
[<img alt="Decks overview dark theme" width="200px" src=".screenshots/decks_overview_dark.png" />](.screenshots/decks_overview_dark.png)

## Features

- create, update, delete deck
- download entries from GoogleSheets
- different layouts for entries
- light / dark theme
- different font sizes
- supported locales: en, pl

## Packages used

- equatable
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

For local packages run above command in package root directory.

## Run

Create Google Sheets file. Fill in the first two columns with data. Publish file on the web as a CSV file. Use generated link in the application.

[<img alt="Google Sheets data" width="200px" src=".screenshots/gs_data.png" />](.screenshots/gs_data.png)

Run the application using your IDE or using the following command:

```
$ flutter run
```
