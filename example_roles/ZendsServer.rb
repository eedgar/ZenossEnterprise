name "ZendsServer"
description "Role to use as a basis for configuring a Zends Server"

run_list(
        "recipe[iptables]",
        "recipe[openssh]", # Setup the ssh iptables rule so vagrant will still work
        "recipe[zends::server]"
        )

default_attributes(
        "zends" => {
          "allow_remote_root" => "true",
          "server_root_password" => "Zenoss1",
          "centos5" => {
               "x86_64" => {
                   "url" => "http://192.168.87.1:8080/zends-5.5.15-1.r51230.el5.x86_64.rpm"
               }
          },
          "centos6" => {
               "x86_64" => {
                   "url" => "http://192.168.87.1:8080/zends-5.5.25a-1.r62360.el6.x86_64.rpm"
               }
          }
        }

        
)
