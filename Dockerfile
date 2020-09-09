FROM alpine:3.12

LABEL com.github.actions.name="Broken Link Checker" \
      com.github.actions.description="Find broken links in your website" \
      com.github.actions.icon="code" \
      com.github.actions.color="red" \
      maintainer="ocular-d <sven@ocular-d.tech>"

# hadolint ignore=DL3018
RUN apk add --no-cache bash nodejs npm jq \
    && addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/bash -D node -h /app

USER node
WORKDIR /app
RUN mkdir "$HOME/.npm-global" \
    && npm config set prefix "$HOME/.npm-global" \
    && echo "export PATH=$HOME/.npm-global/bin:$PATH" >> "$HOME"/.bashrc \
    && /bin/bash -c "source $HOME/.bashrc"


COPY --chown=node:node package.json package.json
COPY --chown=node:node entrypoint.sh entrypoint.sh

RUN npm install \
    && npm link \
    && npm cache clean --force
#COPY --chown=node:node test.sh test.sh
RUN chmod +x test.sh
ENTRYPOINT [ "./entrypoint.sh" ]
#ENTRYPOINT [ "bash" ]
#ENTRYPOINT ["./test.sh"]
