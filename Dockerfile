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

# Copy and run custom entrypoint scripts
ADD custom_entrypoint.sh /custom_entrypoint.sh
RUN chmod +x /custom_entrypoint.sh
RUN /custom_entrypoint.sh

# Set the entrypoint
#ENTRYPOINT ["/custom_entrypoint.sh"]

# Let's do it right !
WORKDIR /usr/src/app
USER node

# The CMD line represent the Arguments that will be passed to the
# /entrypoint.sh. We'll use them to indicate the script what
# command will be executed through our entrypoint when it finishes
CMD ["./docker-entry.sh" "node" "redisinsight/api/dist/src/main"]
