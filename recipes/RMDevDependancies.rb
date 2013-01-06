#
# Cookbook Name:: ResourceManager
#
# Copyright 2011, Zenoss, Inc.
#
#


include_recipe "ZenossEnterprise::RMDependancies"
include_recipe "erlang"
ruby_block "reload-internal-yum-cache" do
    block do
        Chef::Provider::Package::Yum::YumCache.instance.reload
    end
    action :nothing
end

include_recipe "rabbitmq"

case node[:platform]
        when "centos"
           include_recipe "yum"
           include_recipe "build-essential"
           #Update to the latest packages
           execute "yum_update" do
               command "yum -y update"
               user "root"
               action :run
           end

           managed_packages = %w{pango-devel readline-devel gettext-devel libxml2-devel libxslt-devel}
           managed_packages += %w{openssl-devel openldap-devel pcre-devel net-snmp-devel zlib-devel}
           managed_packages += %w{automake bc unzip zip patch swig bison gdb libtool}
           managed_packages += %w{bash pcre-devel openldap-devel net-snmp-utils rrdtool-devel}
          
           #This is a nice to have if you prefer to work in git 
           managed_packages += %w{git-svn}

           # Install the dependencies
           managed_packages.each do |pkg|
              yum_package pkg
           end

           yum_repository "remi" do
                description "remi"
                mirrorlist "http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror"
                enabled "1"
                includepkgs "mysql, mysql-server, mysql-devel, mysql-libs, compat-mysql51"
                action :add
           end


           managed_packages = %w{mysql mysql-server mysql-devel}
           managed_services = %w{mysqld}

           # Install mysql server and the development packages
           managed_packages.each do |pkg|
               yum_package pkg
           end

           # Start the mysql server
           managed_services.each do |svc|
              service svc do
                action [ :enable, :start ]
           end



        end


        when "ubuntu"
           include_recipe "apt"
           include_recipe "build-essential"

           managed_packages = %w{libsasl2-dev libldap2-dev libxslt-dev librrd-dev libaio-dev build-essential}
           managed_packages += %w{libpango1.0-dev libreadline-dev libsnmp-dev libssl-dev unzip zip}
           managed_packages += %w{libmysqlclient-dev libreadline-dev libssl-dev swig autoconf bc}

           # Install the dependencies
           managed_packages.each do |pkg|
              package pkg
           end
           
           managed_packages = %w{mysql-server-5.5}
           managed_services = %w{mysql}

           # Install mysql server and the development packages
           managed_packages.each do |pkg|
               package pkg
           end

           # Start the mysql server
           managed_services.each do |svc|
              service svc do
                action [ :enable, :start ]
               end
          end
end

include_recipe "java"
include_recipe "git"
include_recipe "subversion"
include_recipe "subversion::client"
include_recipe "ZenossEnterprise::ZenossUser"
include_recipe "maven::maven3"
include_recipe "ant::bin_install"
