# encoding: utf-8
# frozen_string_literal: true

require 'addressable/uri'
require 'faraday'
require 'json'
require 'oj'
require 'patron'

require 'attask/client'
require 'attask/config'
require 'attask/errors'
require 'attask/request'
require 'attask/version'

require 'attask/errors/attask_error'

# lib/attask.rb
module Attask
  def self.configure
    yield Config
  end
end
