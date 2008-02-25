#!/usr/bin/ruby

require 'dvbstreamer/client'
require 'base_controller'


module WebDVB

  class Controller < BaseController
  
    def index
      dvbs = new_dvbstreamer_client
  
      @channels = dvbs.channels
      @current = dvbs.current

      # Work out the MRL for the web client
      @mrl = "udp://@"+@request.peeraddr[3]+":1234"
      dvbs.command('setmrl', @mrl.gsub(/@/,''))
      
      render "views/index.rhtml"
      dvbs.close
    end


    def channels
      dvbs = new_dvbstreamer_client
      render_json( dvbs.channels )
      dvbs.close
    end

    def nownext
      dvbs = new_dvbstreamer_client
      render_json( { :now => dvbs.now, :next => dvbs.next } )
      dvbs.close
    end

    def select
      dvbs = new_dvbstreamer_client
      channel = @request.query.keys.first
      result = dvbs.command("select", channel)
      raise "Failed to select channel: "+result.status unless result.is_success?
      render_json( { :channel => result.content.join("\n") } )
      dvbs.close
    end
      
    private
    
    def new_dvbstreamer_client
      config = WebDVB::Config.instance
      dvbs = DVBStreamer::Client.new(
         config.dvbstreamer_host,
         config.dvbstreamer_adaptor
      )
      dvbs.authenticate(
        config.dvbstreamer_username,
        config.dvbstreamer_password
      )
      return dvbs
    end

  end

end