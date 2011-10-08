$: << File.dirname(__FILE__) + '/../lib' unless $:.include?(File.dirname(__FILE__) + '/../lib/')
require 'rubygems' if RUBY_VERSION < '1.9.0'
gem 'minitest'
require 'minitest/autorun'
require 'redphone/loggly'

LOGGLY_INPUT_KEY = File.open("loggly_input_key.txt", "rb").read.gsub("\n", "")
credentials = File.open("loggly_credentials.txt", "rb").read.split("\n")
LOGGLY_SUBDOMAIN, LOGGLY_USER, LOGGLY_PASSWORD = credentials.each { |row| row }

class TestRedphoneLoggly < MiniTest::Unit::TestCase
  i_suck_and_my_tests_are_order_dependent!

  def setup
    @loggly = Redphone::Loggly.new(
      #:input_key => LOGGLY_INPUT_KEY,
      :subdomain => LOGGLY_SUBDOMAIN,
      :user => LOGGLY_USER,
      :password => LOGGLY_PASSWORD
    )
  end

  def test_send_event
    response = @loggly.send_event(
      :input_key => LOGGLY_INPUT_KEY,
      :input_type => "json",
      :event => {
        :service => "redphone",
        :message => "test"
      }
    )
    assert_equal 'ok', response['response']
  end

  def test_search
    response = @loggly.search(:q => "json.service:redphone")
    assert response['numFound'] > 0
  end

  def test_facets
    response = @loggly.facets(:q => "json.service:redphone")
    assert response['numFound'] > 0
  end
end
