name "Jre"
description "Role to use as a basis for configuring a jre"

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
