#!/usr/bin/env bash

# Test an HTTP site, return any error or http error
curl_test() {
    MSG=$1
    ERR=$2
    URL=$3
    echo -n ${MSG}
    http_code=`curl -o /dev/null -s -w "%{http_code}\n" ${URL}`
    ret=$?
    if [ "${ret}" != 0 ]; then
        echo " - ${ERR}, return code: ${ret}"
        return ${ret}
    else
        if [ "${http_code}" != 200 ]; then
            echo " - ${ERR}, HTTP code: ${http_code}"
            return 1
        fi
    fi
    return 0
}

# Test redisinsight
PORT=5540
curl_test "Test redisinsight http" "Error testing redisinsight :${PORT}" "http://${HOSTNAME}:${PORT}" || { ret=${?}; exit ${ret}; }
echo " Ok."

# All passed
exit 0
