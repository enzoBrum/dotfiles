# syntax=docker/dockerfile:1

ARG FEDORA_MAJOR_VERSION=40

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}


RUN mkdir build
WORKDIR /build

COPY packages.txt .

####### Setup repos
RUN wget https://download.docker.com/linux/fedora/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo \
   && rpm --import https://packages.microsoft.com/keys/microsoft.asc \
   && echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
   | tee /etc/yum.repos.d/vscode.repo > /dev/null 
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

####### Setup chezmoi
RUN --mount=type=secret,id=github_token,env=GITHUB_TOKEN curl -L \
         -H "Accept: application/vnd.github+json" \
         -H "X-GitHub-Api-Version: 2022-11-28" \
         -H "Authorization: Bearer $GITHUB_TOKEN" \
         https://api.github.com/repos/twpayne/chezmoi/releases/latest | jq -c '.assets' | jq  '.[] | select(.name | contains("rpm") and contains("x86_64")).browser_download_url' \
         | xargs curl -H "Authorization: Bearer $GITHUB_TOKEN" --verbose -L --output chezmoi.rpm

RUN rpm-ostree install git && rpm -i chezmoi.rpm

WORKDIR /
RUN rpm-ostree cleanup -m && rm -r build && ostree container commit
