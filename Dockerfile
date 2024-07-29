# Dockerfile for RedisInsight image
#
# This Dockerfile sets up a standard RedisIsngiht container that you can use
# inside your docker compose projects or standalone
#
FROM redis/redisinsight:latest

# Let's have all the rights
USER root

# Add sqlite so I can import custom config
RUN apk update && apk upgrade
RUN apk add --no-cache sqlite bash

# Let's do it right !
WORKDIR /usr/src/app
USER node

# Copy and run custom entrypoint scripts
ADD entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

# The CMD line represent the Arguments that will be passed to the
# entrypoint.sh. We'll use them to indicate the script what
# command will be executed through our entrypoint when it finishes
CMD ["./docker-entry.sh" "node" "redisinsight/api/dist/src/main"]
