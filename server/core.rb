#!/usr/bin/env ruby
#--
# This file is part of Sonic Pi: http://sonic-pi.net
# Full project source: https://github.com/samaaron/sonic-pi
# License: https://github.com/samaaron/sonic-pi/blob/master/LICENSE.md
#
# Copyright 2013, 2014, 2015, 2016 by Sam Aaron (http://sam.aaron.name).
# All rights reserved.
#
# Permission is granted for use, copying, modification, and
# distribution of modified versions of this work as long as this
# notice is included.
#++

## This core file sets up the load path and applies any necessary monkeypatches.

raise "Sonic Pi requires Ruby 2+ to be installed. You are using version #{RUBY_VERSION}" if RUBY_VERSION < "2"

## Ensure native lib dir is available
require 'rbconfig'
require_relative "../lib/types"
ruby_api = RbConfig::CONFIG['ruby_version']


## Ensure all libs in vendor directory are available
Dir["#{File.expand_path("../vendor", __FILE__)}/*/lib/"].each do |vendor_lib|
  $:.unshift vendor_lib
end

begin
  require 'did_you_mean'
rescue LoadError
  warn "Non-critical error: Could not load did_you_mean"
end

require 'hamster/vector'
require 'wavefile'

os = case RUBY_PLATFORM
     when /.*arm.*-linux.*/
       :raspberry
     when /.*linux.*/
       :linux
     when /.*darwin.*/
       :osx
     when /.*mingw.*/
       :windows
     else
       RUBY_PLATFORM
     end

# special case for proctable lib
sys_proctable_os = case os
                   when :raspberry
                     "linux"
                   when :linux
                     "linux"
                   when :windows
                     "windows"
                   when :osx
                     "darwin"
                   end
$:.unshift "#{File.expand_path("../vendor", __FILE__)}/sys-proctable-1.1.3/lib/#{sys_proctable_os}"


$:.unshift "#{File.expand_path("../rb-native", __FILE__)}/#{ruby_api}/"

require 'win32/process' if os == :windows

## Add aubio native library to ENV if not present (the aubio library needs to be told the location)
native_lib_path = File.expand_path("../../native/", __FILE__)
ENV["AUBIO_LIB"] ||= Dir[native_lib_path + "/lib/libaubio*.{*dylib,so*,dll}"].first
