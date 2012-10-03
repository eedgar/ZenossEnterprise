# Copyright ...
#

actions :install, :remove


attribute :url, :regex => /^http:\/\/.*(rpm)$/, :default => nil
attribute :default, :equal_to => [true, false], :default => true
