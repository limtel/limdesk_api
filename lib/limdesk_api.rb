require "faraday"
require "recursive_open_struct"
require "faraday_middleware"
require "json"
require "limdesk_api/version"
require "limdesk_api/client"
require "limdesk_api/activity"
require "limdesk_api/ticket"

module LimdeskApi

  ENDPOINT = 'https://cloud.limdesk.com'

  KNOWN_OBJS = {
    ticket: :tickets,
    activity: :activities,
    client: :clients,
  }

  def self.configure
    yield self
    @connection = Faraday.new(:url => ENDPOINT) do |faraday|
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter Faraday.default_adapter 
      faraday.use Faraday::Response::Logger if @debug
    end
    @prefix = "/api/v#{@version}"
    return self
  end

  def self.key=(key)
    return @key = key
  end

  def self.version=(version)
    return @version = version
  end

  def self.debug=(debug)
    return @debug = debug
  end

  def self.get_one(params)
    resp = @connection.get do |req|
      req.url "#{@prefix}/#{LimdeskApi::KNOWN_OBJS[params[:object]]}/#{params[:id]}"
      req.params[:key] = @key
    end
    case resp.status
    when 200
      raise "LimdeskApiError" unless resp.body.kind_of?(Hash) && resp.body['status'] == "ok"
      return nil if resp.body[params[:object].to_s].nil?
      return resp.body[params[:object].to_s]
    when 404
      return nil
    else
      raise "LimdeskApiErrorFatal"
    end
  end

  def self.get_many(params)
    resp = @connection.get do |req|
      req.url "#{@prefix}/#{LimdeskApi::KNOWN_OBJS[params[:object]]}"
      req.params[:key] = @key
      req.params[:page] = params[:page] if params[:page].to_i > 0
    end
    case resp.status
    when 200
      raise "LimdeskApiError" unless resp.body.kind_of?(Hash) && resp.body['status'] == "ok"
      raise "LimdeskApiError" unless resp.body['page'] && resp.body['total_pages']
      raise "LimdeskApiError" unless resp.body[LimdeskApi::KNOWN_OBJS[params[:object]].to_s]
      return {  :page=>resp.body['page'],
                :total_pages=>resp.body['total_pages'],
                :objects=>resp.body[LimdeskApi::KNOWN_OBJS[params[:object]].to_s] }
    else
      raise "LimdeskApiErrorFatal"
    end
  end

  def self.create(params)
    resp = @connection.post do |req|
      req.url "#{@prefix}/#{LimdeskApi::KNOWN_OBJS[params[:object]]}"
      req.params[:key] = @key
      req.body = params[:params].to_json
    end
    case resp.status
    when 200
      raise "LimdeskApiError" unless resp.body.kind_of?(Hash) && resp.body['status']
      return { error: true, msg: resp.body['msg'] } if resp.body['status'] == "error"
      raise "LimdeskApiError" if resp.body[params[:object].to_s].nil?
      return resp.body[params[:object].to_s]
    else
      raise "LimdeskApiErrorFatal"
    end
  end

  def self.put(params)
    self.update(:put, params)
  end

  def self.post_simple(params)
    self.update(:post, params)
  end

  def self.delete(params)
    self.update(:delete, params)
  end

  def self.update(method, params)
    url = "#{@prefix}/#{LimdeskApi::KNOWN_OBJS[params[:object]]}/#{params[:id]}"
    url += "/#{params[:action]}" if params[:action]
    resp = @connection.send(method) do |req|
      req.url url
      req.params[:key] = @key
      req.body = params[:params].to_json
    end
    case resp.status
    when 200
      raise "LimdeskApiError" unless resp.body.kind_of?(Hash) && resp.body['status']
      if resp.body['status'] == "ok"
        return { error: false }
      else
        return { error: true, msg: resp.body['msg'] }
      end
    else
      raise "LimdeskApiErrorFatal"
    end
  end

end
