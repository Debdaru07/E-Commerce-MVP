#!/usr/bin/env bash

# Exit on error
set -e

# Enable Flutter Web
flutter config --enable-web

# Get packages
flutter pub get

# Build Flutter Web
flutter build web --release