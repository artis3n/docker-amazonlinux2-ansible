FROM amazonlinux:2
LABEL maintainer="Artis3n"
ENV container=docker

ENV pip_packages "ansible"

# Intentionally break layer caching to take in updates
RUN yum -y update; yum clean all

# Install requirements.
RUN yum makecache fast \
 && yum -y install deltarpm epel-release initscripts \
 && yum -y update \
 && yum -y install \
      sudo \
      which \
      python-pip \
      python3 \
      python3-pip \
      python3-wheel \
 && yum clean all \
 && rm -rf /var/cache

# Install Ansible via Pip.
RUN pip3 install $pip_packages

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/lib/systemd/systemd"]
