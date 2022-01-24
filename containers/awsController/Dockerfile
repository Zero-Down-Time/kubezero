ARG SHELL_OPERATOR_VERSION

FROM flant/shell-operator:v${SHELL_OPERATOR_VERSION}

RUN apk upgrade -U -a && \
    apk --no-cache add \
      aws-cli

ADD hooks /hooks
