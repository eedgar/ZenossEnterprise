#
# Cookbook Name:: ResourceManager
#
# Copyright 2011, Zenoss, Inc.
#
#

username = node["RM"]["zenoss_src"]["svn_username"]
password = node["RM"]["zenoss_src"]["svn_password"]

include_recipe "ZenossEnterprise::RMDevDependancies"

managed_packages = %w{rpm-build}

# Install packages
managed_packages.each do |pkg|
    yum_package pkg
end


subversion "Zenoss RPM Tree" do
    #repository "http://dev.zenoss.com/svnint/branches/zenoss-4.2.x/pkg"
    repository "http://dev.zenoss.com/svnint/sandboxen/eedgar/zen-3626"
    revision "HEAD"
    svn_username "#{username}"
    svn_password "#{password}"
    user         "zenoss"
    group        "zenoss"
    destination "/home/zenoss/pkg"
    action :sync
end

execute "configure zenoss" do
   environment ({
       'SVNUSER' => "#{username}",
       'SVNPASSWORD' =>"#{password}",
       'SVNARGS' => '--no-auth-cache',
       'SVNTAG' => 'branches/core/zenoss-4.2.x'
   })
   command "make zenoss_resmgr"
   cwd '/home/zenoss/pkg'
   user "zenoss"
   action :run
end
