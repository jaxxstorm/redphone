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
      @input_key = options[:input_key]
      @input_type = options[:input_type]
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

    def facets(options={})
      raise "You must supply a query string" if options[:q].nil?
      facet_type = options[:facet_type] || "date"
      raise "Facet type must be date, ip, or input" if !%w[date ip input].include?(facet_type)
      params_hash = options.reject { |key, value| key == :facet_type }
      params = params_hash.map { |key, value| "#{key}=#{CGI.escape(value)}" }.join("&")
      response = http_request(
        :user => @user,
        :password => @password,
        :ssl => true,
        :uri => "https://#{@subdomain}.loggly.com/api/facets/#{facet_type}/?#{params}"
      )
      JSON.parse(response.body)
    end

    def self.send_event(options={})
      raise "You must supply a input key" if options[:input_key].nil?
      raise "You must supply an event hash" if options[:event].nil? || !options[:event].is_a?(Hash)
      content_type = options[:input_type] == "json" ? "application/json" : "text/plain"
      response = http_request(
        :method => "post",
        :ssl => true,
        :uri => "https://logs.loggly.com/inputs/#{options[:input_key]}",
        :headers => {"content-type" => content_type},
        :body => options[:event].to_json
      )
      JSON.parse(response.body)
    end

    def send_event(options={})
      options[:input_key] = options[:input_key] || @input_key
      options[:input_type] = options[:input_type] || @input_type
      self.class.send_event(options)
    end
  end
end
