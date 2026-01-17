#!/bin/bash
set -e

echo "Installing Flutter SDK"
git clone https://github.com/flutter/flutter.git -b stable --depth 1

export PATH="$PATH:`pwd`/flutter/bin"

flutter config --enable-web
flutter pub get

# ✅ CORRECT FOR FLUTTER 3.38+
flutter build web --release \
  --dart-define=FLUTTER_WEB_RENDERER=html