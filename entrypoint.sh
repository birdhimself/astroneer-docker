#!/bin/bash

cd /astrotux

if [[ "$FORCE_CHOWN" =~ ^([Tt][Rr][Uu][Ee]|1|[Yy][Ee][Ss])$ ]]; then
  echo Force chowning /astrotux folder.
  chown -R $(id -u):$(id -g) /astrotux
  echo Done chowning.
fi

source ./venv/bin/activate

python3 AstroTuxLauncher.py install

if [[ "$DISABLE_ENCRYPTION" =~ ^([Tt][Rr][Uu][Ee]|1|[Yy][Ee][Ss])$ ]]; then
  echo Encryption will be disabled because DISABLE_ENCRYPTION is set.
  echo Check https://github.com/birdhimself/astroneer-docker?tab=readme-ov-file#configuring-clients for instructions on how to enable clients to connect to servers with encryption disabled.
  sed -i 's/^DisableEncryption.*/DisableEncryption = true/' launcher.toml
else
  echo Encryption will be enabled. You can safely ignore warnings related to encryption not working using Wine, this is no longer the case.
  sed -i 's/^DisableEncryption.*/DisableEncryption = false/' launcher.toml
fi

if [[ "$DEBUG" =~ ^([Tt][Rr][Uu][Ee]|1|[Yy][Ee][Ss])$ ]]; then
  sed -i 's/^LogDebugMessages.*/LogDebugMessages = true/' launcher.toml
else
  sed -i 's/^LogDebugMessages.*/LogDebugMessages = false/' launcher.toml
fi

python3 AstroTuxLauncher.py start
