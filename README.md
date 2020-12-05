# Volume

<p align="center"><img src=https://images.squarespace-cdn.com/content/59370444b8a79b445e67187e/1582941016703-XASMW24H32I3SZAF4UU3/ruby.png?content-type=image%2Fpng width=210/></p>

<sup>_Actual logo coming soon!_</sup>

Volume is one of the latest applications by [Cornell AppDev](http://cornellappdev.com), an engineering project team at Cornell University focused on mobile app development. Volume aims to amplify the voice of student publications, helping them reach a broader audience.

## Development

### 1. Installation

We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

To access the project, clone the project, and run `pod install` in the project directory.

### 2. Configuration

1. To build the project you need a `Supporting/Keys.plist` file in the project.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>graphql-endpoint-production</key>
  <string>your graphql prod endpoint</string>
  <key>your garphql debug endpoint</key>
  <string>http://volume-backend.cornellappdev.com/graphql</string>
</dict>
</plist>
```

For AppDev members, the `Supporting/Keys.plist` file is pinned in the `#volume-ios` channel.

2.  Volume uses GraphQL instead of a RESTful API, so you need a `schema.json`. Add it in the `Networking` group

3.  Finally, you need to generate `API.swift`. The Apollo iOS pod offers a build run script to do this. Go to the Volume target Build Phases and click the pluss to add a new Run Script Phase. Name it something like "Generate Apollo GraphQL API", and paste in the following script. When you build, Xcode will autogenerate `API.swift` if one of the query or mutation `.graphql` files has changed.

```bash
SCRIPT_PATH="${PODS_ROOT}/Apollo/scripts"
cd "${SRCROOT}/${TARGET_NAME}"

"${SCRIPT_PATH}"/run-bundled-codegen.sh codegen:generate --target=swift --includes=./**/*.graphql --localSchemaFile="Networking/schema.json" Networking/API.swift
```

Finally, open `Volume.xcworkspace` and enjoy Volume!