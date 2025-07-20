#!/bin/bash

cd /astrotux

if [[ "$FORCE_CHOWN" =~ ^([Tt][Rr][Uu][Ee]|1|[Yy][Ee][Ss])$ ]]; then
  echo Force chowning /astrotux folder.
  chown -R $(id -u):$(id -g) /astrotux
  echo Done chowning.
fi

source ./venv/bin/activate

python3 AstroTuxLauncher.py install

# Use a temporary file to edit launcher.toml because if a bind exists sed -i
# will fail. See https://unix.stackexchange.com/a/404356.
TEMPFILE=$(mktemp)
cp launcher.toml $TEMPFILE

shopt -s nocasematch

if [ -f /usr/local/bin/box64 ]; then
  sed -i 's/WrapperPath.*/WrapperPath = "\/usr\/local\/bin\/box64"' $TEMPFILE
fi

if [[ "$DISABLE_ENCRYPTION" =~ ^(true|1|yes])$ ]]; then
  echo Encryption will be disabled because DISABLE_ENCRYPTION is set.
  echo Check https://github.com/birdhimself/astroneer-docker?tab=readme-ov-file#configuring-clients-if-encryption-is-disabled on how to enable clients to connect to servers with encryption disabled.
  sed -i 's/^DisableEncryption.*/DisableEncryption = true/' $TEMPFILE
else
  echo Encryption will be enabled. You can safely ignore warnings related to encryption not working using Wine, this is no longer the case.
  sed -i 's/^DisableEncryption.*/DisableEncryption = false/' $TEMPFILE
fi

if [[ "$DEBUG" =~ ^(true|1|yes)$ ]]; then
  sed -i 's/^LogDebugMessages.*/LogDebugMessages = true/' $TEMPFILE
else
  sed -i 's/^LogDebugMessages.*/LogDebugMessages = false/' $TEMPFILE
fi

shopt -u nocasematch

cp $TEMPFILE launcher.toml

python3 AstroTuxLauncher.py start
