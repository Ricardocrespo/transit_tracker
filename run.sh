#!/bin/bash

FLAVOR=$1

if [[ "$FLAVOR" != "dev" && "$FLAVOR" != "prod" ]]; then
  echo "Usage: ./run.sh [dev|prod]"
  exit 1
fi

echo "Running TransitTracker with flavor: $FLAVOR"
flutter run --flavor $FLAVOR --dart-define=flavor=$FLAVOR -t lib/main.dart
