require File.join(File.dirname(__FILE__), 'helpers')

module Redphone
  class Pagerduty
    def initialize(options={})
      raise "You must supply a service key" if options[:service_key].nil?
      @service_key = options[:service_key]
    end

    def integration_api(request_body)
      response = http_request(
        :method => "post",
        :ssl => true,
        :uri => "https://events.pagerduty.com/generic/2010-04-15/create_event.json",
        :body => request_body.merge({:service_key => @service_key}).to_json
      )
      response.body
    end

    def trigger_incident(options={})
      raise "You must supply a description" if options[:description].nil?
      request_body = options.merge!({:event_type => "trigger"})
      integration_api(request_body)
    end

    def resolve_incident(options={})
      raise "You must supply a incident key" if options[:incident_key].nil?
      request_body = options.merge!({:event_type => "resolve"})
      integration_api(request_body)
    end

    def self.incidents(options={})
      raise "You must supply a subdomain" if options[:subdomain].nil?
      raise "You must supply a user" if options[:user].nil?
      raise "You must supply a password" if options[:password].nil?
      params_hash = options.reject { |key, value| [:subdomain, :user, :password].include?(key) }
      params = params_hash.map { |key, value| "#{key}=#{CGI.escape(value)}"}.join("&")
      response = http_request(
        :method => "get",
        :user => options[:user],
        :password => options[:password],
        :ssl => true,
        :uri => "https://#{options[:subdomain]}.pagerduty.com/api/v1/incidents?#{params}"
      )
      response.body
    end
  end
end
