FROM iamtakingiteasy/setorchapids-base:latest
## mutable 
# torch distribution
ADD https://build.torchapi.net/job/Torch/job/Torch/job/master/133/artifact/bin/torch-server.zip /home/user/torch-server.zip
USER root
# torch distribution tuning & cleanup
RUN \
  mkdir /home/user/{torch,data} && \
  unzip /home/user/torch-server.zip -d /home/user/torch && \
  chown user:user -R /home/user/{torch,data} && \
  rm -rf /home/user/.cache /home/user/torch-server.zip /var/cache/pacman/pkg/* /tmp/* /var/tmp/*
## runtime
USER user
WORKDIR /home/user
VOLUME /home/user/data
ENV VNC_OPTIONS="-nevershared -forever" XVFB_OPTIONS="-s '-screen 0 1280x720x24'"
COPY ./entrypoint.sh .
EXPOSE 5900 8080 27016/udp
ENTRYPOINT ["/home/user/entrypoint.sh"]
