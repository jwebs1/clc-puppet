require 'puppetlabs_spec_helper/module_spec_helper'
require 'vcr'
require 'webmock/rspec'

WebMock.disable_net_connect!

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data("<USERNAME>") do
    ENV['CLC_USERNAME']
  end
  c.filter_sensitive_data("<PASSWORD>") do
    ENV['CLC_PASSWORD']
  end
  c.filter_sensitive_data('<AUTH_TOKEN>') do |interaction|
    if interaction.response.body != ''
      body = JSON.parse(interaction.response.body)
      body['bearerToken'] if body.is_a?(Hash) && body.has_key?('bearerToken')
    end
  end
  c.filter_sensitive_data('<AUTH_TOKEN>') do |interaction|
    auth_header = interaction.request.headers['Authorization']
    auth_header.first if auth_header
  end
end

ENV['CLC_USERNAME'] = 'redacted'
ENV['CLC_PASSWORD'] = 'redacted'
