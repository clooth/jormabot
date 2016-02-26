# encoding: utf-8
require 'cinch'

class RaceOP
  include Cinch::Plugin

  listen_to :channel

  def listen(m)
    races = ['protoss', 'terran', 'zerg']
    races.each do |race|
      if m.message.include? race and rand(0.0...1.0) > 0.8
        m.reply "#{race} op"
        break
      end
    end
  end
end