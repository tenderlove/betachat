require 'rubygems'
require 'xmpp4r'
require 'xmpp4r/roster'


module Chatter
  class Sink
    def post_connect client
      client.send(Jabber::Presence.new.set_status("XMPP4R at #{Time.now.utc}"))
    end

    def message client, m
      return unless m.body
      bb = BetaBrite::USB.new do |sign|
        sign.stringfile('0') do
          print string(m.body).red
        end
      end
      bb.write!
    end
  end

  class Chat
    attr_accessor :listeners

    def initialize username, password, listeners = []
      @username = username
      @password = password
      @listeners = listeners
      @client = @mainthread = nil
    end

    def login
      jid = Jabber::JID.new(@username)
      @client = Jabber::Client.new(jid)
      @client.connect
      @client.auth(@password)
      listeners.each { |sink| sink.post_connect(@client) }
      @client.add_message_callback { |m|
        listeners.each { |sink| sink.message(@client, m) }
      }

      roster   = Jabber::Roster::Helper.new(@client)
      roster.add_subscription_request_callback do |item, pres|
        puts "ACCEPTING AUTHORIZATION REQUEST FROM: " + pres.from.to_s
        roster.accept_subscription(pres.from)
      end
    end

    def close
      @client.close
    end
  end
end
