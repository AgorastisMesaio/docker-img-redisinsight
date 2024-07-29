#!/usr/bin/env sh
#
# entrypoint.sh for Redisinsight
#
# Executed everytime the service is run
#
# This file is copied as /entrypoint.sh inside the container image.
#

# Variables
export CONFIG_ROOT=/config
CONFIG_ROOT_MOUNT_CHECK=$(mount | grep ${CONFIG_ROOT})

# Start custom script run.sh
if [ -f ${CONFIG_ROOT}/run.sh ]; then
    cp ${CONFIG_ROOT}/run.sh /run.sh
    chmod +x /run.sh
    /run.sh
fi

# Run the arguments from CMD in the Dockerfile
# In our case we are starting nginx by default
exec "$@"