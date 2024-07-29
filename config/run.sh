#!/usr/bin/env bash
#
echo == EXAMPLE of custom script ==================
echo Running ./config/run.sh custom script.
echo Modify this file to execute any custom script
echo ==============================================

# Variables
export CONFIG_ROOT=/config
CONFIG_ROOT_MOUNT_CHECK=$(mount | grep ${CONFIG_ROOT})

# Let's make sure we are where we need to be
cd /usr/src/app

# Insert additional data into the db
if [ -f ${CONFIG_ROOT}/initdb.sql ]; then
    cp ${CONFIG_ROOT}/initdb.sql ./initdb.sql

    echo "Custom SQL initdb.sql copied"
    ( sleep 5; cat initdb.sql | sqlite3 /data/redisinsight.db; echo "Accepted the EULA, etc..." ) &

fi
