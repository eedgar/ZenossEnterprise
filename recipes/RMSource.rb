#
# Cookbook Name:: ResourceManager
#
# Copyright 2011, Zenoss, Inc.
#
#

username = node["RM"]["zenoss_src"]["svn_username"]
password = node["RM"]["zenoss_src"]["svn_password"]

include_recipe "ZenossEnterprise::RMDevDependancies"

directory "/home/zenoss/source/trunk/inst" do
  owner "zenoss"
  group "zenoss"
  mode "0755"
  action :create
  recursive true
  not_if "test -d /home/zenoss/source/trunk/inst"
end

subversion "Zenoss Trunk" do
    repository "http://dev.zenoss.com/svnint/trunk/core/inst"
    revision "HEAD"
    svn_username "#{username}"
    svn_password "#{password}"
    user         "zenoss"
    group        "zenoss"
    destination "/home/zenoss/source/trunk/inst"
    action :sync
end

execute "configure zenoss" do
   command "SVNUSER=#{username} SVNPASSWORD='#{password}' SVNARGS='--no-auth-cache' BUILD64=1 ZENHOME=/home/zenoss/zenosstrunk ./configure"
   cwd '/home/zenoss/source/trunk/inst'
   user "zenoss"
   action :run
end

execute "make zenoss" do
   command 'make -f zenoss.mk'
   cwd '/home/zenoss/source/trunk/inst'
   user "zenoss"
   action :run
end

execute "configure rabbitmq" do
    command "/usr/sbin/rabbitmqctl add_user zenoss zenoss;/usr/sbin/rabbitmqctl add_vhost /zenoss;/usr/sbin/rabbitmqctl set_permissions -p /zenoss zenoss '.*' '.*' '.*'"
    user "root"
    action :run
end

execute "deploy zenoss" do
   command './mkzenossinstance.sh 2>&1'
   cwd '/home/zenoss/source/trunk/inst'
   environment ({
       'LD_LIBRARY_PATH' => "/home/zenoss/zenosstrunk/lib",
       'PYTHONPATH' => "/home/zenoss/zenosstrunk/lib/python",
       'ZENHOME' => "/home/zenoss/zenosstrunk",
       'PATH' => "/home/zenoss/zenosstrunk/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin",
       'PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION' => 'cpp'
   })
   user "zenoss"
   action :run
end

execute "setuid files" do
   command "chown root:zenoss pyraw;chown root:zenoss zensocket;chown root:zenoss nmap;chmod 04750 pyraw;chmod 04750 zensocket;chmod 04750 nmap"
   cwd '/home/zenoss/zenosstrunk/bin'
   user "root"
   action :run
end

execute "zenoss start" do
    command "/home/zenoss/zenosstrunk/bin/zenoss start"
    user "zenoss"
    action :run
end
