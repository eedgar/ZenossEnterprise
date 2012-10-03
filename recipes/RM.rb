#
# Cookbook Name:: ResourceManager
#
# Copyright 2011, Zenoss, Inc.
#
#

#require 'chef/data_bag'

#if Chef::DataBag.list.key?('unique_name')
#      new_databag = Chef::DataBag.new
#        new_databag.name('unique_name')
#          new_databag.save
#end


include_recipe "ZenossEnterprise::RMDependancies"
include_recipe "erlang"
include_recipe "rabbitmq"

case node[:platform]
    when "centos"
        # Centos 5 or 6
        major = node['platform_version'].to_i
        if "#{major}" == '5'
            centos_version = "centos5"
        end
        if "#{major}" == '6'
            centos_version = "centos6"
        end

        if node[:kernel][:machine] == "i686"
            rpm_arch = "i386"
        else
            rpm_arch = node[:kernel][:machine]
        end

        zenoss_version = node['RM'][centos_version][rpm_arch]['url'].split('/')[-1].split('-')[1]

        include_recipe "zends::server_rpmonly"

        filename = node['RM'][centos_version][rpm_arch]['url'].split('/')[-1]
        localfile = "#{Chef::Config[:file_cache_path]}/#{filename}"
        remote_file "#{localfile}" do
          source node['RM'][centos_version][rpm_arch]['url']
          action :create_if_missing
        end

        rpm_package "#{localfile}" do
          options "--nodeps"
          action :install
        end

        # Update the global.conf on 4.1.1+
        if zenoss_version > '4.1.1'
            template "/opt/zenoss/etc/global.conf" do
                source 'global.conf.erb'
                owner 'zenoss'
                group 'zenoss'
                mode "0644"
            end
        end

        service "zenoss" do
            start_command "/etc/init.d/zenoss start"
            stop_command "/etc/init.d/zenoss stop"
            supports :status => true, :restart => true, :reload => false
            action [ :enable, :start ]
        end

        core_zenpacks_filename = node['RM'][centos_version][rpm_arch]['core_zenpacks']['url'].split('/')[-1]
        enterprise_zenpacks_filename = node['RM'][centos_version][rpm_arch]['enterprise_zenpacks']['url'].split('/')[-1]

        core_zenpacks_localfile = "#{Chef::Config[:file_cache_path]}/#{core_zenpacks_filename}"
        enterprise_zenpacks_localfile = "#{Chef::Config[:file_cache_path]}/#{enterprise_zenpacks_filename}"

        remote_file "#{core_zenpacks_localfile}" do
          source node['RM'][centos_version][rpm_arch]['core_zenpacks']['url']
          action :create_if_missing
        end

        remote_file "#{enterprise_zenpacks_localfile}" do
          source node['RM'][centos_version][rpm_arch]['enterprise_zenpacks']['url']
          action :create_if_missing
        end

        rpm_package "#{core_zenpacks_localfile}" do
          action :install
        end

        rpm_package "#{enterprise_zenpacks_localfile}" do
          action :install
        end
    end






#https://github.com/opscode/chef/blob/master/chef/lib/chef/util/file_edit.rb
#ruby_block "edit resolv conf" do
#  block do
#    rc = Chef::Util::FileEdit.new("/etc/resolv.conf")
#    rc.search_file_replace_line(/^search/, "search #{node["dynect"]["domain"]} compute-1.internal")
#    rc.search_file_replace_line(/^domain/, "domain #{node["dynect"]["domain"]}")
#    rc.write_file
#  end
#end
#/opt/zenoss/.fresh_install
#/opt/zenoss/.upgraded
