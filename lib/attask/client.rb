# -*- encoding : utf-8 -*-
# frozen_string_literal: true

module Attask
  # lib/attask/client.rb
  class Client
    def initialize(app, opts = {})
      @app = app
      @opts = opts
      @endpoint = "https://#{app}.attask-ondemand.com/attask/api/v6.0"
      @session_id = session_id
    end

    def search(object_code, params = {}, fields = [])
      params = merge_hashes(params, fields: fields.join(','))
      path = mount_path(object_code, '/search')
      request(:get, path, params)
    end

    def get_list(object_code, ids = [], fields = [])
      params = merge_hashes({ id: ids.join(',') }, fields: fields.join(','))
      path = mount_path(object_code, '')
      request(:get, path, params)
    end

    def get(object_code, object_id, params = {}, fields = [])
      params = merge_hashes(params, fields: fields.join(','))
      path = mount_path(object_code, object_id)
      request(:get, path, params)
    end

    def put(object_code, object_id, params = {}, fields = [])
      params = merge_hashes(params, fields: fields.join(','))
      path = mount_path(object_code, object_id)
      request(:put, path, params)
    end

    def post(object_code, object_id, params = {}, fields = [])
      params = merge_hashes(params, fields: fields.join(','))
      path = mount_path(object_code, object_id)
      request(:post, path, params)
    end

    def delete(object_code, object_id, params = {})
      path = mount_path(object_code, object_id)
      request(:delete, path, params)
    end

    def upload(updates, image_path, data_format)
      updates[:handle] = handle(image_path, data_format)
      params = { updates: updates.to_json }
      path = mount_path('document')
      request(:post, path, params)
    end

    def download(download_url, filename)
      path = mount_download_path(download_url)
      response = request(:get, path)
      save_file(filename, response)
    end

    private

    def mount_path(object_code, object_id = '', login_path = false)
      return "#{@endpoint}/#{object_code}#{object_id}" if login_path
      "#{@endpoint}/#{object_code}#{object_id}?sessionID=#{@session_id}"
    end

    def mount_download_path(download_url)
      s_id = @session_id
      "https://#{@app}.attask-ondemand.com/#{download_url}&sessionID=#{s_id}"
    end

    def handle(image_path, data_format)
      params = payload_file(image_path, data_format)
      path = mount_path('upload')
      request(:post, path, params)['data']['handle']
    end

    def payload_file(image_path, data_format)
      { uploadedFile: Faraday::UploadIO.new(image_path, data_format) }
    end

    def session_id
      login['data']['sessionID']
    end

    def login
      params = { username: Config.username, password: Config.password }
      path = mount_path('login', '', true)
      request(:post, path, params)
    end

    def merge_hashes(*objs)
      objs.inject({}) { |obj, query| query.merge(obj) }.delete_if do |_, v|
        v.empty?
      end
    end

    def save_file(filename, file)
      File.open(filename, 'wb') { |f| f.write(file) }
    end

    def request(method, path, params = {}, headers = {})
      Request.new(path, @opts).send(method, '', params, headers).body
    end
  end
end
