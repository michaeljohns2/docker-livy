#!/bin/bash

if [ -z ${HOST+x} ]; then
  export LIBPROCESS_IP=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f8)
else
  export LIBPROCESS_IP=$HOST
fi

# copy resources
cp $LIVY_APP_PATH/upload/*jar $LIVY_APP_PATH/repl-jars
cp $LIVY_APP_PATH/upload/*.jar $LIVY_APP_PATH/rsc-jars

#bash
$LIVY_APP_PATH/bin/livy-server $@
