#FROM alpine:3.12

LABEL com.github.actions.name="Broken Link Checker" \
      com.github.actions.description="Find broken links in your website" \
      com.github.actions.icon="code" \
      com.github.actions.color="red" \
      maintainer="ocular-d <sven@ocular-d.tech>"

RUN apk add --no-cache bash nodejs npm jq

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/bash -D node

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
