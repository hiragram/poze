#!/bin/bash -eux

PROJECT_ROOT=$(cd $(dirname $0); cd ../ ; pwd)
SCRIPTS_DIR=$PROJECT_ROOT/scripts

if [ "$CI_WORKFLOW" = "Release配信" ]; then

    # CrashlyticsにdSYMをアップロード
    $SCRIPTS_DIR/upload-dsyms $CI_ARCHIVE_PATH/dSYMs $PROJECT_ROOT/App/GoogleService-Info.plist
fi