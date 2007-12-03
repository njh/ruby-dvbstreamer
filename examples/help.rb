#!/usr/bin/ruby
#
# $Id: help.rb $
#

# Just make sure we can run this example from the command
# line even if the gem is not yet installed properly.
$: << 'lib/' << '../lib/'


require 'dvbstreamer'

dvbs = DVBStreamer::Client.new('star.aelius.co.uk')
puts dvbs.command('help').content.join("\n")
dvbs.close

