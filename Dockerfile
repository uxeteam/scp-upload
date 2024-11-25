FROM alpine:3.12

LABEL maintainer="UXE Team <cloud@uxe.app>"

RUN apk add --no-cache bash openssh-client

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]