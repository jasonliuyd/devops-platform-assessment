FROM alpine:3.20

RUN apk update && apk upgrade

CMD ["sh", "-c", "echo Container security assessment demo"]
