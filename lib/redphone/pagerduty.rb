require File.join(File.dirname(__FILE__), 'helpers')

module Redphone
  class Pagerduty
    def initialize(options={})
      raise "You must supply a subdomain" if options[:subdomain].nil?
      raise "You must supply a user" if options[:user].nil?
      raise "You must supply a password" if options[:password].nil?
      @subdomain =  options[:subdomain]
      @user = options[:user]
      @password = options[:password]
      @service_key = options[:service_key]
    end

    def self.integration_api(request_body)
      response = http_request(
        :method => "post",
        :ssl => true,
        :uri => "https://events.pagerduty.com/generic/2010-04-15/create_event.json",
        :body => request_body.to_json
      )
      JSON.parse(response.body)
    end

    def self.trigger_incident(options={})
      raise "You must supply a service key" if options[:service_key].nil?
      raise "You must supply a description" if options[:description].nil?
      request_body = options.merge!({:event_type => "trigger"})
      integration_api(request_body)
    end

    def trigger_incident(options={})
      options[:service_key] = options[:service_key] || @service_key
      self.class.trigger_incident(options)
    end

    def self.resolve_incident(options={})
      raise "You must supply a service key" if options[:service_key].nil?
      raise "You must supply a incident key" if options[:incident_key].nil?
      request_body = options.merge!({:event_type => "resolve"})
      integration_api(request_body)
    end

    def resolve_incident(options={})
      options[:service_key] = options[:service_key] || @service_key
      self.class.resolve_incident(options)
    end

    def incidents(options={})
      response = http_request(
        :user => @user,
        :password => @password,
        :ssl => true,
        :uri => "https://#{@subdomain}.pagerduty.com/api/v1/incidents",
        :parameters => options
      )
      JSON.parse(response.body)
    end
  end
end
