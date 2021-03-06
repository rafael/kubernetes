#!/bin/bash

# Copyright 2014 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script will build a dev release and push it to an existing cluster.

# First build a release
$(dirname $0)/../release/release.sh
if [ "$?" != "0" ]; then
       echo "Building a release failed!"
       exit 1
fi

# Now push this out to the cluster
$(dirname $0)/../cluster/kube-push.sh
