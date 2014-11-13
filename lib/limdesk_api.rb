require 'faraday'
require 'recursive_open_struct'
require 'faraday_middleware'
require 'json'
require 'limdesk_api/version'
require 'limdesk_api/limdesk_object'
require 'limdesk_api/client'
require 'limdesk_api/activity'
require 'limdesk_api/ticket'
require 'limdesk_api/sale'

# LideskAPI Warapper
# Limdesk.com is a multichannel, web-based customer support solution.
# This gem lets you integrate your software using LimdeskAPI.
module LimdeskApi
  # default endpoint
  ENDPOINT = 'https://cloud.limdesk.com'

  KNOWN_OBJS = {
    ticket: :tickets,
    activity: :activities,
    client: :clients,
    sale: :sales
  }

  # @example configure API access
  #   LimdeskApi.configure { |lim| lim.key = 'xxx'; lim.version = 1 }
  def self.configure
    yield self
    @connection = Faraday.new(url: ENDPOINT) do |faraday|
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter Faraday.default_adapter
      faraday.use Faraday::Response::Logger if @debug
    end
    @prefix = "/api/v#{@version}"
    self
  end

  def self.key=(key)
    @key = key
  end

  def self.version=(version)
    @version = version
  end

  def self.debug=(debug)
    @debug = debug
  end

  def self.generate_url(params)
    url = [@prefix, LimdeskApi::KNOWN_OBJS[params[:object]]]
    url.push params[:id] if params[:id]
    url.push params[:action] if params[:action]
    url.join('/')
  end

  def self.check_get_one_response(body)
    fail 'LimdeskApiError' if !body.is_a?(Hash) ||
                              body['status'] != 'ok'
  end

  # get a single LimdeskAPI object
  #
  # @param [Hash] params
  # @option params [Symbol] :object one of LimdeskApi::KNOWN_OBJS
  # @option params [Integer] :id requested object's id
  def self.get_one(params)
    resp = @connection.get do |req|
      req.url generate_url params
      req.params[:key] = @key
      req.params[:query] = params[:query] if params[:query]
    end
    case resp.status
    when 200
      body = resp.body
      check_get_one_response(body)
      body[params[:object].to_s]
    when 404
      nil
    else
      fail 'LimdeskApiErrorFatal'
    end
  end

  def self.check_get_page_response(body, obj)
    fail 'LimdeskApiError' if !body.is_a?(Hash) ||
                              body['status'] != 'ok' ||
                              body['page'].nil? ||
                              body['total_pages'].nil? ||
                              body[obj.to_s].nil?
  end

  # get a page of LimdeskAPI object
  #
  # @param [Hash] params
  # @option params [Symbol] :object one of LimdeskApi::KNOWN_OBJS
  # @option params [Integer] :page requested page
  def self.get_page(params)
    obj = LimdeskApi::KNOWN_OBJS[params[:object]]
    resp = @connection.get do |req|
      req.url generate_url params
      req.params[:key] = @key
      req.params[:page] = params[:page]
    end
    case resp.status
    when 200
      body = resp.body
      check_get_page_response(body, obj)
      {  page: body['page'],
         total_pages: body['total_pages'],
         objects: body[obj.to_s] }
    else
      fail 'LimdeskApiErrorFatal'
    end
  end

  # get all LimdeskAPI objects of a type
  #
  # @param [Symbol] object_name t one of LimdeskApi::KNOWN_OBJS
  def self.get_all(object_name)
    query_options = { page: 0, object: object_name }
    data = []
    loop do
      query_options[:page] += 1
      results = LimdeskApi.get_page(query_options)
      data += results[:objects]
      break if results[:total_pages] == results[:page] || results[:page] == 0
    end
    data
  end

  def self.check_create_response(body, obj)
    fail 'LimdeskApiError' if !body.is_a?(Hash) ||
                              body['status'].nil? ||
                              body['status'] == 'error' ||
                              body[obj.to_s].nil?
  end

  # create LimdeskAPI object
  #
  # @param [Hash] params new object data
  def self.create(params)
    resp = @connection.post do |req|
      req.url generate_url params
      req.params[:key] = @key
      req.body = params[:params].to_json
    end
    case resp.status
    when 200
      body = resp.body
      check_create_response(body, params[:object])
      body[params[:object].to_s]
    else
      fail 'LimdeskApiErrorFatal'
    end
  end

  def self.check_update_resonse(body)
    fail 'LimdeskApiError' if !body.is_a?(Hash) ||
                              body['status'].nil?
  end

  # update/delete a LimdeskAPI object
  #
  # @param [Symobol] method a http method, one of :put, :post, :delete
  # @param [Hash] params object data, if required
  def self.update(method, params)
    resp = @connection.send(method) do |req|
      req.url generate_url params
      req.params[:key] = @key
      req.body = params[:params].to_json
    end
    case resp.status
    when 200
      body = resp.body
      check_update_resonse(body)
      body['status'] == 'ok' ? true : false
    else
      fail 'LimdeskApiErrorFatal'
    end
  end

  def self.put(params)
    update(:put, params)
  end

  def self.post_simple(params)
    update(:post, params)
  end

  def self.delete(params)
    update(:delete, params)
  end
end
