#!/usr/bin/env bash
set -e

echo "📦 Installing Flutter SDK..."

git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

flutter --version

echo "🌐 Enabling Flutter Web..."
flutter config --enable-web

echo "📦 Getting dependencies..."
flutter pub get

echo "🚀 Building Flutter Web..."
flutter build web --release --base-href /

echo "✅ Flutter Web build completed"