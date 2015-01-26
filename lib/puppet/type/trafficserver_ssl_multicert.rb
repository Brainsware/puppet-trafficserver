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

Puppet::Type.newtype(:trafficserver_ssl_multicert) do

  ensurable

  newparam(:ssl_cert_name, :namevar => true) do
    desc "Name (path) of the file containing the TLS certificate"
  end

  # this is taken from postgresql_config
  newproperty(:target) do
    desc "The path to ssl_multicert.config"
    defaultto do
      if @resource.class.defaultprovider.ancestors.include?(Puppet::Provider::ParsedFile)
        @resource.class.defaultprovider.default_target
      else
        nil
      end
    end
  end

  newproperty(:dest_ip) do
    desc "The IPv4 or IPv6 address that the certificate should be presented on"
  end

  newproperty(:ssl_key_name) do
    desc "The name of the file containing the private key for this certificate"
  end

  newproperty(:ssl_key_dialog) do
    desc "Method used to provide a pass-phrase for encrypted private keys"
    newvalues(/builtin|exec:/)
  end

  newproperty(:ssl_ca_name) do
    desc "If the certificates have different Certificate Authorities, they can be specified with this option"
  end

  newproperty(:action) do
    desc "If the tunnel matches this line, traffic server will not participate in the handshake. But rather it will blind tunnel the SSL connection."
    newvalues(/tunnel/) # so far, tunnel is the only valid value...
  end

  newproperty(:comment) do
    desc "optional comment"
  end
end
