#!/bin/sh
# Copyright (c) 2009-2015 The Open Source Geospatial Foundation.
# Licensed under the GNU LGPL.
# 
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License,
# or any later version.  This library is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY, without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details, either
# in the "LICENSE.LGPL.txt" file distributed with this software or at
# web page "http://www.fsf.org/licenses/lgpl.html".

# About:
# =====
# This script bootstraps the OSGeoLive build procedure.
# For detailed build instructions, refer to:
#   http://wiki.osgeo.org/wiki/GISVM_Build#Build_the_Live_DVD_ISO_image


# Running:
# =======
# sudo ./boostrap.sh [git_branch (default=master)] [GitHub_username (default=OSGeo)]

SCRIPT_DIR=/usr/local/share

if [ -z "$USER_NAME" ] ; then 
    USER_NAME="user" 
fi 
USER_HOME="/home/$USER_NAME"

# Parse arguments to be able to build specific branch from specific git repository.
# Defaults to master branch and official OSGeo git repository.
if [ "$#" -eq 2 ]; then
    GITHUB_USER="$2"
    GIT_BRANCH="$1"
elif [ "$#" -eq 1 ]; then
    GITHUB_USER="OSGeo"
    GIT_BRANCH="$1"
else
    GITHUB_USER="OSGeo"
    GIT_BRANCH="master"
fi

GIT_REPO="https://github.com/$GITHUB_USER/OSGeoLive.git"

# Install git
apt-get --assume-yes install git

# Clone git repository
cd "$SCRIPT_DIR"
git clone "$GIT_REPO" gisvm
# Switch to prefered branch
cd gisvm
git fetch origin -a
git checkout "$GIT_BRANCH"

cd "$SCRIPT_DIR"
chown -R "$USER_NAME":"$USER_NAME" gisvm
cd "$USER_HOME"
ln -s "$SCRIPT_DIR/gisvm" .
ln -s "$SCRIPT_DIR/gisvm" /etc/skel/gisvm

# make a directory for the install logs
mkdir -p /var/log/osgeolive/

# note: a+w is to be avoided always!
chmod ug+wr /var/log/osgeolive/
chgrp adm /var/log/osgeolive/


# If you have a local copy if the tmp/ directory and wish to
# save bandwidth, then copy it across to your DVD now, using a
# command like:
# "  rsync -avz username@hostname.org:/path_to_tmp_dir/ /tmp/"
# "  rsync -avz username@hostname.org:/path_to_tmp_apt_dir/ /var/cache/apt/"
