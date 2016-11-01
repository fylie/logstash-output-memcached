# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"

# An memcached output that does nothing.
class LogStash::Outputs::Memcached < LogStash::Outputs::Base
  config_name "memcached"

  public
  def register
  end # def register

  public
  def receive(event)
    return "Event received"
  end # def event
end # class LogStash::Outputs::Memcached
