$: << File.dirname(__FILE__) + '/../lib' unless $:.include?(File.dirname(__FILE__) + '/../lib/')
require 'rubygems' if RUBY_VERSION < '1.9.0'
gem 'minitest'
require 'minitest/autorun'
require 'redphone/pingdom'

credentials = File.open("pagerduty_credentials.txt", "rb").read.split("\n")
PINGDOM_USER, PINGDOM_PASSWORD = credentials.each { |row| row }

class TestRedphonePingdom < MiniTest::Unit::TestCase
  i_suck_and_my_tests_are_order_dependent!

  def setup
    @pingdom = Redphone::Pingdom.new(
      :user => PINGDOM_USER,
      :password => PINGDOM_PASSWORD
    )
  end

  def test_create_check
    response = @pingdom.create_check(
      :name => "redphone",
      :host => "www.amazon.ca",
      :type => "http"
    )
    @test_check_id = response['check']['id']
    assert_equal "redphone", response['check']['name']
  end

  def test_checks
    response = @pingdom.checks
    exists = false
    assert_block(message="assert_block failed.") do
      response['checks'].each do |check|
        exists = true if check['name'] == "redphone"
      end
      exists
    end
  end

  def test_actions
    response = @pingdom.actions(
      :from => Date.new(2011,10,01).to_time.to_i,
      :limit => 1
    )
    assert !response.has_key?("error")
  end

  def test_results
    response = @pingdom.results(
      :id => @test_check_id,
      :limit => 1
    )
    assert response['results'].count == 1
  end

  def test_delete_check
    response = @pingdom.delete_check(:id => @test_check_id)
    assert_equal "Deletion of check was successful!", response['message']
  end
end
