FROM gliderlabs/alpine:3.9

RUN \
  apk-install \
    curl \
    openssh-client \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar && \
    apk --update add --virtual .build-dependencies python-dev libffi-dev openssl-dev build-base && \
  pip install --upgrade pip python-keyczar && \
  pip install 'docker-py>=1.7.0' && \
  pip install 'docker-compose>=1.7.0' && \
  pip install --no-cache --upgrade ansible && \
  pip install zabbix-api && \
  apk del --purge .build-dependencies && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

#RUN \
#  curl -fsSL https://releases.ansible.com/ansible/ansible-2.4.1.0.tar.gz -o ansible.tar.gz && \
#  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
#  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

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