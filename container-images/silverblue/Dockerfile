ARG FEDORA_MAJOR_VERSION=40

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}


RUN mkdir build
WORKDIR /build

COPY packages.txt .

####### Setup repos
RUN wget https://download.docker.com/linux/fedora/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

####### Install packages
RUN rpm-ostree install $(cat packages.txt)
RUN rpm-ostree override remove firefox firefox-langpacks

####### Setup services
COPY services/* /usr/lib/systemd/system/
RUN systemctl enable enzo-add-users.service

####### Setup docker
RUN grep -E '^docker:' /usr/lib/group | sudo tee -a /etc/group 

####### Work-around for https://github.com/coreos/rpm-ostree/issues/4201
####### relevant issue: https://github.com/coreos/rpm-ostree/issues/1614
RUN ln -s /usr/bin/ld.bfd /usr/bin/ld

WORKDIR /
RUN rpm-ostree cleanup -m && rm -r build && ostree container commit
