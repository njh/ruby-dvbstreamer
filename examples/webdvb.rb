#!/usr/bin/ruby
#
# Example script which simply displays the server version.
#
# $Id: version.rb $
#

# Just make sure we can run this example from the command
# line even if the gem is not yet installed properly.
$: << 'lib/' << '../lib/'


require 'rubygems'
require 'camping'
require 'dvbstreamer'


Camping.goes :WebDVB

module WebDVB::Controllers

 	# The root slash shows the `index' view.
	class Index < R '/'
		def get
			render :index 
		end
	end
	
	class ListChannels < R '/channels'
		def get
			dvbs = DVBStreamer::Client.new('star.aelius.co.uk')
			@channels = dvbs.lslcn
			render :channels
		end
	end
end

module WebDVB::Views

   # If you have a `layout' method like this, it
   # will wrap the HTML in the other methods.  The
   # `self << yield' is where the HTML is inserted.
   def layout
     html do
       title { 'My HomePage' }
       body { self << yield }
     end
   end

	# The `index' view.  Inside your views, you express
	# the HTML in Ruby.  See http://code.whytheluckystiff.net/markaby/.
	def index
		h1 'WebDVB'
		p 'Here are some links:'
		ul do
			li { a 'List Channels', :href => '/channels' }
		end
	end

	def channels
		h1 'WebDVB - Channel List'
		for channel in @channels
			p { channel }
		end
	end
	
end
 
 