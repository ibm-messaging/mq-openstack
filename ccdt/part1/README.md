MQ on OpenStack Client Connection PoC
=========================
This directory contains samples for Part 1 of the Automated Client Connection PoC using MQ v9 CCDT URL blog entry:
[MQ on OpenStack, part three: Automated client connection PoC using MQ v9 CCDT URL feature.](https://www.ibm.com/developerworks/community/blogs/messaging/entry/mq_openstack_part3_ccdt?lang=en)

This folder includes the following:

* `CCDT_Setup.mqsc` - A MQSC file that is used to configure the CCDT Server
* `CCDT_Setup.yaml` - A Heat template to set up an OpenStack server with a MQ Queue Manager and HTTP Server.
* `createCCDT.sh` - A shell script that is executed by the CCDT_Setup.yaml heat template to configure the server.
