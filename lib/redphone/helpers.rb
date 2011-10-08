require "rubygems" if RUBY_VERSION < "1.9.0"
require "net/http"
require "uri"
require "json"
require "cgi"

def http_request(options={})
  raise "You must supply a URI" if options[:uri].nil?
  method = options[:method] || "get"
  uri = URI.parse(options[:uri])
  user = options[:user]
  password = options[:password]
  body = options[:body] || nil
  http = Net::HTTP.new(uri.host, uri.port)
  if options[:ssl] == true
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
  request = case method
  when "get"
    Net::HTTP::Get.new(uri.request_uri)
  when "post"
    Net::HTTP::Post.new(uri.request_uri)
  when "put"
    Net::HTTP::Put.new(uri.request_uri)
  when "delete"
    Net::HTTP::Delete.new(uri.request_uri)
  else
    raise "Unknown HTTP method: #{method}"
  end
  if user && password
    request.basic_auth user, password
  end
  request.body = body
  http.request(request)
end
