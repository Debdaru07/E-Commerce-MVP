#!/usr/bin/env bash
set -e

flutter config --enable-web
flutter pub get
flutter build web --release
