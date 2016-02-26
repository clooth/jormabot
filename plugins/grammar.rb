# encoding: utf-8
require 'cinch'

class Grammar
  include Cinch::Plugin

  listen_to :channel

  match /korjaa (\w+) (\w+)/, method: :add_correction
  match /unohda (\w+)/, method: :del_correction

  def initialize(*args)
    super

    @db = Daybreak::DB.new 'corrections.db'
  end

  def add_correction(m, invalid, valid)
    @db.set! invalid, valid
    m.reply "ok vaikka sit"
  end

  def add_correction(m, invalid, valid)
    @db.delete! invalid, valid
    m.reply "*plop*"
  end

  def listen(m)
    @db.each do |invalid, valid|
      if m.message.downcase.include? invalid.downcase
        m.reply "se on #{valid}"
      end
    end
  end

  def on_disconnect(m)
    @db.close
  end
end