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
      params = merge_hashes(@session_id, params, fields: fields.join(','))
      path = mount_path(object_code, '/search')
      request(:get, path, params)
    end

    def get_list(object_code, ids = [], fields = [])
      fields = fields.join(',')
      params = merge_hashes(@session_id, { id: ids.join(',') }, fields: fields)
      path = mount_path(object_code, '')
      request(:get, path, params)
    end

    def get(object_code, object_id, params = {}, fields = [])
      params = merge_hashes(@session_id, params, fields: fields.join(','))
      path = mount_path(object_code, object_id)
      request(:get, path, params)
    end

    def put(object_code, object_id, params = {}, fields = [])
      params = merge_hashes(@session_id, params, fields: fields.join(','))
      path = mount_path(object_code, object_id)
      request(:put, path, params)
    end

    def post(object_code, object_id, params = {}, fields = [])
      params = merge_hashes(@session_id, params, fields: fields.join(','))
      path = mount_path(object_code, object_id)
      request(:post, path, params)
    end

    def delete(object_code, object_id, params)
      path = mount_path(object_code, object_id)
      request(:delete, path, params)
    end

    def handle(image_path, multipart_data_format)
      upload_io = Faraday::UploadIO.new(image_path, multipart_data_format)
      params = { uploadedFile: upload_io }
      path = mount_path("upload?sessionID=#{session_id['sessionID']}")
      request(:post, path, params)['data']['handle']
    end

    def upload(updates)
      s_id = @session_id['sessionID']
      path = mount_path("document?sessionID=#{s_id}&updates=#{updates}")
      request(:post, path)
    end

    def download(download_url, filename, save_to)
      params = @session_id
      s_id = @session_id['sessionID']
      path =
        "https://#{@app}.attask-ondemand.com/#{download_url}&sessionID=#{s_id}"
      response = request(:get, path)
      save_file(filename, response)
    end

    private

    def mount_path(object_code, object_id = '')
      "#{@endpoint}/#{object_code}#{object_id}"
    end

    def session_id
      { 'sessionID' => login['data']['sessionID'] }
    end

    def login
      config = Config
      params = { username: config.username, password: config.password }
      path = mount_path('login', '')
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
