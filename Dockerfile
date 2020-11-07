FROM ubuntu:20.04

ARG OPA_VERSION=v0.24.0
ARG COLLIE_VERSION=v0.1-rc1
ARG JQ_VERSION=jq-1.6

RUN apt-get update \ 
  && apt-get install curl -y

# Setup OPA executable
RUN mkdir /tmp/opa \
  && curl -fsSL -o /tmp/opa/opa https://github.com/open-policy-agent/opa/releases/download/${OPA_VERSION}/opa_linux_amd64 \
  && cp /tmp/opa/opa /usr/local/bin \
  && chmod +x /usr/local/bin/opa \
  && rm -rf /tmp/opa

# Setup Collie executable
RUN mkdir /tmp/collie \
  && curl -fsSL -o /tmp/collie/collie.tar.gz https://github.com/khaale/collie/releases/download/${COLLIE_VERSION}/collie_${COLLIE_VERSION}_linux_amd64.tar.gz \
  && tar -xvf /tmp/collie/collie.tar.gz -C /tmp/collie \
  && cp /tmp/collie/collie /usr/local/bin \
  && chmod +x /usr/local/bin/collie \
  && rm -rf /tmp/collie

# Setup Jq executable
RUN mkdir /tmp/jq \
  && curl -fsSL -o /tmp/jq/jq https://github.com/stedolan/jq/releases/download/${JQ_VERSION}/jq-linux64 \
  && cp /tmp/jq/jq /usr/local/bin \
  && chmod +x /usr/local/bin/jq \
  && rm -rf /tmp/jq

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]