# Dockerfile for RedisInsight image
#
# This Dockerfile sets up a standard RedisIsngiht container that you can use
# inside your docker compose projects or standalone
#
FROM redis/redisinsight:latest

# Add sqlite so I can import custom config
#RUN apk update && apk upgrade
#RUN apk add --no-cache sqlite

# Copy custom entrypoint scripts
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# The CMD line represent the Arguments that will be passed to the
# /entrypoint.sh. We'll use them to indicate the script what
# command will be executed through our entrypoint when it finishes
CMD ["./docker-entry.sh" "node" "redisinsight/api/dist/src/main"]
