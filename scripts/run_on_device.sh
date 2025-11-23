#!/usr/bin/env bash
# Simple helper to run the Flutter app on a device.
# Usage: ./scripts/run_on_device.sh [deviceId]

set -euo pipefail

if [ "$#" -gt 1 ]; then
  echo "Usage: $0 [deviceId]"
  exit 1
fi

if [ "$#" -eq 1 ]; then
  DEVICE="$1"
else
  # try to pick first non-desktop device
  DEVICE=$(flutter devices --machine | jq -r '.[] | select(.platformType=="android" or .platformType=="ios") | .id' | head -n1)
fi

if [ -z "${DEVICE:-}" ]; then
  echo "No mobile device/emulator found. Run 'flutter devices' to list devices or start an emulator." >&2
  exit 2
fi

echo "Running on device: $DEVICE"
flutter run -d "$DEVICE"
