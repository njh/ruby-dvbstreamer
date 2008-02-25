#!/usr/bin/ruby

$: << 'lib/' << '../lib/'

require 'webrick'
require 'controller'
require 'config'
include WEBrick



## Load configuration
root = File.dirname(__FILE__)
config = WebDVB::Config.load( File.join(root, 'config.yaml') )

## Add .rhtml to MIME types
mime_table = HTTPUtils::DefaultMimeTypes
mime_table.merge!( {'rhtml' => 'text/html' } )

## Start the HTTP server
s = HTTPServer.new(
  :Port => config.http_port,
  :BindAddress => config.http_address,
  :MimeTypes => mime_table
)

## setup the handlers
s.mount("/", WebDVB::Controller, :index)
s.mount("/channels", WebDVB::Controller, :channels )
s.mount("/nownext", WebDVB::Controller, :nownext )
s.mount("/select", WebDVB::Controller, :select )
s.mount("/static", HTTPServlet::FileHandler, File.join(root, "static"), true )

trap("INT"){ s.shutdown }
s.start

