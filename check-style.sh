#!/bin/sh

if [ ! -d "$WEBKIT_SOURCE_DIR" ]; then
    echo "I don't know where WebKit source code is, please set WEBKIT_SOURCE_DIR environment variable."
    exit 1
fi

FILES_TO_CHECK=`find \( -name \*.cpp -o -name \*.h \) -not -name \*moc_\* -not -name \*qrc\*`
"$WEBKIT_SOURCE_DIR"/Tools/Scripts/check-webkit-style --filter -build/include_order $FILES_TO_CHECK
