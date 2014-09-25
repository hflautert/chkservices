#!/bin/sh

BINARY=chkservices
BINARY_TARGET=/usr/bin
INITSCRIPT=init.d/chkservices
INITSCRIPT_TARGET=/etc/init.d

cp "$BINARY" "$BINARY_TARGET"
cp "$INITSCRIPT" "$INITSCRIPT_TARGET"

chmod 755 "$BINARY_TARGET/$BINARY"
chmod 755 "$INITSCRIPT_TARGET/`basename $INITSCRIPT`"

chkconfig chkservices on