FROM greyltc/archlinux-aur:paru

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen

RUN pacman-key --init
RUN pacman-key --populate

# Chaotic-AUR and multilib
RUN pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
RUN pacman-key --lsign-key 3056513887B78AEB
RUN pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf

# Create user
RUN useradd -m -G wheel -s /bin/bash user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER user

# get rust ready for any rust software builds
RUN rustup default stable

# Get the best mirrors
RUN paru -Syu --noconfirm rate-mirrors-bin gcc python-setuptools
RUN rate-mirrors --allow-root arch | sudo tee /etc/pacman.d/mirrorlist

# Continue with root user
USER root
