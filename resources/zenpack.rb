actions :install, :remove

#package name of the zenpack
attribute :package, :kind_of => String, :name_attribute => true
attribute :version, :kind_of => String
attribute :py_version, :kind_of =>String,  :default => "py2.7" 
attribute :base_url, :kind_of =>String,  :default => "http://dev.zenoss.com/zenpacks/"
attribute :exists, :default => false
