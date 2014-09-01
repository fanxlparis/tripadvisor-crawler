#!/usr/bin/env ruby
# coding: utf-8

$ROOT_PATH = $home = File.expand_path(File.dirname(File.expand_path(__FILE__)) + "/..")
$: <<  "#{$ROOT_PATH}/lib"

require 'rubygems'
require 'tripadvisor'

Tripadvisor::Script::CrowlTripadvisor.start(ARGV)
