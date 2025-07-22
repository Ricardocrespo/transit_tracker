#!/bin/bash

FLAVOR=$1
OPTION=$2

if [[ "$FLAVOR" != "dev" && "$FLAVOR" != "prod" ]]; then
  echo "Usage: ./run.sh [dev|prod] [optional: --stacktrace|--info|--debug]"
  exit 1
fi

echo "Running TransitTracker with flavor: $FLAVOR"
if [[ -n "$OPTION" ]]; then
  flutter run --flavor $FLAVOR --dart-define=flavor=$FLAVOR $OPTION -t lib/main.dart
else
  flutter run --flavor $FLAVOR --dart-define=flavor=$FLAVOR -t lib/main.dart
fi