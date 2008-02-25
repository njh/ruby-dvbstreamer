#!/usr/bin/ruby

require 'singleton'
require 'yaml'



module WebDVB

  class Config
    include Singleton
    attr_reader :http_port, :http_address
    attr_reader :dvbstreamer_host, :dvbstreamer_adaptor
    attr_reader :dvbstreamer_username, :dvbstreamer_password
    
    def initialize
      # Setup default values
      @http_port = 8080
      @http_address = nil
      @dvbstreamer_host = '127.0.0.1'
      @dvbstreamer_adaptor = 0
      @dvbstreamer_username = 'dvbstreamer'
      @dvbstreamer_password = 'dvbstreamer'
    end
  
    def self.load(filename)
      config = self.instance
      config.load(filename)
      return config
    end

    def load(filename)
      hash = YAML.load_file(filename)
      raise "Not a Hash" if (hash.class != Hash)
      for key in hash.keys
        self.instance_variable_set( "@#{key}", hash[key] )
      end
    end
  
  end
  
end
