#!/bin/sh

#  ci_post_clone.sh
#  Volume
#
#  Created by Vin Bui on 9/14/23.
#  Copyright © 2023 Cornell AppDev. All rights reserved.

echo "Installing Cocoapods Dependencies"
pod deintegrate
pod install

echo "Installing Apollo Client Dependencies"
brew install node
npm install -g apollo
npm install -g graphql

echo "Downloading Secrets"
brew install wget
cd $CI_WORKSPACE/ci_scripts
apollo schema:download --endpoint=$PROD_ENDPOINT ../Volume/Networking/schema.json
apollo codegen:generate --target=swift --includes='../**/*.graphql' --localSchemaFile='../Volume/Networking/schema.json' ../Volume/Networking/API.swift
wget -O ../Volume/Supporting/GoogleService-Info.plist "$GOOGLE_SERVICE_PLIST"
wget -O ../Volume/Supporting/Secrets.plist "$SECRETS_PLIST"
