name "ZenossCSA"
description "Role to use as a basis for configuring a Zenoss CSA instance"

#shasum5.12 -a 256 jre*.bin
# Ubuntu files
#72814cf0e87dd1e6ea65f5f2827515dc43ea97256f5c7af3cca9d86555403fbb  jdk-6u35-linux-i586.bin
#01dd8c70866ffd6351987bf7cb2331f077539f84d24a9c4581f230be5422a6bb  jdk-6u35-linux-x64.bin
#55959143e602cb4edf2786d0f78c288eb44e7f105836aa949f2e0081a2fbd70c  jre-6u35-linux-i586.bin
#13c6d118e0f923c5dbaed49bdfd82857be7453c831000088305d47182bfad089  jre-6u35-linux-x64.bin

# Centos files
#4d6c7cdb2cd2bab18c88a7ff48c2c2cc20aa5750d9af1fdd9344a10517966e76  jdk-6u35-linux-i586-rpm.bin
#a31198860f9f718077a746adf5ee48479b3b830d376b425c39b784087156b5a1  jdk-6u35-linux-x64-rpm.bin
#08ff19634baed842f07a4d833156eebfd130c8edc2e46b0d4f8e9b3a17af0cef  jre-6u35-linux-i586-rpm.bin
#a1845a5bdbb96e3d31aab8b0a670df4988b550985c29e2590f6a2c1061ad406f  jre-6u35-linux-x64-rpm.bin


run_list(
        )

default_attributes(
                  'java' => {
                      'install_flavor' => "oracle_jre",
                      'java_home' => '/usr/java/default/',
                      "jre" => {
                         "6" => {
                            "x86_64" => {
                                "url" => "http://192.168.87.1:8080/jre-6u35-linux-x64-rpm.bin",
                                "checksum" => "a1845a5bdbb96e3d31aab8b0a670df4988b550985c29e2590f6a2c1061ad406f", # sha256 checksum
                            }
                         }
                      },
                   },
                   "rabbitmq" => {
                      "url" => "http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.6/rabbitmq-server-2.8.6-1.noarch.rpm"
                   },
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
                   },
                   "RM" => {
                      'ZODBADMINPASSWORD' => "Zenoss1",
                      'ZEPADMINPASSWORD' => "Zenoss1",
                      'server' => { 
                         'admin_password' => "zenoss",
                         'daemons' => [
                            'zencatalogservice',
                            'zeneventserver',
                            'zopectl',
                            'zenhub',
                            'zenjobs',
                            'zeneventd',
                            'zenimpactstate',
                            'zenimpactgraph',
                            'zenimpactserver',
                          ],
                          'daemons_txt_only' => TRUE
                      },
                      "centos6" => {
                         "x86_64" => {
                             "url" => "http://192.168.87.1:8080/zenoss-4.2.1-1616.el6.x86_64.rpm",
                             }
                      }
                    }
                    )

          
run_list(
        "recipe[zends::server]",
        "recipe[ZenossEnterprise::ZenossCSA_RM]",
        "recipe[ZenossEnterprise::RMPostInstall]"
        )
