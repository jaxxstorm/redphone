$: << File.dirname(__FILE__) + '/../lib' unless $:.include?(File.dirname(__FILE__) + '/../lib/')
require 'rubygems' if RUBY_VERSION < '1.9.0'
gem 'minitest'
require 'minitest/autorun'
require 'redphone/statuspage'

STATUSPAGE_PAGE_ID = "YOURPAGEID"
STATUSPAGE_API_KEY = "YOURAPIKEY"

class TestRedphoneStatuspage < MiniTest::Unit::TestCase
  def setup
  	@statuspage = Redphone::Statuspage.new(
      :page_id => STATUSPAGE_PAGE_ID,
      :api_key => STATUSPAGE_API_KEY
    )
  end

  def test_create_realtime_incident
    response = @statuspage.create_realtime_incident(
      :name => "testing",
      :status => "identified",
      :wants_twitter_update => "f",
      :message => "testing message"
    )
    assert_equal 'identified', response['status']
  end

  def test_create_scheduled_incident
    response = @statuspage.create_scheduled_incident(
      :name => "testing scheduled",
      :status => "scheduled",
      :scheduled_for => "2014-04-22T01:00:00Z",
      :scheduled_until => "3000-04-22T03:00:00Z",
      :wants_twitter_update => "f",
      :messsage => "testing message"
    )
    assert_equal 'scheduled', response['status']
  end

  def test_create_historical_incident
    response = @statuspage.create_historical_incident(
      :name => "testing historical",
      :message => "testing message",
      :backfilled => "t",
      :backfill_date => "2013-04-01"
    )
    assert_equal 'resolved', response['status']
  end

  def test_update_incident
    response = @statuspage.create_realtime_incident(
      :name => "testing",
      :status => "identified",
      :wants_twitter_update => "f",
      :message => "testing message"
    )
    incident_id = response["id"]
    response = @statuspage.update_incident(
      :name => "testing",
      :status => "resolved",
      :wants_twitter_update => "f",
      :incident_id => incident_id
    )
    assert_equal 'resolved', response['status']
  end

  def test_delete_incident
    response = @statuspage.create_realtime_incident(
      :name => "this incident will be removed.",
      :status => "investigating",
      :wants_twitter_update => "f",
      :message => "testing message"
    )
    incident_status = response["status"]
    incident_id = response["id"]
    response = @statuspage.delete_incident(
      :incident_id => incident_id
    )
    assert_equal incident_status, response['status']
  end

  def test_tune_update_incident
    response = @statuspage.create_realtime_incident(
      :name => "this incident will be updated",
      :status => "investigating",
      :wants_twitter_update => "f",
      :message => "testing message"
    )
    incident_id = response["id"]
    response = @statuspage.update_incident(
      :name => "this update will be tuned later",
      :status => "resolved",
      :wants_twitter_update => "f",
      :incident_id => incident_id
    )
    incident_update_id = response["incident_updates"].first["id"]
    response = @statuspage.tune_incident_update(
      :incident_id => incident_id,
      :incident_update_id => incident_update_id,
      :body => "updated incident new body",
    )
    assert_equal 'updated incident new body', response['body']
  end
end