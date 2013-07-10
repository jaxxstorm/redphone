require "rubygems" if RUBY_VERSION < "1.9.0"
require "net/http"
require "net/https"
require "uri"
require "json"
require "cgi"

def http_request(options={})
  raise "You must supply a URI" if options[:uri].nil?
  method = options[:method] || "get"
  uri = URI.parse(options[:uri])
  user = options[:user]
  password = options[:password]
  headers = options[:headers] || Hash.new
  parameters = options[:parameters] || Hash.new
  body = options[:body]
  http = Net::HTTP.new(uri.host, uri.port)
  if options[:ssl] == true
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  request_uri = uri.request_uri
  unless parameters.empty?
    request_uri += "?"
    request_uri += parameters.map { |key, value| "#{key}=#{CGI.escape(value.to_s)}" }.join("&")
  end
  request = case method
  when "get"
    Net::HTTP::Get.new(request_uri)
  when "post"
    Net::HTTP::Post.new(request_uri)
  when "put"
    Net::HTTP::Put.new(request_uri)
  when "delete"
    Net::HTTP::Delete.new(request_uri)
  when "patch"
    Net::HTTP::Patch.new(request_uri)
  else
    raise "Unknown HTTP method: #{method}"
  end
  headers.each do |header, value|
    request.add_field(header, value)
  end
  if user && password
    request.basic_auth user, password
  end
  request.body = body
  http.request(request)
end

def has_options(options={}, required=[])
  required.each do |option|
    raise "You must supply a #{option}" unless options.has_key?(option) && !options[option].nil?
  end
end
