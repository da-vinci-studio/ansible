#FROM gliderlabs/alpine:3.9
FROM alpine:3.12

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
    && rm -rf /var/cache/apk/*

RUN apk --upgrade add --virtual \
    .build-deps \
    python3-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    curl \
    && pip3 install --upgrade pip cffi ansible ansible-lint \
    && apk del --purge .build-deps \
    && rm -rf /var/cache/apk/*

#RUN \
#  apk --update add \
#    py-boto \
#    py-dateutil \
#    py-httplib2 \
#    py-jinja2 \
#    py-paramiko \
#    py-pip \
#    py-setuptools \
#    py-yaml \
#    tar && \
#    apk --update add --virtual .build-dependencies python-dev libffi-dev openssl-dev build-base && \
#  pip install --upgrade pip python-keyczar && \
#  pip install 'docker-py>=1.7.0' && \
#  pip install 'docker-compose>=1.7.0' && \
#  pip install zabbix-api && \
#  apk del --purge .build-dependencies && \
#  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

RUN ls

COPY execute.sh /ansible/execute.sh
RUN chmod +x /ansible/execute.sh

ENTRYPOINT ["/ansible/execute.sh"]