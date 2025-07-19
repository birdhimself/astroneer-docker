# Astroneer Dedicated Server (in a container)

[![Docker Pulls](https://img.shields.io/docker/pulls/whalybird/astroneer-server.svg)](https://hub.docker.com/r/whalybird/astroneer-server)
[![Docker stars](https://img.shields.io/docker/stars/whalybird/astroneer-server.svg)](https://hub.docker.com/r/whalybird/astroneer-server)

A docker image to run Astroneer Dedicated Server using a modified version of [AstroTuxLauncher](https://github.com/birdhimself/AstroTuxLauncher). The source code is [available on GitHub](https://github.com/birdhimself/astroneer-docker/).

**Supports encryption as well as Intel/AMD and ARM CPUs.**

## Compose

```yaml
services:
  astroneer:
    image: ghcr.io/birdhimself/astroneer-server:latest
    restart: unless-stopped
    stdin_open: true
    tty: true
    ports:
      - 7777:7777/udp
    volumes:
      - ./saved:/astrotux/AstroneerServer/Astro/Saved
```

## Variants

### Registries

The image is available from both **ghcr.io** and **docker.io**:

| Registry  | Full image name                        |
|-----------|----------------------------------------|
| docker.io | `ghcr.io/birdhimself/astroneer-server` |
| ghcr.io   | `docker.io/whalybird/astroneer-server` |

### Available tags

| Tag            | Description                                                                      |
|----------------|----------------------------------------------------------------------------------|
| `latest`       | Latest version for general use. Recommended in most cases.                       |
| `experimental` | Version with experimental features and changes. Will eventually become `latest`. |

### Architectures

This image support both `amd64` (Intel/AMD CPUs) and `arm64` (e.g. Raspberry Pi, Apple) architectures. The correct image variant should be pulled automatically.

## Encryption support

As of Wine 10.6 and GnuTLS 3.8.3, server encryption is supported. If you don't want to use encryption, you can disable it by setting `DISABLE_ENCRYPTION=true` in your `compose.yml`.

## Interacting with the AstroTuxLauncher console

You can interact with the console by using `docker compose attach astroneer`. Detach using `CTRL+p` + `CTRL+q`, using `CTRL+c` will shutdown the server.

## Configuring clients (if encryption is disabled)

Should you choose to disable encryption, clients will need to be configured accordingly.

To disable encryption, you need to edit the file `Engine.ini` located in `%localappdata%\Astro\Saved\Config\WindowsNoEditor`. Make sure the game isn't running and add the following lines to the file:

```ini
[SystemSettings]
net.AllowEncryption=False
```

## Making yourself admin

shutdown the server (`docker compose stop`) and edit the file `AstroServerSetting.ini` located in `./saves/Config/WindowsServer`. Change the value of `OwnerName` to your Steam name and make sure `OwnerGuid` is set to `0`. It should look like this:

```ini
OwnerName=My Steam Username
OwnerGuid=0
```

Start the server and make sure you join it before anyone else, as the game will automatically assign the admin/owner role to the first player joining.

## If you can't progress past the first mission

If you can't progress past the first mission, you have to start a new game via the "Server admin" tab after connecting to the server. Click on "Manage game session" followed by "Start a new game" (and confirm by clicking "Start a new game" in the popout):

![Server admin > Manage game session](./readme_assets/new_game_1.png)\
_Server admin > Manage game session_

![Start a new game > Start a new game](./readme_assets/new_game_2.png)\
_Start a new game > Start a new game_
