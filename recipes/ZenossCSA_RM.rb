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

        node["RM"]["server"]["csa_zenpacks"].each do |url, ahash|
            #package__zp_version.sort_by { |package, zpversion| package }.each do |package, zpversion|
            ahash.each do |data|
                data.each do |package,zpversion|
                  ZenossEnterprise_zenpack "#{package}" do
                    version zpversion
                    base_url url
                    action :install
                    notifies :restart, resources(:service => "zenoss")
                  end
                end
            end
        end
        service "zenoss"
    end
