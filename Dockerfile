FROM archlinux:latest
## base
# base image tuning
RUN \
  sed '/#\[multilib\]/{N;s/#//g}' -i /etc/pacman.conf && \
  pacman -Sy --noconfirm tar lib32-glibc wine winetricks grep awk nano sudo unzip xorg-server-xvfb x11vnc openbox && \
  useradd -m -G wheel user && \
  echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
# base wine tuning
USER user
RUN \
  WINEARCH=win64 wineboot -u && \
  WINEARCH=win64 xvfb-run -a -- winetricks -q corefonts dotnet20 dotnet40 dotnet461 xna40 d3dx9 directplay
## mutable 
# torch distribution
ADD https://build.torchapi.net/job/Torch/job/Torch/job/master/95/artifact/bin/torch-server.zip /home/seuser/torch-server.zip
USER root
# torch distribution tuning & cleanup
RUN \
  mkdir /home/user/{torch,data} && \
  unzip /home/seuser/torch-server.zip -d /home/user/torch && \
  chown user:user -R /home/user/{torch,data} && \
  rm -rf /home/user/.cache /home/seuser/torch-server.zip /var/cache/pacman/pkg/* /tmp/* /var/tmp/*
## runtime
USER user
WORKDIR /home/user
VOLUME /home/user/data
ENV VNC_OPTIONS="-nevershared -forever" XVFB_OPTIONS="-s '-screen 0 1280x720x24'"
COPY ./entrypoint.sh .
EXPOSE 5900 8080 27016/udp
ENTRYPOINT ["/home/user/entrypoint.sh"]
