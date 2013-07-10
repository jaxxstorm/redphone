require File.join(File.dirname(__FILE__), 'helpers')

module Redphone
  class Statuspage
    def initialize(options={})
      has_options(options, [:api_key, :page_id])
      @page_id = options[:page_id]
      @request_options = {
        :ssl => true,
        :headers => {"Authorization" => "OAuth #{options[:api_key]}"}
      }
    end

    def convert_options(options={})
      incident_options = Hash.new
      options.each do |key, val|
        incident_options["incident[#{key}]"] = val
      end
      return incident_options
    end

    def check_incident_attributes(options={}, checked_options=[])
      checked_options.each do |option|
        raise "You must supply an incident #{option}." if options[option].nil?
      end
    end

    def create_realtime_incident(options={})
      check_incident_attributes(options, [:name, :wants_twitter_update])
      options = convert_options(options)
      response = http_request(
        @request_options.merge({
          :method => "post",
          :uri => "https://api.statuspage.io/v0/organizations/#{@page_id}/incidents.json",
          :parameters => options
        })
      )
      JSON.parse(response.body)
    end

    def create_scheduled_incident(options={})
      check_incident_attributes(options, [:name, :status, :wants_twitter_update, :scheduled_for, :scheduled_until])
      options = convert_options(options)
      response = http_request(
        @request_options.merge({
          :method => "post",
          :uri => "https://api.statuspage.io/v0/organizations/#{@page_id}/incidents.json",
          :parameters => options
        })
      )
      JSON.parse(response.body)
    end

    def create_historical_incident(options={})
      check_incident_attributes(options, [:name, :message, :backfilled, :backfill_date])
      options = convert_options(options)
      response = http_request(
        @request_options.merge({
          :method => "post",
          :uri => "https://api.statuspage.io/v0/organizations/#{@page_id}/incidents.json",
          :parameters => options
        })
      )
      JSON.parse(response.body)
    end

    def update_incident(options={})
      check_incident_attributes(options, [:name, :wants_twitter_update, :incident_id])
      incident_id = options[:incident_id]
      options.delete(:incident_id)
      options = convert_options(options)
      response = http_request(
        @request_options.merge({
          :method => "patch",
          :uri => "https://api.statuspage.io/v0/organizations/#{@page_id}/incidents/#{incident_id}.json",
          :parameters => options
        })
      )
      JSON.parse(response.body)
    end

    def delete_incident(options={})
      check_incident_attributes(options, [:incident_id])
      response = http_request(
        @request_options.merge({
          :method => "delete",
          :uri => "https://api.statuspage.io/v0/organizations/#{@page_id}/incidents/#{options[:incident_id]}.json"
        )}
      )
      JSON.parse(response.body)
    end
  
    def tune_incident_update(options={})
      check_incident_attributes(options, [:incident_id, :incident_update_id])
      parameter_options = Hash.new
      parameter_options["incident_update[body]"] = options[:body] unless options[:body].nil?
      parameter_options["incident_update[display_at]"] => options[:display_at] unless options[:display_at].nil?
      response = http_request(
        @request_options.merge({
          :method => "patch",
          :uri => "https://api.statuspage.io/v0/organizations/#{@page_id}/incidents/#{options[:incident_id]}/incident_updates/#{options[:incident_update_id]}.json"
          :parameters => parameter_options
        })
      )
      JSON.parse(response.body)
    end
  end
end