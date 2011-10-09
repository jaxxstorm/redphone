require File.join(File.dirname(__FILE__), 'helpers')

module Redphone
  class Pingdom
    def initialize(options={})
      [:user, :password].each do |option|
        raise "You must supply a #{option}" if options[option].nil?
      end
      @request_options = {
        :user => options[:user],
        :password => options[:password],
        :ssl => true,
        :headers => {"App-Key" => "ksectgskhysnv4wb7h0z5re2wmeqqxnd"}
      }
    end

    def create_check(options={})
      [:name, :host, :type].each do |option|
        raise "You must supply a check #{option}" if options[option].nil?
      end
      response = http_request(
        @request_options.merge({
          :method => "post",
          :uri => "https://api.pingdom.com/api/2.0/checks",
          :parameters => options
        })
      )
      JSON.parse(response.body)
    end

    def checks
      response = response = http_request(
        @request_options.merge({
          :uri => "https://api.pingdom.com/api/2.0/checks"
        })
      )
      JSON.parse(response.body)
    end

    def actions(options={})
      response = http_request(
        @request_options.merge({
          :uri => "https://api.pingdom.com/api/2.0/actions",
          :parameters => options
        })
      )
      JSON.parse(response.body)
    end

    def results(options={})
      raise "You must supply a check id" if options[:id].nil?
      response = http_request(
        @request_options.merge({
          :uri => "https://api.pingdom.com/api/2.0/results/#{options[:id]}",
          :parameters => options.reject { |key, value| key == :id }
        })
      )
      JSON.parse(response.body)
    end

    def delete_check(options={})
      raise "You must supply a check id" if options[:id].nil?
      response = http_request(
        @request_options.merge({
          :method => "delete",
          :uri => "https://api.pingdom.com/api/2.0/checks/#{options[:id]}"
        })
      )
      JSON.parse(response.body)
    end
  end
end
