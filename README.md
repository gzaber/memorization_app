# memorization_app

A mobile application designed to support learning vocabulary and definitions.  
Learning materials are downloaded from the Google Sheets files.

## Table of contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Technologies](#technologies)
- [Setup](#setup)
- [Launch](#launch)
- [Test](#test)

## Features

- Create, update, delete deck
- Different entry layouts
- Light / dark theme
- Different font sizes

## Screenshots

[<img alt="Home screen light theme" width="200px" src="_screenshots/home_light.png" />](_screenshots/home_light.png)
[<img alt="Home screen dark theme" width="200px" src="_screenshots/home_dark.png" />](_screenshots/home_dark.png)
[<img alt="Create deck" width="200px" src="_screenshots/create_deck.png" />](_screenshots/create_deck.png)
[<img alt="Row layout" width="200px" src="_screenshots/row_layout.png" />](_screenshots/row_layout.png)
[<img alt="Expand, collapse layout" width="200px" src="_screenshots/expansion_layout.png" />](_screenshots/expansion_layout.png)
[<img alt="Menu items" width="200px" src="_screenshots/menu.png" />](_screenshots/menu.png)
[<img alt="Entry layout dialog" width="200px" src="_screenshots/entry_layout_dialog.png" />](_screenshots/entry_layout_dialog.png)
[<img alt="Update deck" width="200px" src="_screenshots/update_deck.png" />](_screenshots/update_deck.png)
[<img alt="CSV link dialog" width="200px" src="_screenshots/csv_link.png" />](_screenshots/csv_link.png)
[<img alt="Delete deck" width="200px" src="_screenshots/delete_deck.png" />](_screenshots/delete_deck.png)
[<img alt="Settings screen" width="200px" src="_screenshots/settings.png" />](_screenshots/settings.png)

## Technologies

- Dart
- Flutter
- BLoC / Cubit
- Hive

## Setup

Clone or download this repository.  
Use the following command to install all the dependencies:

```
flutter pub get
```

Use the following command to update to the latest compatible versions of all the dependencies :

```
flutter pub upgrade
```

Use the following command to create platform-specific folders:

```
flutter create .
```

## Launch

Create Google Sheets file. Fill in the first two columns with data. Publish file on the web as a csv file. Use generated link in the application.

[<img alt="Settings screen" width="200px" src="_screenshots/gs_data.png" />](_screenshots/gs_data.png)

Run the application using your IDE or using the following command:

```
flutter run
```

## Test

Run the tests using your IDE or using the following command:

```
flutter test
```
