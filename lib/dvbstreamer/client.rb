#
# Author::    Nicholas Humfrey
# Copyright:: Copyright (c) 2007, Nicholas Humfrey
# License::   dvbstreamer-ruby is free software distributed under the GNU Public License.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'socket'


module DVBStreamer # :nodoc:
		
	## Constants
	DEFAULT_HOST='localhost'
	DEFAULT_ADAPTOR=0
	DEFAULT_USERNAME='dvbstreamer'
	DEFAULT_PASSWORD='dvbstreamer'
	DEFAULT_TIMEOUT=5
	BASE_PORT=54197


	class Response
		attr_reader :version, :code, :status, :content
		
		def initialize(line=nil)
			# Initialize the instance variables
			@version = nil
			@code = nil
			@status = nil
			@content = []
			
			# Parse a line, if one is given
			parse_line(line) unless line.nil?
		end
		

		## Method to parse a line returned by the server
		def parse_line(line)
			matches = Regexp.new('^DVBStreamer/([\d\.]+)/(\d+)\s(.*)\n$').match(line);
			
			if matches.nil?
				## Not the end of the response yet, just store the line
				@content.push(line.chomp)
			else
				## End of the reponse
				@version = matches[1]
				@code = matches[2].to_i
				@status = matches[3]
			end
		end
		
		def is_success?
			return @code == 0x0000
		end
		
	end


	class Client
		attr_reader :server_version
		
		def initialize(host=DEFAULT_HOST, adaptor=DEFAULT_ADAPTOR)
	
			# Create a TCP Socket
			@socket = TCPSocket.new(host, BASE_PORT+adaptor)
			
			# Read the response line and check it is a DVBStreamer server
			response = Response.new( @socket.readline )
			raise("Invalid welcome line from DVBStreamer server") if response.code.nil?
			raise("Remote DVBStreamer server is not ready") if (response.status != 'Ready');	
			
			# Store the server version
			@server_version = response.version
		end
		
		## Close the socket
		def close
			@socket.close
		end
	
		## Send a commend to the server
		def command(cmd,*args)
		
			# Add the commend to the start of the arguments
			args.unshift(cmd)
	
			# Send the command it its arguments to the server
			$stderr.puts "Sending: "+args.join(' ')
			@socket.puts(args.join(' '))
	
			# FIXME: insert timeout code here
			# FIXME: add re-connect code
			
			# Read in the response line by line
			response = Response.new
			while (line = @socket.readline)
				# Parse the line into the response object
				response.parse_line( line )
				
				# Stop when we have a response code
				return response unless response.code.nil?
			end
			
			return nil
		end
	
		## Authenticate with the server
		def authenticate(username=DEFAULT_USERNAME, password=DEFAULT_PASSWORD)
			command('auth',username,password)
		end
	
	
		## Get a variable by name
		def get(name)
			command('get', name)
		end
		
		## Set a variable by name
		def set(name, value)
			command('set', name, value)
		end
		
		## Return a list of variables
		def vars
			command('vars')
		end
		
		## Return an array of service names
		def services
			command('lsservices')
		end
		
		def channels
			result = command('lslcn')
			channels = Hash.new
			for channel in result.content
			  m = channel.match( /(\d+) : (.+)/ )
			  channels[m[1].to_i] = m[2] unless m.nil?
			end
			return channels
		end
		
		def current
		  return @current unless (@current.nil?)
		  result = command('current')
		  return nil if result.content.empty?
		  m = result.content.first.match(/(.+) : "(.+)"/)
		  @current = m[2]
		  return @current
		end
		
		
		def now(service=current)
		  result = command('now', service)
		  return parse_now_next( result )
		end

		def next(service=current)
		  result = command('next', service)
		  return parse_now_next( result )
		end
		
		private
		
		def parse_now_next(result)
		  hash = Hash.new
		  while (line = result.content.shift)
		    m = line.match( /(.+?)\s*:\s*(.*)/ )
		    unless m.nil?
		      key = m[1].downcase.gsub(/\W+/,'_')
		      if (key=="description")
		        hash[key] = result.content.shift
		      else 
		        hash[key] = m[2]
		      end
		    end
		      
		  end
		  return hash
		end
	end

end
