$: << File.dirname(__FILE__) + '/../lib' unless $:.include?(File.dirname(__FILE__) + '/../lib/')
require 'rubygems' if RUBY_VERSION < '1.9.0'
gem 'minitest'
require 'minitest/autorun'
require 'redphone/pagerduty'

SERVICE_KEY = File.open("pagerduty_service_key.txt", "rb").read.gsub("\n", "")
credentials = File.open("pagerduty_credentials.txt", "rb").read.split("\n")
SUBDOMAIN, USER, PASSWORD = credentials.each { |row| row }

class TestRedphonePagerduty < MiniTest::Unit::TestCase
  i_suck_and_my_tests_are_order_dependent!

  def setup
    @pagerduty = Redphone::Pagerduty.new(:service_key => SERVICE_KEY)
  end

  def test_trigger_incident
    trigger = @pagerduty.trigger_incident(:description => "Testing Redphone Rubygem.", :incident_key => "redphone/test")
    response = JSON.parse(trigger)
    assert_equal 'success', response['status']
  end

  def test_resolve_incident
    resolve = @pagerduty.resolve_incident(:incident_key => "redphone/test")
    response = JSON.parse(resolve)
    assert_equal 'success', response['status']
  end

  def test_incidents
    incidents = Redphone::Pagerduty.incidents(
      :subdomain => SUBDOMAIN,
      :user => USER,
      :password => PASSWORD,
      :incident_key => "redphone/test"
    )
    response = JSON.parse(incidents)
    assert response['total'] > 0
  end
end
