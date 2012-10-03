#
# Copyright 2011, Zenoss, Inc.
#
#

username = node['RM']['OS_USERNAME']
user_shell = node['RM']['OS_USERSHELL']
user_homedir = node['RM']['OS_USERHOMEDIR']
user_password = node['RM']['OS_USERPASSWORD']
uid = node['RM']['OS_UID'].to_i
gid = node['RM']['OS_GID'].to_i

group "zenoss" do
 gid gid
 system true
 action :create
end

user username do
 gid "zenoss"
 system true
 comment 'Zenoss User Account'
 home user_homedir
 shell user_shell
 supports :manage_home => 'true'
end

directory user_homedir do
  owner username
  group "zenoss"
  mode "0755"
  action :create
  not_if "test -d #{user_homedir}"
end
