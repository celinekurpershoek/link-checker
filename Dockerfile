FROM alpine:3.12

LABEL com.github.actions.name="Broken Link Checker" \
      com.github.actions.description="Find broken links in your website" \
      com.github.actions.icon="code" \
      com.github.actions.color="red" \
      maintainer="ocular-d <sven@ocular-d.tech>"

RUN apk add --no-cache bash nodejs npm jq

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/bash -D node -h /app

USER node
WORKDIR /app
RUN mkdir ~/.npm-global
RUN npm config set prefix '~/.npm-global'
RUN echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
RUN source ~/.bashrc


COPY --chown=node:node package.json package.json
RUN npm install && npm link
COPY --chown=node:node test.sh test.sh
RUN chmod +x test.sh
ENTRYPOINT [ "bash" ]
#ENTRYPOINT ["./test.sh"]
