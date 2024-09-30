# ToDos
ToDos — an app to keep track of your to-dos. Allows you to import, add, check off, and delete the tasks you need to complete — easy to glance and filter.

![](https://github.com/pkuecuekyan/ToDos/blob/main/ToDosRecording.gif)

## Technologies used
* SwiftUI and reactive programming
* Combine for fetching and processing
* SwiftData for state management and persistence

## Components
* `TodoView` as the main view, with `ListView` to display tasks
* `TodoWriter` to for all CRUD operations
* `TodoImporter` to manage remote fetches

## Testing
* Run unit tests in `TodoWriterTests` to verify CRUD operations, `TodoImporterTests` to ensure proper importing
* UI test suite in `TodosUITests` will evaluate UI elements and functioning of adding and deleting tasks.

## Requirements
macOS; optimized for iOS 17.5 or newer; Xcode 15.4 or newer. 

## How to run 
1. The app? Simply open the project in the Finder or via command line with `open ToDos.xcodeproj`. Once opened, press ⌘R to see the app in action in the iOS Simulator.
2. The tests? Simply press ⌘T and see progress in the testing pane or watch the iOS simulator observe the UI tests.
