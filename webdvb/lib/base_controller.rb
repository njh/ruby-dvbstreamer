#!/usr/bin/ruby

require 'rubygems'
require 'webrick'
require 'erb'
require 'json'


class BaseController < WEBrick::HTTPServlet::AbstractServlet

  def initialize(server, action)
    super
    @action = action
  end

  def service(req, res)
    @request = req
    @response = res
    method(@action).call
  end

    
  protected
  
  def params(key)
    return nil unless @request.query.has_key?(key)
    return @request.query[key]
  end
  
  def render(filename)
    begin
      data = open(filename) {|io| io.read }
      @response.body = ERB.new(data).result(binding)
      @response['content-type'] = HTTPUtils::mime_type(filename, @config[:MimeTypes])
    rescue StandardError => ex
      raise
    rescue Exception => ex
      @logger.error(ex)
      raise HTTPStatus::InternalServerError, ex.message
    end
  end
  
  def render_json(var)
      @response.body = var.to_json
      @response['content-type'] = 'application/json'
  end
  
end
