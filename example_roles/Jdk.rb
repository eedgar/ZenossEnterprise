name "Jdk"
description "Role to use as a basis for configuring a jdk"

default_attributes(
                  'java' => {
                      'install_flavor' => "oracle",
                      'java_home' => '/usr/java/default/',
                      "jdk" => {
                         "6" => {
                            "x86_64" => {
                                "url" => "http://192.168.87.1:8080/jdk-6u35-linux-x64-rpm.bin",
                                "checksum" => "a31198860f9f718077a746adf5ee48479b3b830d376b425c39b784087156b5a1", # sha256 checksum
                            }
                         }
                      },
                   },
)

          
run_list(
        "recipe[java]"
        )
