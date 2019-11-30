[![Docker Pulls](https://img.shields.io/docker/pulls/iamtakingiteasy/setorchapids)](https://hub.docker.com/r/iamtakingiteasy/setorchapids)

# Abstract

A wine64 / archlinux-based dockerization of [TorchAPI](https://github.com/TorchAPI/Torch) [Space Engineers](https://www.spaceengineersgame.com) dedicated server.

Base image with required system and .net packages is extracted to https://github.com/iamtakingiteasy/se-torchapi-ds-base-docker repository to reduce build times

It uses win64 wineprefix with all required .net 4.6.1 packages installed with winetricks.

Sadly, as usual with windows software, this one is heavily tied to GUI.

Even with nogui=true setting / -nogui flag torchserver still tries to create (possibly invisible) windows and fails if executed in true headless environment.

To counter that to some extent, xvfb and x11vnc is used. Openbox is added to allow window manipulation.

# Example usage

```
docker run -v /home/data/your/server/data:/home/user/data -p 0.0.0.0:27016:27016/udp -p 127.0.0.1:5900:5900 -p 127.0.0.1:8080:8080 iamtakingiteasy/setorchapids:latest
```

Entrypoint checks if /home/user/data directory is empty, and if it is -- copies torch distribution to it before starting the server.

Yoy may also check out example [docker-compose.yaml](https://github.com/iamtakingiteasy/se-torchapi-ds-docker/blob/master/docker-compose.yaml)

# Customization

| env variable | default                        | substitution                                                                                |
|--------------|--------------------------------|---------------------------------------------------------------------------------------------|
| VNC_OPTIONS  | `-nevershared -forever`        | `x11vnc $VNC_OPTIONS -auth /home/user/.Xauthority -display :99.0 &`                         |
| XVFB_OPTIONS | `-s \"-screen 0 1280x720x24\"` | `xvfb-run $XVFB_OPTIONS -n 99 -l -f /home/user/.Xauthority -- wine64 Torch.Server.exe $@ &` |

CMD of container is added to Torch.Server.exe invocation.

# Network

| port      | description            |
|-----------|------------------------|
| 5900/tcp  | VNC port               |
| 8080/tcp  | Torch web console port |
| 27016/udp | SE server port         |

# Persistency

| volume          | description                                                                                 |
|-----------------|---------------------------------------------------------------------------------------------|
| /home/user/data | TorchAPI server root directory, including torchserver itself, steamclient and all instances |
