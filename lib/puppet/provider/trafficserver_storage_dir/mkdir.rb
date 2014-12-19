#   Copyright 2014 Brainsware
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# abstract base class for trafficserver_storage

Puppet::Type.type(:trafficserver_storage_dir).provide(:mkdir) do

  commands :install => 'install'

  def create
    install('-d', '-o', @resource[:owner], '-g', @resource[:group], @resource[:path])
  end

  def exists?
    return false unless File.directory?(@resource[:path])
    gid = Etc.getgrnam(@resource[:group])[:gid]
    uid = Etc.getpwnam(@resource[:owner])[:uid]
    fs  = File.stat(@resource[:path])
    return false unless (fs.gid == gid && fs.uid == uid)
    true
  end

end
