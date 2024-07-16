#!/bin/bash
set -e

# Update host Gemfile.lock on startup. Otherwise, the Gemfile.lock won't get updated on GH
cp /$LOCK_PATH/* /$APP_PATH/

# run passed commands
exec "$@"
