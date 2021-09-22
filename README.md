# Volume

<p align="center"><img src=https://github.com/cuappdev/volume-ios/blob/master/Volume/Assets.xcassets/AppIcon.appiconset/marketing-1024-1x.png
width=210/></p>

Volume is one of the latest applications by [Cornell AppDev](http://cornellappdev.com), an engineering project team at Cornell University focused on mobile app development. Volume aims to amplify the voice of student publications, helping them reach a broader audience.

## Development

### 1. Installation

We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

To access the project, clone the project, and run `pod install` in the project directory.

### 2. Configuration

1. To build the project you need a `Supporting/Secrets.plist` file in the project.

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

AppDev members can access the `Supporting/Secrets.plist` file via a pinned message in the `#volume-ios` channel.

2.  Volume uses GraphQL instead of a RESTful API, so you need a `schema.json`. To get a `schema.json`, run the following command in the project directory: `apollo schema:download --endpoint={Backend_URL} schema.json`. This should add a new `schema.json` file in the main project directory. Move it to the `Networking` directory and make sure it's in the `Networking` group within your Xcode project.

3.  AppDev uses Firebase for event logging which requires a `GoogleService-Info.plist` file in the project.

AppDev members can access the `GoogleService-Info.plist` file via a pinned message in the `#volume-ios` channel.
Place the file in the `Volume/` directory.

4.  Finally, you need to generate `API.swift`. The Apollo iOS pod offers a build run script to do this. Go to the Volume target Build Phases and click the plus to add a new Run Script Phase. Name it something like "Generate Apollo GraphQL API", and paste in the following script. When you build, Xcode will autogenerate `API.swift` if one of the query or mutation `.graphql` files has changed.

```bash
SCRIPT_PATH="${PODS_ROOT}/Apollo/scripts"
cd "${SRCROOT}/${TARGET_NAME}"

"${SCRIPT_PATH}"/run-bundled-codegen.sh codegen:generate --target=swift --includes=./**/*.graphql --localSchemaFile="Networking/schema.json" Networking/API.swift
```

Finally, open `Volume.xcworkspace` and enjoy Volume!

## Analytics

A custom cocoapod, [`AppDevAnalytics`](https://github.com/cuappdev/analytics-ios), is used to setup Volume's data pipeline.

`AppDevAnalytics` uses Google Firebase to log user actions and this data is linked to a Google BigQuery data warehouse.
All produced data is anonymized with potentially identifying information removed.
A full list of all events and their associated data is listed under [`Volume/Analytics/Events.md`](./Volume/Analytics/Events.md)
