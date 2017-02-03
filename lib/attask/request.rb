# -*- encoding : utf-8 -*-
# frozen_string_literal: true

module Attask
  # lib/attask/request.rb
  class Request
    Response = Struct.new(:body)

    def initialize(endpoint, opts = {})
      @conn = Faraday::Connection.new(endpoint) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter :patron
        faraday.options.merge!(opts)
      end
    end

    def get(path, params = {}, headers = {})
      make_request(:get, path, params, headers)
    end

    def post(path, params = {}, headers = {})
      make_request(:post, path, params, headers)
    end

    def put(path, params = {}, headers = {})
      make_request(:put, path, params, headers)
    end

    def delete(path, params = {}, headers = {})
      make_request(:delete, path, params, headers)
    end

    private

    def make_request(method, path, params = {}, headers = {})
      response = @conn.send(method, path, params, headers)
      body = response.body
      return Response.new(body) if response.headers['Content-Type'].nil?
      Response.new(Oj.load(body))
    rescue
      Response.new(body)
    end
  end
end
