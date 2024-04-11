#!/bin/sh

#  ci_post_clone.sh
#  Volume
#
#  Created by Vin Bui on 9/14/23.
#  Copyright © 2023 Cornell AppDev. All rights reserved.

echo "Installing Swiftlint via Homebrew"
brew install swiftlint

echo "Downloading Secrets"
brew install wget
cd $CI_PRIMARY_REPOSITORY_PATH/ci_scripts
mkdir ../VolumeSecrets
wget -O ../VolumeSecrets/apollo-codegen-config-dev.json "$CODEGEN_DEV"
wget -O ../VolumeSecrets/apollo-codegen-config-prod.json "$CODEGEN_PROD"
wget -O ../VolumeSecrets/Secrets.plsit "$SECRETS_PLIST"
wget -O ../VolumeSecrets/GoogleService-Info.plist "$GOOGLE_SERVICE_PLIST"

echo "Generating API file"
../apollo-ios-cli generate -p "../VolumeSecrets/apollo-codegen-config-prod.json" -f
