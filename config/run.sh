#!/usr/bin/env bash
#
echo == EXAMPLE of custom script ==================
echo Running ./config/run.sh custom script.
echo Modify this file to execute any custom script
echo ==============================================

# Variables
export CONFIG_ROOT=/config
CONFIG_ROOT_MOUNT_CHECK=$(mount | grep ${CONFIG_ROOT})

# Start custom script run.sh
if [ -f ${CONFIG_ROOT}/initdb.sql ]; then
    cp ${CONFIG_ROOT}/initdb.sql /initdb.sql
    echo "A custom SQL has been copied"

    echo "Add here anything you want to customize your initial SQLite DB"
fi
