name "ZenossSrcCentos"
description "Role to use as a basis for configuring a Zenoss Server from src"

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

default_attributes(
                  'java' => {
                      'install_flavor' => "oracle",
                      'java_home' => '/usr/java/default/',
                      "jdk" => {
                         "6" => {
                            "x86_64" => {
                                "url" => "http://192.168.87.1:8080/jdk-6u35-linux-x64-rpm.bin", # Downloaded to a local webserver
                                "checksum" => "a31198860f9f718077a746adf5ee48479b3b830d376b425c39b784087156b5a1", # sha256 checksum
                            }
                         }
                      },
                   },
                   "RM" => {
                      'ZODBADMINPASSWORD' => "Zenoss1",
                      'ZEPADMINPASSWORD' => "Zenoss1",
                      "zenoss_src" => {
                         "svn_username" => "username_replace_me",
                         "svn_password" => "password_replace_me",
                      },
                   },
                   "rabbitmq" => {
                        "url" => "http://www.rabbitmq.com/releases/rabbitmq-server/v2.8.6/rabbitmq-server-2.8.6-1.noarch.rpm"
                   },
                   'maven' => {
                        '3' => {
                            'url' => 'http://apache.cs.utah.edu/maven/maven-3/3.0.4/binaries/apache-maven-3.0.4-bin.tar.gz'
                        }
                   }
)

          
run_list(
        "recipe[ZenossEnterprise::RMSource]"
        )
