FROM rockylinux:9
LABEL maintainer="Bart Smeding"
ENV container=docker

ENV pip_packages "ansible==11.1.0 yamllint pynautobot pynetbox jmespath netaddr"

# Install requirements.
RUN yum -y install rpm dnf-plugins-core \
 && yum -y update \
 && yum -y install \
      epel-release \
      initscripts \
      sudo \
      which \
      hostname \
      libyaml \
      python3 \
      python3-pip \
      python3-pyyaml \
      git \
      iproute \
      sshpass \
 && yum clean all

# Create virtual environment
RUN python3 -m venv /opt/venv

# Install Python packages inside venv
RUN /opt/venv/bin/pip install --upgrade pip wheel \
 && /opt/venv/bin/pip install cryptography cffi mitogen jmespath pywinrm \
 && /opt/venv/bin/pip install $pip_packages

# Set PATH to use virtualenv by default
ENV PATH="/opt/venv/bin:$PATH"


# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Set Ansible localhost inventory file
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
