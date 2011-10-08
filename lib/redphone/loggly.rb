require File.join(File.dirname(__FILE__), 'helpers')

module Redphone
  class Loggly
    def initialize(options={})
      raise "You must supply a subdomain" if options[:subdomain].nil?
      raise "You must supply a user" if options[:user].nil?
      raise "You must supply a password" if options[:password].nil?
      @subdomain =  options[:subdomain]
      @user = options[:user]
      @password = options[:password]
    end

    def search(options={})
      raise "You must supply a query string" if options[:q].nil?
      params = options.map { |key, value| "#{key}=#{CGI.escape(value)}" }.join("&")
      response = http_request(
        :user => @user,
        :password => @password,
        :ssl => true,
        :uri => "https://#{@subdomain}.loggly.com/api/search?#{params}"
      )
      JSON.parse(response.body)
    end
  end
end
