FROM node:22.18.0-alpine

# Update everything and install needed dependencies
RUN apk add --update graphicsmagick tzdata

# # Set a custom user to not have n8n run as root
USER root

# Copy the entrypoint script and set permissions
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

COPY ./workflows /workflows
RUN chmod +x /workflows

COPY ./credentials /credentials
RUN chmod +x /credentials

# Install n8n and the also temporary all the packages
# it needs to build it correctly.
RUN apk --update add --virtual build-dependencies python3 build-base ca-certificates && \
	npm_config_user=root npm install -g n8n && \
	apk del build-dependencies

RUN apk add git

# Set the entrypoint
ENTRYPOINT ["sh", "/docker-entrypoint.sh"]

WORKDIR /data

CMD ["/usr/local/bin/node", "/usr/local/bin/n8n", "start"]