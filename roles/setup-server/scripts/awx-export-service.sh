#!/bin/bash -x
# gomatrixhosting-matrix-docker-ansible-deploy/docs/maintenance-postgres.md

# Run just postgresql dump
#/bin/sh /usr/local/bin/awx-export-service.sh 1 0

# Run both postgresql dump and tar.gz of /matrix/
#/bin/sh /usr/local/bin/awx-export-service.sh 1 1

cd / || exit 1
STIME="$(date +%s)"

DUMPIT=$1; TARIT=$2;

if [ "$DUMPIT" = 1 ]; then
  rm -f /chroot/export/postgres*
  DATE=$(date '+%F')
  docker run \
  --rm \
  --log-driver=none \
  --network=matrix \
  --env-file=/matrix/postgres/env-postgres-psql \
  postgres:latest \
  pg_dumpall -h matrix-postgres \
  | pigz --stdout --fast --blocksize 16384 --independent --processes 2 --rsyncable \
  > /chroot/export/postgres_$DATE.sql.gz
fi

DOCKERRC="$?";
DOCKER_ETIME="$(date +%s)"
DOCKER_ELAPSED="$(($DOCKER_ETIME - $STIME))"

if [ "$TARIT" = 1 ]; then
  rm -f /chroot/export/matrix*
  DATE=$(date '+%F')
  tar --exclude='./synapse/storage/media-store/remote_content' -czf /chroot/export/matrix_$DATE.tar.gz /matrix/awx /matrix/synapse /chroot/website
fi

TARRC="$?";
TAR_ETIME="$(date +%s)"
TAR_ELAPSED="$(($TAR_ETIME - $STIME))"

FILE_SIZE=$(stat -c '%s' /chroot/export/postgres_$DATE.sql.gz)
DATE_TIME=$(date '+%F_%H:%M:%S')

chown -R sftp:sftp /chroot/export/

if [ "$TARIT" = 1 ] && [ "$DUMPIT" = 1 ]; then
  echo "$DATE_TIME $0: Snapshot (returned $DOCKERRC at $DOCKER_ELAPSED seconds) database.gz size: $FILE_SIZE + TAR (returned $TARRC at $TAR_ELAPSED seconds) completed."  >> /matrix/awx/export.log
elif [ "$TARIT" != 1 ] && [ "$DUMPIT" = 1 ]; then
  echo "$DATE_TIME $0: Snapshot (returned $DOCKERRC at $DOCKER_ELAPSED seconds) database.gz size: $FILE_SIZE"  >> /matrix/awx/export.log
elif [ "$TARIT" = 1 ] && [ "$DUMPIT" != 1 ]; then
  echo "$DATE_TIME $0: TAR (returned $TARRC at $TAR_ELAPSED seconds) completed."  >> /matrix/awx/export.log
fi

