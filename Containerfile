# syntax=docker/dockerfile:1

ARG FEDORA_MAJOR_VERSION=42

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

RUN mkdir /build && mkdir /var/roothome
RUN dnf up -y
RUN dnf in -y git wget

RUN wget https://download.docker.com/linux/fedora/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
    && echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
    | tee /etc/yum.repos.d/vscode.repo
RUN git clone https://github.com/twpayne/chezmoi.git /build/chezmoi && cd /build/chezmoi
RUN cd /build/chezmoi && wget https://github.com/twpayne/chezmoi/releases/download/$(git ls-remote --tags --sort=-committerdate | grep -o "v.*" | head -n 1)/chezmoi-$(git ls-remote --tags --sort=-committerdate | grep -o "v.*" | head -n 1 | sed 's/v//' )-x86_64.rpm -O chezmoi.rpm \
   && dnf install -y chezmoi.rpm

COPY ./distrobox.patch /build/distrobox.patch
RUN git clone https://github.com/89luca89/distrobox.git /build/distrobox && cd /build/distrobox && git checkout 1.8.1.2 && git apply ../distrobox.patch && ./install --prefix /usr

RUN dnf install -y \
        bootc \
        git \
        alacritty \
        bat \
        containerd.io \
        docker-buildx-plugin \
        docker-ce \
        docker-ce-cli \
        docker-compose-plugin \
        fastfetch \
        fd-find \
        fish \
        fzf \
        grc \
        make\
        neovim \
        nodejs\
        wl-clipboard \
        gcc \
        g++ \
        binutils \
        direnv \
        tldr \
    && dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && dnf in akmods rpmdevtools -y


RUN dnf in -y akmod-nvidia xorg-x11-drv-nvidia kernel kernel-devel

COPY ./cmdline.conf /etc/dracut.conf.d/cmdline.conf

RUN QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-devel-(\d+\.\d+\.\d+)' | sed -E 's/kernel-devel-//')" \
    && akmods --kernels $QUALIFIED_KERNEL
RUN QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-devel-(\d+\.\d+\.\d+)' | sed -E 's/kernel-devel-//')" \
    && DRACUT_NO_XATTR=1 dracut --no-hostonly --reproducible  --kver $QUALIFIED_KERNEL --add ostree    -f usr/lib/modules/$QUALIFIED_KERNEL/initramfs.img --verbose

RUN systemctl enable docker

RUN URL=$(curl  https://github.com/zellij-org/zellij/releases/latest/ -sL -w %{url_effective} -o /dev/null | xargs | sed 's/tag/download/') \
    && mkdir /build/zellij && cd /build/zellij && wget $URL/zellij-x86_64-unknown-linux-musl.tar.gz -O zellij.tar.gz \
    && tar xvf zellij.tar.gz && mv zellij /usr/bin/zellij

RUN URL=$(curl  https://github.com/eza-community/eza/releases/latest/ -sL -w %{url_effective} -o /dev/null | xargs | sed 's/tag/download/') \
    && mkdir /build/eza && cd /build/eza && wget $URL/eza_x86_64-unknown-linux-gnu.tar.gz -O eza.tar.gz \
    && tar xvf eza.tar.gz && mv eza /usr/bin/eza \
    && git clone https://github.com/eza-community/eza eza-repo \
    && cd eza-repo \
    && git checkout $(git ls-remote --tags --sort=-committerdate | grep -o "v.*" | head -n 1) \
    && cp completions/fish/eza.fish /usr/share/fish/completions/eza.fish


RUN curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
  tee /etc/yum.repos.d/nvidia-container-toolkit.repo && dnf install -y nvidia-container-toolkit && nvidia-ctk runtime configure --runtime=docker

RUN dnf clean all && systemctl set-default graphical.target  && rm -rf /build
