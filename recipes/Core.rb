#
# Cookbook Name:: ResourceManager
#
# Copyright 2011, Zenoss, Inc.
#
#

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

        #TODO: Create a snmp cookbook and move the net-snmp stuff there.
        managed_services = %w{snmpd}
        managed_packages = %w{net-snmp net-snmp-utils gmp libgomp}

        # According to the Zenoss 4.1.1 installation documentation we need to
        # explicitly install the .x86_64 version of the libgcj package on x86_64
        # systems.
        if rpm_arch == "x86_64"
            managed_packages += %w{libgcj.x86_64}
        elsif rpm_arch == "i386"
            managed_packages += "libgcj"
        end


        # Centos 5 Specific dependencies
        if "#{centos_version}" == 'centos5'
            managed_packages += %w{liberation-fonts}
        end

        # Centos 6 Specific dependencies
        if "#{centos_version}" == 'centos6'
            managed_packages += %w{liberation-fonts-common liberation-mono-fonts liberation-sans-fonts liberation-serif-fonts gpg}
        end


        # Zenoss Core 4 requires additional packages and recipess
        managed_packages += %w{tk unixODBC libxslt}
        include_recipe "java::oracle"
        include_recipe "memcached"
        include_recipe "erlang"
        include_recipe "rabbitmq"
        
        #Zenoss 4.2
        include_recipe "yum::repoforge"
        yum_repository "rpmforge-extras" do
            description "RPMforge.net - extras"
            url "http://apt.sw.be/redhat/el#{major}/en/$basearch/extras"
            mirrorlist "http://apt.sw.be/redhat/el#{major}/en/mirrors-rpmforge-extras"
            enabled "1"
            includepkgs "rrdtool,perl-rrdtool"
            action :add
        end

        managed_packages += %w{xorg-x11-fonts-Type1 ruby libdbi mysqltuner sysstat rrdtool}
        # zenoss
        # zenoss patches
        # zenpacks
        #
        


        # Install the dependencies
        managed_packages.each do |pkg|
            yum_package pkg
        end

        # Start the dependant Services
        managed_services.each do |svc|
            service svc do
                action [ :enable, :start ]
            end
        end

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
        core_zenpacks_localfile = "#{Chef::Config[:file_cache_path]}/#{core_zenpacks_filename}"
        
        remote_file "#{core_zenpacks_localfile}" do
          source node['RM'][centos_version][rpm_arch]['core_zenpacks']['url']
          action :create_if_missing
        end

        rpm_package "#{core_zenpacks_localfile}" do
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
