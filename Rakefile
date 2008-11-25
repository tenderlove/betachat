require 'usb'
require 'rubygems'
require 'betabrite'
require 'rake'

require 'lib/chatter'

namespace :betabrite do
  desc "Clear memory"
  task :clear_memory do
    BetaBrite::USB.new.clear_memory!
  end
  
  desc "Allocate memory"
  task :allocate do
    bb = BetaBrite::USB.new do |sign|
      sign.allocate do |memory|
        memory.text('A', 4096)
        memory.string('0', 1024)
        memory.string('1', 1024)
        memory.string('2', 1024)
      end
    end
    bb.write_memory!
  end

  desc 'Initialize text file'
  task :initialize do
    bb = BetaBrite::USB.new do |sign|
      sign.textfile do
        print stringfile('0')
      end
    end
    bb.write!
  end

  desc "Write string"
  task :write do
    bb = BetaBrite::USB.new do |sign|
      sign.stringfile('0') do
        print string('hello').red
      end
    end
    bb.write!
  end

  desc "Restart sign"
  task :restart => [:clear_memory, :allocate, :initialize]

  task :im do
    Thread.abort_on_exception = true
    client = Chatter::Chat.new(
      'betabrite@jabber.org/ruby',
      ENV['PASSWORD'],
      [Chatter::Sink.new]
    )
    client.login
    Thread.stop
    client.close
  end
end
