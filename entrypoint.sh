#!/usr/bin/env bash
#
# entrypoint.sh for Redisinsight
#
set -x

# Variables
export CONFIG_ROOT=/config
CONFIG_ROOT_MOUNT_CHECK=$(mount | grep ${CONFIG_ROOT})

# Let's make sure we are where we need to be
cd /usr/src/app

# Start custom script run.sh
if [ -f ${CONFIG_ROOT}/run.sh ]; then
    cp ${CONFIG_ROOT}/run.sh ./run.sh
    chmod +x ./run.sh
    ./run.sh
fi

pwd

# Run the arguments from CMD in the Dockerfile
# In our case we are starting nginx by default
exec "$@"
