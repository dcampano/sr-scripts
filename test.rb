require 'rubygems'
$:.unshift(File.join(File.dirname(__FILE__), "lib"))
require 'lib/sr-scripts.rb'

conn = SrScripts::Compute.find_connection('i-88f8dbb8')

conn2 = SrScripts::Compute.get('us-east-1')

p conn2

p conn.servers.get('i-5a84ad6a')



