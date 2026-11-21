#!/usr/bin/env bash
set -euo pipefail

echo "Starting demo test..."

if [ ! -f output/build-info.txt ]; then
  echo "ERROR: Build artifact not found!"
  exit 1
fi

grep -q "Demo build successful" output/build-info.txt

echo "Test passed successfully."
