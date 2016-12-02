#  Copyright 2016 Puppet Community
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

source ENV['GEM_SOURCE'] || "https://rubygems.org"


group :test do
  gem 'puppetlabs_spec_helper', '~> 1.2.2',                         :require => false
  gem 'rspec-puppet', '~> 2.5',                                     :require => false
  gem 'rspec-puppet-facts',                                         :require => false
  gem 'rspec-puppet-utils',                                         :require => false
  gem 'puppet-lint-absolute_classname-check',                       :require => false
  gem 'puppet-lint-leading_zero-check',                             :require => false
  gem 'puppet-lint-trailing_comma-check',                           :require => false
  gem 'puppet-lint-version_comparison-check',                       :require => false
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check',  :require => false
  gem 'puppet-lint-unquoted_string-check',                          :require => false
  gem 'puppet-lint-variable_contains_upcase',                       :require => false
  gem 'metadata-json-lint',                                         :require => false
  gem 'puppet-blacksmith',                                          :require => false
  gem 'voxpupuli-release',                                          :require => false, :git => 'https://github.com/voxpupuli/voxpupuli-release-gem.git'
  gem 'puppet-strings', '~> 0.99.0',                                :require => false
  gem 'rubocop-rspec', '~> 1.6',                                    :require => false if RUBY_VERSION >= '2.3.0'
  gem 'json_pure', '<= 2.0.1',                                      :require => false if RUBY_VERSION < '2.0.0'
  gem 'mocha', '>= 1.2.1',                                          :require => false
  gem 'coveralls',                                                  :require => false if RUBY_VERSION >= '2.0.0'
  gem 'simplecov-console',                                          :require => false if RUBY_VERSION >= '2.0.0'
end

group :development do
  gem 'travis',       :require => false
  gem 'travis-lint',  :require => false
  gem 'guard-rake',   :require => false
end

group :system_tests do
  if beaker_version = ENV['BEAKER_VERSION']
    gem 'beaker', *location_for(beaker_version)
  end
  if beaker_rspec_version = ENV['BEAKER_RSPEC_VERSION']
    gem 'beaker-rspec', *location_for(beaker_rspec_version)
  else
    gem 'beaker-rspec',  :require => false
  end
  gem 'serverspec',                    :require => false
  gem 'beaker-puppet_install_helper',  :require => false
end



if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion.to_s, :require => false, :groups => [:test]
else
  gem 'facter', :require => false, :groups => [:test]
end

ENV['PUPPET_VERSION'].nil? ? puppetversion = '~> 4.0' : puppetversion = ENV['PUPPET_VERSION'].to_s
gem 'puppet', puppetversion, :require => false, :groups => [:test]

# vim: syntax=ruby
