#!/usr/bin/ruby
#
# $Id: help.rb $
#

# Just make sure we can run this example from the command
# line even if the gem is not yet installed properly.
$: << 'lib/' << '../lib/'


require 'dvbstreamer/client'

dvbs = DVBStreamer::Client.new
puts dvbs.vars.content
dvbs.close

