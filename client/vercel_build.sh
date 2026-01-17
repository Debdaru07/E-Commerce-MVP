#!/bin/bash
set -e

echo "Installing Flutter SDK"
git clone https://github.com/flutter/flutter.git -b stable --depth 1

export PATH="$PATH:`pwd`/flutter/bin"

flutter doctor
flutter config --enable-web

flutter pub get

# 🔥 FORCE HTML RENDERER
flutter build web --release --web-renderer html