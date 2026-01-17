#!/bin/bash
set -e

echo "🔧 Installing Flutter SDK"
git clone https://github.com/flutter/flutter.git -b stable --depth 1

export PATH="$PATH:$(pwd)/../flutter/bin"

flutter config --enable-web
flutter pub get

echo "🚀 Building Flutter Web"
flutter build web --release \
  --dart-define=BASE_URL=$BASE_URL \
  --dart-define=ADMIN_LOGIN=$ADMIN_LOGIN \
  --dart-define=DEALER_LOGIN=$DEALER_LOGIN \
  --dart-define=CONSUMER_LOGIN=$CONSUMER_LOGIN \
  --dart-define=DEALER_SIGNUP=$DEALER_SIGNUP \
  --dart-define=CONSUMER_SIGNUP=$CONSUMER_SIGNUP \
  --dart-define=FLUTTER_WEB_RENDERER=html \
  --no-wasm-dry-run