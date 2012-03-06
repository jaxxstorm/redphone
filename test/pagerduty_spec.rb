$: << File.dirname(__FILE__) + '/../lib' unless $:.include?(File.dirname(__FILE__) + '/../lib/')

require 'rubygems' if RUBY_VERSION < '1.9.0'
gem 'minitest'

require 'yaml'
require 'minitest/spec'
require 'minitest/autorun'
require 'redphone/pagerduty'

describe Redphone::Pagerduty do
  
  before do
    @pagerduty_config = YAML.load_file("./test/pagerduty_test.yml")

    @pagerduty = Redphone::Pagerduty.new(
      :service_key => @pagerduty_config [:service_key],
      :subdomain => @pagerduty_config [:subdomain],
      :user => @pagerduty_config [:user],
      :password => @pagerduty_config [:password]
      )
  end
  
  describe "handle incidents" do
    it "should trigger incident" do
      response = @pagerduty.trigger_incident(
        :service_key => @pagerduty_config [:service_key],
        :description => "Testing pageduty Rubygem",
        :incident_key => "pagerduty/test"
      )
      response['status'].must_equal('success')
    end
    
    it "should acknowledge incident" do
      response = @pagerduty.acknowledge_incident(:incident_key => "pagerduty/test")
      response['status'].must_equal('success')
    end
    
    it "should resolve incident" do
      response = @pagerduty.resolve_incident(
        :service_key => @pagerduty_config [:service_key],
        :incident_key => "pagerduty/test"
      )
      response['status'].must_equal('success')		
    end
  end
    
  describe "incidents count" do
    it "should have count greater than 0" do
      response = @pagerduty.incidents_count(:incident_key => "qa_verify/test")
      response['total'].must_be :>, 0
    end
  end
  
  # this test needs more work, too specific to our usage
  describe "schedules" do
    it "should list schedules" do
      response = @pagerduty.schedules(:schedule_id => "PZA6CXC", :since => "2012-01-01", :until => "2012-03-06")
      response['total'].must_be :>, 0
    end
  end
end