MQ on OpenStack with Heat
=========================
This directory contains samples for using MQ with OpenStack Orchestration (Heat), as discussed in the following blog entry:
[MQ on OpenStack, part two: Managing an MQ environment using Heat](https://www.ibm.com/developerworks/community/blogs/messaging/entry/mq_openstack_part2_heat?lang=en)

The sample files include the following:

* `mq-simple.yaml` - A simple Heat template to set up a server.  Not really MQ specific.
* `mq-persistence.yaml` - A Heat template, based on `mq-simple.yaml`, which adds persistent storage, which enables a running MQ queue manager.  Depends on having an OpenStack image with IBM MQ pre-installed.
  - `configure.sh` - Bash script used at server boot time to mount and format a block storage volume, then setup MQ.
  - `mq-upstart-strmqm.conf` - Simple Upstart configuration file used to start MQ
  - `mq-upstart-endmqm.conf` - Simple Upstart configuration file used to stop MQ
