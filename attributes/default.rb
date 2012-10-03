#


::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default_unless['RM']['server']['admin_password'] = secure_password

default['RM']['arch'] = kernel['machine'] =~ /x86_64/ ? "x86_64" : "x86"
default['RM']['centos6']['x86_64']['rrdtool_url'] = "http://pkgs.repoforge.org/rrdtool/rrdtool-1.4.7-1.el6.rfx.x86_64.rpm"
default['RM']['centos6']['x86_64']['perl_rrdtool_url'] = "http://pkgs.repoforge.org/rrdtool/perl-rrdtool-1.4.7-1.el6.rfx.x86_64.rpm"

default['RM']['centos6']['x86_64']['url'] = "http://10.0.2.2:8080/zenoss-4.1.70-1525.el6.x86_64.rpm"
default['RM']['centos6']['x86_64']['core_zenpacks']['url'] = "http://10.0.2.2:8080/zenoss-core-zenpacks-4.1.70-1525.el6.x86_64.rpm"
default['RM']['centos6']['x86_64']['enterprise_zenpacks']['url'] = "http://10.0.2.2:8080/zenoss-enterprise-zenpacks-4.1.70-1525.el6.x86_64.rpm"

default['RM']['OS_USERNAME'] = 'zenoss'
default['RM']['OS_USERSHELL'] = '/bin/bash'
default['RM']['OS_USERHOMEDIR'] = '/home/zenoss'
default['RM']['OS_USERPASSWORD'] = '$1$j6G.pXAq$bcHt4GbcrqC89213AdmSY.'
default['RM']['OS_UID'] = '1337'
default['RM']['OS_GID'] = '600'
default['RM']['ZENHOME'] = '/opt/zenoss'
default['RM']['ZOPEHOME'] = '/opt/zenoss/zopehome'
default['RM']['ZOPEPASSWORD'] = 'zenoss'
default['RM']['PYTHON'] = '/opt/zenoss/bin/python'

# Mysql/Zends Configuration
default['RM']['ZODBHOST'] = 'localhost'
default['RM']['ZODBPORT'] = '13306'
default['RM']['ZODBUSER'] = 'zenoss'
default['RM']['ZODBPASSWORD'] = 'zenoss'
default['RM']['ZODBADMINUSER'] = 'root'
default['RM']['ZODBADMINPASSWORD'] = ''
default['RM']['ZODBDB'] = 'zodb'

default['RM']['ZEPHOST'] = 'localhost'
default['RM']['ZEPPORT'] = '13306'
default['RM']['ZEPUSER'] = 'zenoss'
default['RM']['ZEPPASSWORD'] = 'zenoss'
default['RM']['ZEPADMINUSER'] = 'root'
default['RM']['ZEPADMINPASSWORD'] = ''
default['RM']['ZEPDB'] = 'zenoss_zep'

# Zenoss Databases
default['RM']['MYSQLZODB'] = 'zodb'
default['RM']['MYSQLZEPDB'] = 'zenoss_zep'

# Rabbitmq Configuration
default['RM']['RABBITMQ_HOST'] = 'localhost'
default['RM']['RABBITMQ_SSL'] = '0'
default['RM']['RABBITMQ_PORT'] = '5672'
default['RM']['RABBITMQ_ADMINPORT'] = '55672'
default['RM']['RABBITMQ_ADMIN_SSL'] = '0'
default['RM']['RABBITMQ_VHOST'] = '/zenoss'
default['RM']['RABBITMQ_USER'] = 'zenoss'
default['RM']['RABBITMQ_PASS'] = 'zenoss'

# Memcached Configuration
default['RM']['MEMCACHED_HOST'] = 'localhost'
default['RM']['MEMCACHED_PORT'] = '11211'

# Control the daemon startup
default['RM']['server']['daemons'] = []
default['RM']['server']['daemons_txt_only'] = FALSE

default['RM']['server']['csa_zenpacks'] = {
    "http://192.168.87.1:8080/packs/" => [
        {"ZenPacks.zenoss.AdvancedSearch" => "1.1.0"},
        {"ZenPacks.zenoss.ApacheMonitor" => "2.1.3"},
        {"ZenPacks.zenoss.AuditLog" => "1.2.0"},
        {"ZenPacks.zenoss.AutoTune" => "0.2"},
        {"ZenPacks.zenoss.ZenJMX" => "3.8.1"},
        {"ZenPacks.zenoss.DynamicView" => "1.2.1"},
        {"ZenPacks.zenoss.CSASkin" => "3.2.0"},
        {"ZenPacks.zenoss.CatalogService" => "1.0"},
        {"ZenPacks.zenoss.CiscoMonitor" => "4.0.0"},
        {"ZenPacks.zenoss.CiscoUCS" => "1.7.1"},
        {"ZenPacks.zenoss.DiscoveryMapping" => "1.0.0"},
        {"ZenPacks.zenoss.DistributedCollector" => "2.5.0"},
        {"ZenPacks.zenoss.DnsMonitor" => "2.0.3"},
        {"ZenPacks.zenoss.EnterpriseCollector" => "1.4.0"},
        {"ZenPacks.zenoss.LinuxMonitor" => "1.2.0"},
        {"ZenPacks.zenoss.EnterpriseLinux" => "1.3.4"},
        {"ZenPacks.zenoss.EnterpriseReports" => "2.2.0"},
        {"ZenPacks.zenoss.EnterpriseSecurity" => "1.1.0"},
        {"ZenPacks.zenoss.EnterpriseSkin" => "3.2.0"},
        {"ZenPacks.zenoss.FtpMonitor" => "1.0.3"},
        {"ZenPacks.zenoss.HttpMonitor" => "2.1.0"},
        {"ZenPacks.zenoss.JBossMonitor" => "2.4.1"},
        {"ZenPacks.zenoss.LDAPAuthenticator" => "3.0.0"},
        {"ZenPacks.zenoss.LDAPMonitor" => "1.3.0"},
        {"ZenPacks.zenoss.Licensing" => "0.1"},
        {"ZenPacks.zenoss.MySqlMonitor" => "2.2.0"},
        {"ZenPacks.zenoss.StorageBase" => "1.2.3"},
        {"ZenPacks.zenoss.NetAppMonitor" => "2.4.1"},
        {"ZenPacks.zenoss.NtpMonitor" => "2.0.4"},
        {"ZenPacks.zenoss.SolarisMonitor" => "2.0.2"},
        {"ZenPacks.zenoss.TomcatMonitor" => "2.3.0"},
        {"ZenPacks.zenoss.WebLogicMonitor" => "2.2.1"},
        {"ZenPacks.zenoss.WebScale" => "1.2.0"},
        {"ZenPacks.zenoss.ZenWebTx" => "2.8.0"},
        {"ZenPacks.zenoss.WebsphereMonitor" => "1.2.1"},
        {"ZenPacks.zenoss.ZenDeviceACL" => "2.1.0"},
        {"ZenPacks.zenoss.ZenHoltWinters" => "2.1.0"},
        {"ZenPacks.zenoss.ZenMailTx" => "2.6.0"},
        {"ZenPacks.zenoss.ZenOperatorRole" => "2.0.2"},
        {"ZenPacks.zenoss.ZenSQLTx" => "2.5.0"},
        {"ZenPacks.zenoss.ZenVMware" => "2.0.5"},
        {"ZenPacks.zenoss.Impact" => "1.2.4"},
     ]
}


default['RM']['zenoss_src']['svn_username'] = 'zenoss'
default['RM']['zenoss_src']['svn_password'] = 'zenoss'
