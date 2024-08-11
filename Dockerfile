FROM greyltc/archlinux-aur:yay

ARG USER=ci
ARG UID=1000
ARG GID=1000


RUN  groupadd -g $GID $USER \
  && useradd -m -u $UID -g $GID -G wheel $USER \
  && echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && mkdir /build && chown -R $UID:$GID /build

WORKDIR /build

USER $USER

RUN mkdir -p /build/{safu,samconf,elos}
RUN yay --noconfirm -Syu && yay --noconfirm -S \
	log4c \
	namcap


COPY safu/PKGBUILD safu/.SRCINFO safu/
RUN pushd safu \
    && namcap PKGBUILD \
	&& makepkg -sri --noconfirm \
    && find ./ -name "*.pkg.tar*" -exec namcap {} \; \
	&& popd

COPY samconf/PKGBUILD samconf/.SRCINFO samconf/
RUN pushd samconf \
    && namcap PKGBUILD \
	&& makepkg -sri --noconfirm \
    && find ./ -name "*.pkg.tar*" -exec namcap {} \; \
	&& popd

COPY elos/PKGBUILD elos/.SRCINFO elos/elos.install elos/
RUN pushd elos \
    && namcap PKGBUILD \
	&& makepkg -sri --noconfirm \
    && find ./ -name "*.pkg.tar*" -exec namcap {} \; \
	&& popd
