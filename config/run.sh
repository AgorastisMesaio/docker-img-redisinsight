#!/usr/bin/env bash
#

echo "****************************************************************************"
echo "<< run.sh >> | Custom script"

# Variables
export CONFIG_ROOT=/config
CONFIG_ROOT_MOUNT_CHECK=$(mount | grep ${CONFIG_ROOT})

# Let's make sure we are where we need to be
cd /usr/src/app
TARGETDB="/data/redisinsight.db"

# Wait a bit and try to update the DB
if [ -f ${CONFIG_ROOT}/custom.sql ]; then
    # If it's the first run then the persistent DB doesn't exist.
    if [ ! -f ${TARGETDB} ]; then

        echo "****************************************************************************"
        echo "<< run.sh >> | FIRST RUN !!!"
        echo "<< run.sh >> | ${CONFIG_ROOT}/custom.sql exists"
        echo "<< run.sh >> | ${TARGETDB} doesn't exist"
        echo "****************************************************************************"

        # Let the app perform it's initial setup. Start the server
        # wait for it and kill it :-)

        # Start the Node.js server in the background
        node redisinsight/api/dist/src/main &

        # Save the process ID (PID) for later use
        SERVER_PID=$!

        # Wait for 5 seconds to allow the server to start
        sleep 5

        # Define the server URL and the number of attempts
        SERVER_URL="http://127.0.0.1:5540"
        MAX_ATTEMPTS=10

        # Function to check if the server is responding
        check_server() {
            curl --silent --head --fail $SERVER_URL > /dev/null
            return $?
        }

        # Try to connect to the server with a maximum of 10 attempts
        for ((i=1; i<=MAX_ATTEMPTS; i++))
        do
            if check_server; then
                echo "<< run.sh >> | Server is responding at $SERVER_URL"
                break
            else
                echo "<< run.sh >> | Server is not responding. Attempt $i of $MAX_ATTEMPTS..."
                sleep 2
            fi
        done

        # Check if the server is still not responding after all attempts
        if ! check_server; then
            echo "<< run.sh >> | Server failed to start after $MAX_ATTEMPTS attempts."
        else
            echo "****************************************************************************"
            echo "<< run.sh >> | Server successfully started and is responding."
            echo "****************************************************************************"

            # Kill the server with SIGTERM
            kill -SIGTERM $SERVER_PID

            # Wait for the process to terminate
            TIMEOUT=20
            for ((i=1; i<=TIMEOUT; i++))
            do
                if ps -p $SERVER_PID > /dev/null; then
                    echo "<< run.sh >> | Waiting for server process $SERVER_PID to terminate... $i sec"
                    sleep 1
                else
                    echo "<< run.sh >> | Server process $SERVER_PID has terminated."
                    break
                fi
            done

            # Final check if the process is still running after the timeout
            if ps -p $SERVER_PID > /dev/null; then
                echo "<< run.sh >> | Server process $SERVER_PID did not terminate after $TIMEOUT seconds."
            else
                echo ""
                echo "****************************************************************************"
                echo "<< run.sh >> | Server process $SERVER_PID successfully terminated."

                # Time to modify the DB
                cat ${CONFIG_ROOT}/custom.sql | sqlite3 ${TARGETDB}
                echo "<< run.sh >> | Modified ${TARGETDB} with ${CONFIG_ROOT}/custom.sql"
                echo "<< run.sh >> | Exiting so standard CMD will be run"
                echo "****************************************************************************"
                echo ""
                echo "****************************************************************************"
            fi
        fi
    else
        echo "****************************************************************************"
        echo "<< run.sh >> | Database already exists: ${TARGETDB} - NORMAL BOOT -   "
        echo "****************************************************************************"
    fi
fi
