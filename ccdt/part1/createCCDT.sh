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
# This file creates and configures the CCDT hosting Queue Manager that is used
# to manage the CCDT file. Although in this example we use a Queue Manager to
# create and manage the CCDT file, there are other ways to do this.
# Once the Queue Manager has been created and configured we setup a HTTP Server
# using python's SimpleHTTPServer to host the CCDT file.

set -x

# First create and start the Queue Manager called CCDT
sudo -u mqm crtmqm CCDT
sudo -u mqm strmqm CCDT

# Next configure the Queue Manager with the mqsc file
sudo -u mqm runmqsc CCDT < /tmp/CCDT_Setup.mqsc

# Now create a directory for the HTTP Server and create a symbolic link to the
# CCDT file in it (so connecting applications can obtain it)
sudo -u mqm mkdir /var/mqm/serv
sudo -u mqm sh -c "ln -s /var/mqm/qmgrs/CCDT/@ipcc/AMQCLCHL.TAB /var/mqm/serv/AMQCLCHL.TAB"

# Start the Python HTTP Server to listen on port 80 in the directory created above
sudo sh -c "cd /var/mqm/serv && nohup python -m SimpleHTTPServer 80 &"
