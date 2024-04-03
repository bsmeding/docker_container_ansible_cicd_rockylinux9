FROM rockylinux:9
LABEL maintainer="Bart Smeding"
ENV container=docker

ENV pip_packages "ansible yamllint"

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
 && yum clean all

# Upgrade pip to latest version
RUN pip3 install --upgrade pip

# Install Ansible and other packages via Python pip
RUN pip3 install $pip_packages

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Set Ansible localhost inventory file
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
