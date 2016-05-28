FROM base/archlinux

RUN pacman -Sy archlinux-keyring --noconfirm

RUN pacman -Sy base-devel --noconfirm

RUN pacman-db-upgrade

RUN pacman -Sy arch-install-scripts git --noconfirm

RUN pacman -Sy go --noconfirm

RUN pacman -Syu --noconfirm

RUN mkdir -p /tmp/kube

# Using user nobody for build user
RUN chsh -s /bin/bash nobody

# makepkg insists on non-root user but also needs sudo for easy dependency installs.
ADD nobody.conf /etc/sudoers.d/nobody
ADD PKGBUILD /tmp/kube/PKGBUILD
ADD kubernetes.install /tmp/kube/kubernetes.install

RUN chown -R nobody /tmp/kube

# To run the kubernetes GCO build this has to be writeable by the build user.
RUN chown -R nobody /usr/lib/go/pkg/

WORKDIR /tmp/kube

USER nobody

RUN makepkg -s --noconfirm
