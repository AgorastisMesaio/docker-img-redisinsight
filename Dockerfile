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
RUN apk add --no-cache sqlite bash sudo curl procps

# Allow the 'node' user to execute sudo commands without a password
RUN echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# In parallel su must be suid to work properly
RUN chmod u+s /bin/su

# Copy and run custom entrypoint scripts
RUN chown 1000:1000 /usr/src/app
ADD entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh
RUN chown 1000:1000 /usr/src/app/entrypoint.sh

# Copy healthcheck
ADD healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

# My custom health check
# I'm calling /healthcheck.sh so my container will report 'healthy' instead of running
# --interval=30s: Docker will run the health check every 'interval'
# --timeout=10s: Wait 'timeout' for the health check to succeed.
# --start-period=3s: Wait time before first check. Gives the container some time to start up.
# --retries=3: Retry check 'retries' times before considering the container as unhealthy.
HEALTHCHECK --interval=30s --timeout=10s --start-period=3s --retries=3 \
  CMD /healthcheck.sh || exit $?

# Let's do it right !
WORKDIR /usr/src/app
USER node

# Set the entrypoint
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

# The CMD line represent the Arguments that will be passed to the
# entrypoint.sh. We'll use them to indicate the script what
# command will be executed through our entrypoint when it finishes
CMD ["./docker-entry.sh", "node", "redisinsight/api/dist/src/main"]
