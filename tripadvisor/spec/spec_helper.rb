require 'rubygems'
require 'rspec'

$ROOT_PATH = $home = File.expand_path(File.dirname(File.expand_path(__FILE__)) + "/..")
$: <<  "#{$home}/lib"
$: <<  "#{$home}/spec"
