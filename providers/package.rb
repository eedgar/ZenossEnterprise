# copyright...
action :install do
   filename = new_resource.url.split('/')[-1]
   localfile = "#{Chef::Config[:file_cache_path]}/#{filename}"
   remote_file "#{localfile}" do
     source new_resource.url
     action :create_if_missing
   end
   yum_package "#{localfile}" do
       source "#{localfile}"
       action :install
   end
end
