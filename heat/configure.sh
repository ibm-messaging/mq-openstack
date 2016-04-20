#!/bin/bash
# -*- mode: sh -*-
# (C) Copyright IBM Corporation 2016
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -x

fail() {
  REASON=${1=error}
  wc_notify --data-binary "{\"status\": \"FAILURE\", \"reason\": \"${REASON}\"}"
  exit 1
}

# The volume ID will be substituted in by Heat
VOLUME_ID="%VOLUME_ID%"
# The volume device assumes VirtIO, which uses the first 20 characters of the ID
VOLUME_DEV="/dev/disk/by-id/virtio-$(echo ${VOLUME_ID} | cut -c -20)"
# Mount point for the volume
MOUNT_POINT=/var/mqm

mkdir -p ${MOUNT_POINT}
mount ${VOLUME_DEV} ${MOUNT_POINT}
# If the mount doesn't work, assume it's a new volume
if [[ $? != 0 ]]; then
  # Create an ext4 filesystem on the volume
  mkfs.ext4 ${VOLUME_DEV} || fail "Error creating filesystem"
  # Add the volumes to /etc/fstab, so it gets mounted at boot time
  echo "${VOLUME_DEV} ${MOUNT_POINT} ext4 defaults 0 2" >> /etc/fstab || fail "Error updating fstab"
  # Mount the volume
  mount ${MOUNT_POINT} || fail "Error mounting newly formatted volume"
  # Create the MQ file structure under /var/mqm (volume is currently empty)
  /opt/mqm/bin/amqicdir -i -f || fail "Error creating MQ file structure"
  # Generate a random queue manager name
  export MQ_QMGR_NAME=$(UUID=$(uuidgen); echo ${UUID//-/})
  # Create the queue manager as the "mqm" user
  sudo su mqm -c "crtmqm -q ${MQ_QMGR_NAME}" || fail "Error creating queue manager"
else
  # The volume's already formatted and mounted...

  # Identify the queue manager name (assumes only one queue manager)
  export MQ_QMGR_NAME=$(dspmq -n | awk -F '[()]' '{ print $2 }' | head -n 1)
  # Update the MQ file structure under /var/mqm, in case we've updated
  # the version of MQ
  /opt/mqm/bin/amqicdir -i -f || fail "Error updating MQ file structure"
fi

# This is a new VM, so set up an Upstart service for running MQ at boot time
export MQ_QMGR_CONF=/etc/init/strmqm-${MQ_QMGR_NAME}.conf
# A template for the Upstart file was added by cloud-init
cp /tmp/mq-upstart-strmqm.conf ${MQ_QMGR_CONF} || fail "Missing strmqm template"
# Update the template so it knows the right queue manager name
sed -i "s/%QM%/${MQ_QMGR_NAME}/" ${MQ_QMGR_CONF} || fail "Error updating strmqm template"

# This is a new VM, so set up an Upstart service for shutting down MQ properly
export MQ_QMGR_CONF=/etc/init/endmqm-${MQ_QMGR_NAME}.conf
# A template for the Upstart file was added by cloud-init
cp /tmp/mq-upstart-endmqm.conf ${MQ_QMGR_CONF} || fail "Missing endmqm template"
# Update the template so it knows the right queue manager name
sed -i "s/%QM%/${MQ_QMGR_NAME}/" ${MQ_QMGR_CONF} || fail "Error updating endmqm template"

# Reload the Upstart configuration
initctl reload-configuration || fail
# Start the queue manager using Upstart
initctl start strmqm-${MQ_QMGR_NAME} || fail "Error starting queue manager"

# Notify the Heat engine that the script has finished
wc_notify --data-binary '{"status": "SUCCESS"}'
