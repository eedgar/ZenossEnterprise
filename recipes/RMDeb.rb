#
# Cookbook Name:: ResourceManager
#
# Copyright 2011, Zenoss, Inc.
#
#

username = node["RM"]["zenoss_src"]["svn_username"]
password = node["RM"]["zenoss_src"]["svn_password"]

include_recipe "ZenossEnterprise::RMDevDependancies"

managed_packages = %w{dh-make devscripts xutils lintian pbuilder}

# Install packages
managed_packages.each do |pkg|
    package pkg
end


subversion "Zenoss RPM Tree" do
    repository "http://dev.zenoss.com/svnint/sandboxen/eedgar/zen-3626"
    revision "HEAD"
    svn_username "#{username}"
    svn_password "#{password}"
    user         "zenoss"
    group        "zenoss"
    destination "/home/zenoss/pkg"
    action :sync
end

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

#execute "configure zenoss" do
#   environment ({
#       'SVNUSER' => "#{username}",
#       'SVNPASSWORD' =>"#{password}",
##       'SVNARGS' => '--no-auth-cache',
#       'SVNTAG' => 'branches/core/zenoss-4.2.x'
#   })
#   command "make zenoss_resmgr"
#   cwd '/home/zenoss/pkg'
#   user "zenoss"
#   action :run
#end
