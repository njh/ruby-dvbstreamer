#!/usr/bin/ruby
#
# Example script which simply displays the server version.
#
# $Id: version.rb $
#

# Just make sure we can run this example from the command
# line even if the gem is not yet installed properly.
$: << 'lib/' << '../lib/'


require 'dvbstreamer'

dvbs = DVBStreamer::Client.new('star.aelius.co.uk')
puts "Server Version: "+dvbs.server_version
dvbs.close

