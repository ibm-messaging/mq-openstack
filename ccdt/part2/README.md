MQ on OpenStack Client Connection PoC
=========================
This directory contains samples for Part 2 of the Automated Client Connection PoC using MQ v9 CCDT URL blog entry:
[MQ on OpenStack, part three: Automated client connection PoC using MQ v9 CCDT URL feature.](https://www.ibm.com/developerworks/community/blogs/messaging/entry/mq_openstack_part3_ccdt?lang=en)

This folder includes the following:

* `AddCCDT.mqsc` - A MQSC file that is used to register the Queue Manager with the CCDT server.
* `Create_QM.yaml` - A heat template that is used to set up an OpenStack server with a MQ Queue Manager.
* `createQM.sh` - A shell script that is executed by the Create_QM.yaml heat template to configure the server.
* `QM_Setup.mqsc` - A MQSC file that is used to configure the Queue Manager.
