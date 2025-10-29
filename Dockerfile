#FROM gliderlabs/alpine:3.9
FROM python:3.9.22-alpine

#RUN apk --update -no-cache add \
RUN apk --update add \
    ca-certificates \
    git \
    openssh-client \
    python3 \
    py3-pip \
    sshpass \
    gcc \
    openssl \
    sudo \
    && rm -rf /var/cache/apk/*

RUN apk --upgrade add --virtual \
    .build-deps \
    libffi-dev \
    openssl-dev \
    build-base \
    curl \
    && pip3 install --upgrade --break-system-packages pip cffi ansible ansible-lint zabbix-api requests \
    && apk del --purge .build-deps \
    && rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING=smart
ENV ANSIBLE_HOST_KEY_CHECKING=false
ENV ANSIBLE_RETRY_FILES_ENABLED=false
ENV ANSIBLE_ROLES_PATH=/ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING=True
ENV PATH=/ansible/bin:$PATH
ENV PYTHONPATH=/ansible/lib

RUN ansible-galaxy collection install community.zabbix

COPY execute.sh /ansible/execute.sh
RUN chmod +x /ansible/execute.sh

ENTRYPOINT ["/ansible/execute.sh"]