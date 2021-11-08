#/bin/bash

set -e
chmod 600 /home/jenkins/smb.cred
export SHARE_BASE="$1"

sudo mkdir /mnt/backups

sudo mount -t cifs ${SHARE_BASE} /mnt/backups -o credentials=/home/jenkins/smb.cred