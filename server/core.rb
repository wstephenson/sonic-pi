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
require 'bundler/setup'
require 'rbconfig'
require_relative "../lib/types"
ruby_api = RbConfig::CONFIG['ruby_version']

begin
  require 'did_you_mean'
rescue LoadError
  warn "Non-critical error: Could not load did_you_mean"
end

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

require 'win32/process' if os == :windows


