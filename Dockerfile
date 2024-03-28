FROM greyltc/archlinux-aur:yay

ARG USER=ci
ARG UID=1000
ARG GID=1000


RUN  groupadd -g $GID $USER \
  && useradd -m -u $UID -g $GID -G wheel $USER \
  && echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /build/{safu,samconf,elos} && chown -R $UID:$GID /build
WORKDIR /build

USER $USER

COPY safu/PKGBUILD safu/.SRCINFO safu/
COPY samconf/PKGBUILD samconf/.SRCINFO samconf/
COPY elos/PKGBUILD elos/.SRCINFO elos/elos.install elos/

RUN yay --noconfirm -Syu && yay --noconfirm -S \
	log4c \
	namcap

RUN pushd safu \
    && namcap PKGBUILD \
	&& makepkg -sri --noconfirm \
    && find ./ -name "*.pkg.tar*" -exec namcap {} \; \
	&& popd

RUN pushd samconf \
    && namcap PKGBUILD \
	&& makepkg -sri --noconfirm \
    && find ./ -name "*.pkg.tar*" -exec namcap {} \; \
	&& popd

RUN pushd elos \
    && namcap PKGBUILD \
	&& makepkg -sri --noconfirm \
    && find ./ -name "*.pkg.tar*" -exec namcap {} \; \
	&& popd
