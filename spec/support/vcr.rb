require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr"
  c.filter_sensitive_data("<auth-token>") do |interaction|
    Rails.application.credentials.open_weather[:api_key]
  end
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
