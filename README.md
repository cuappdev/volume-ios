# Volume

<p align="center"><img src=https://github.com/cuappdev/volume-ios/blob/master/Volume/Assets.xcassets/AppIcon.appiconset/Logo%20%232-1024.png
width=210/></p>

Volume is one of the latest applications by [Cornell AppDev](http://cornellappdev.com), an engineering project team at Cornell University focused on mobile app development. Volume aims to amplify the voice of student publications, helping them reach a broader audience.

## Development

### Installation

We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

To access the project, clone the project, and run `pod install --repo-update` in the project directory.

### Configuration

#### 1. Secrets

To build the project you need a `Supporting/Secrets.plist` file in the project.

<details>
  <summary>Secrets.plist Template</summary>
  
  ```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>appdev-website</key>
	<string>https://www.cornellappdev.com/</string>
	<key>feedback-form</key>
	<string>YOUR_FEEDBACK_FORM_URL</string>
	<key>graphql-endpoint-production</key>
	<string>YOUR_GRAPHQL_PROD_ENDPOINT</string>
	<key>graphql-endpoint-debug</key>
	<string>YOUR_GRAPHQL_DEBUG_ENDPOINT</string>
	<key>openarticle-url</key>
	<string>YOUR_OPENARTICLE_URL</string>
	<key>announcements-scheme</key>
	<string>YOUR_ANNOUNCEMENTS_SCHEME</string>
	<key>announcements-host</key>
	<string>YOUR_ANNOUNCEMENTS_ENDPOINT_HOST</string>
	<key>announcements-common-path</key>
	<string>/YOUR_ANNOUNCEMENTS_ENDPOINT_COMMON_PATH</string>
	<key>announcements-path</key>
	<string>/YOUR_ANNOUNCEMENTS_ENDPOINT_PATH/</string>
</dict>
</plist>
```
</details>

AppDev members can access the `Supporting/Secrets.plist` file via a pinned message in the `#volume-ios` channel.

#### 2. Firebase

AppDev uses Firebase for event logging which requires a `GoogleService-Info.plist` file, obtained from a Firebase project.

AppDev members can access the `GoogleService-Info.plist` file via a pinned message in the `#volume-ios` channel.
Place the file in the `Volume/Supporting/` directory.

#### 3. Apollo

Volume uses GraphQL instead of a RESTful API. To aid with iOS compatibility, we use [Apollo](apollographql.com) to generate Swift objects that correspond to the `schema.json` specification provided by the backend. Follow [this article](https://www.apollographql.com/docs/devtools/cli/) to install the Apollo CLI. Once installed, run this command from the project's home directory (`volume-ios`). 

```bash
apollo schema:download --endpoint="https://YOUR-BACKEND-URL.com/graphql" Volume/Networking/schema.json
```

Double check that a `schema.json` file has been added to the `Networking` directory in your Xcode project. 

Then, in Xcode, in the Volume target under Build Phases, make sure there is a phase called "Generate Apollo GraphQL API" before "Compile Sources." If not, create one with this script: 

```bash
SCRIPT_PATH="${PODS_ROOT}/Apollo/scripts"
cd "${SRCROOT}/${TARGET_NAME}"

"${SCRIPT_PATH}"/run-bundled-codegen.sh codegen:generate --target=swift --includes=./**/*.graphql --localSchemaFile="Networking/schema.json" Networking/API.swift
```

This will auto-generate an `API.swift` file with Swift objects that correspond to the given `schema.json` and `.graphql` files. 

## Analytics

A custom cocoapod, [`AppDevAnalytics`](https://github.com/cuappdev/analytics-ios), is used to setup Volume's data pipeline.

`AppDevAnalytics` uses Google Firebase to log user actions and this data is linked to a Google BigQuery data warehouse.
All produced data is anonymized with potentially identifying information removed.
A full list of all events and their associated data is listed under [`Volume/Analytics/Events.md`](./Volume/Analytics/Events.md)
