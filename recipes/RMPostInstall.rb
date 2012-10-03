# manage DAEMONS_TXT_ONLY
if node[:RM][:server][:daemons_txt_only]
    template "/opt/zenoss/etc/DAEMONS_TXT_ONLY" do
        source "daemons_txt_only.erb"
        owner "zenoss"
        group "zenoss"
        mode 0644
    end
else
    File "/opt/zenoss/etc/DAEMONS_TXT_ONLY" do
        action :delete
    end
end

# manage daemons.txt
if node[:RM][:server][:daemons].length > 0
    if node[:RM][:server]['daemons'] != (node[:RM][:server]['current_daemons'] || [] ) 

        Chef::Log.info("we want a daemons.txt and we see we haven't set it yet")

        service 'zenoss' do
            action [ :stop ]
        end

        execute "stop all zenoss" do
          command "pkill -9 -f /opt/zenoss"
          user "root"
          action :run
          returns [0,1]
       end

       template "/opt/zenoss/etc/daemons.txt" do
           source "daemons.txt.erb"
           owner "zenoss"
           group "zenoss"
           mode 0644
           variables({
              :daemons => node[:RM][:server][:daemons]
           })
           notifies :run, resources(:execute => "stop all zenoss"), :immediately
       end

       service 'zenoss' do
           action [ :start ]
       end

       node.set[:RM][:server]['current_daemons'] = node[:RM][:server]['daemons']
       node.save unless Chef::Config[:solo]
    end
else
    File "/opt/zenoss/etc/daemons.txt" do
        action :delete
    end
    node.unset[:RM][:server]['current_daemons']
    node.save unless Chef::Config[:solo]
end

#skip the new install Wizard.
zenoss_zendmd "skip setup wizard" do
  command "dmd._rq = True"
  action :run
end

#use zendmd to set the admin password
zenoss_zendmd "set admin pass" do
  command "app.acl_users.userManager.updateUserPassword('admin', '#{node[:RM][:server][:admin_password]}')"
  action :run
end

#store the public key on the server as an attribute
ruby_block "zenoss public key" do
  block do
    pubkey = IO.read("/home/zenoss/.ssh/id_dsa.pub")
    node.set["RM"]["server"]["zenoss_pubkey"] = pubkey
    node.save
    #write out the authorized_keys for the zenoss user
    ak = File.new("/home/zenoss/.ssh/authorized_keys", "w+")
    ak.puts pubkey
    ak.chown(File.stat("/home/zenoss/.ssh/id_dsa.pub").uid,File.stat("/home/zenoss/.ssh/id_dsa.pub").gid)
  end
  action :nothing
end

#generate SSH key for the zenoss user
execute "ssh-keygen -q -t dsa -f /home/zenoss/.ssh/id_dsa -N \"\" " do
  user "zenoss"
  action :run
  not_if {File.exists?("/home/zenoss/.ssh/id_dsa.pub")}
  notifies :create, resources(:ruby_block => "zenoss public key"), :immediate
end

# Search data_bags/users/*.json for users to add 
begin
  admins = search(:users, "(groups:sysadmin and NOT action:remove)") || []
rescue
  admins = []
end

zenoss_zendmd "add sysadmins" do
    users admins
    action :users
end

# Search data_bags/users/*.json for users to remove
begin
  remove_admins = search(:users, "(action:remove)") || []
rescue
  remove_admins = []
end

zenoss_zendmd "remove sysadmins" do
    users remove_admins
    action :users_remove
end

include_recipe "zenoss::client"
