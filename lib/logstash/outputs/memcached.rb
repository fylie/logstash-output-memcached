# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"


class LogStash::Outputs::Memcached < LogStash::Outputs::Base

  # memcached {
  #    {
  #     host => "localhost"
  #     port => 11211
  #     key => "memcache_key"
  #     value => "%{my_field}"
  #   }
  # }
  #
  config_name "memcached"

  # Memcached host
  config :host, :validate => :string, :default => "localhost", :required => true

  # Memcached port
  config :port, :validate => :number, :default => 11211, :required => true

  # Memcached key
  config :key, :validate => :string, :required => true

  # The value to be stored. If there is no value, this defaults to the event as
  # JSON.
  config :value, :validate => :string, :default => ""

  # TTL (how long to store the key in seconds)
  config :ttl, :validate => :number, :default => 0


  public
  def register
    require 'dalli'
    require 'json'
    options = {:expires_in => @ttl}
    @memcached = Dalli::Client.new("#{@host}:#{@port}", options)
  end # def register

  public
  def receive(event)
    key = event.sprintf(@key)
    if @value.empty?
      @memcached.set(key, event.to_json)
    else
      value = event.sprintf(@value)
      @memcached.set(key, value)
    end
  end
end # class LogStash::Outputs::Memcached
