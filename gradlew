#!/usr/bin/env sh
if command -v gradle >/dev/null 2>&1; then
  exec gradle "$@"
fi
echo "Gradle is not installed. Open the project in Android Studio or run: gradle wrapper --gradle-version 9.6.0" >&2
exit 1
