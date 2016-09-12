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
#
# This file Creates and starts a Queue Manager of a given name and then executes
# a runmqsc command passing in a pre-made file. Once that completes it then
# runs runmqsc -c to register the local Queue Manager details with the CCDT host.

set -x

# Variables
CFGFILE=%CFG_FILE%

# Create and start Queue Manager
sudo -u mqm crtmqm QM1
sudo -u mqm strmqm QM1

#Configure Queue Manager
sudo -u mqm runmqsc QM1 < ${CFGFILE}

# register with CCDT Server
sudo -u mqm sh -c "export MQSERVER=CH.SVRCONN/TCP/%CCDT_HOST%\(%CCDT_PORT%\) && runmqsc -c CCDT < /tmp/AddCCDT.mqsc" || echo failed to register with CCDT Server
