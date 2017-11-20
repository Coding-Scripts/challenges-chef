# -*- encoding: utf-8 -*-

#
# Cookbook Name:: jenkins-demo
# Recipe:: master
#
# Copyright 2017, DennyZhang.com
#
# All rights reserved - Do Not Redistribute
#

apt_update 'update' if platform_family?('debian')

node.default['java']['install_flavor'] = 'oracle'
node.default['java']['jdk_version'] = '8'
node.default['java']['set_etc_environment'] = true
node.default['java']['oracle']['accept_oracle_download_terms'] = true

if %w[debian ubuntu].include?(node['platform_family'])
  node.default['jenkins']['master']['repository'] = \
    'http://pkg.jenkins-ci.org/debian'
  node.default['jenkins']['master']['repository_key'] = \
    'http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key'
end

node.default['jenkins']['executor']['timeout'] = 360

include_recipe 'java::default'
include_recipe 'jenkins::master'

# Install some plugins needed, but not installed on jenkins2 by default
node['jenkins_demo']['jenkins_plugins'].each do |plugin|
  jenkins_plugin plugin[0] do
    version plugin[1]
    notifies :execute, 'jenkins_command[safe-restart]', :immediately
  end
end

jenkins_command 'safe-restart' do
  action :nothing
end

%w[/var/lib/jenkins/script].each do |x|
  directory x do
    owner 'jenkins'
    group 'jenkins'
    mode 0o755
    action :create
  end
end

# Create password credentials
username = node['jenkins_demo']['default_username']
password = node['jenkins_demo']['default_password']
if username != ''
  # https://gist.github.com/hayderimran7/50cb1244cc1e856873a4
  jenkins_script "add_user #{username}" do
    command <<-EOH.gsub(/^ {4}/, '')
    import jenkins.model.*
    import hudson.security.*

    def instance = Jenkins.getInstance()

    def hudsonRealm = new HudsonPrivateSecurityRealm(false)
    hudsonRealm.createAccount("#{username}", "#{password}")
    instance.setSecurityRealm(hudsonRealm)
    instance.save()
    EOH
    not_if "test -d /var/lib/jenkins/users/#{username}"
  end
end
