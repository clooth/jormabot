# encoding: utf-8
require 'marky_markov'
require 'cinch'

class Markov
  include Cinch::Plugin

  listen_to :channel
  timer 60, method: :save_dictionary

  def initialize(*args)
    super(*args)
    @markov = MarkyMarkov::Dictionary.new('markov')
  end

  def listen(m)
    if Regexp.new("^" + Regexp.escape(m.bot.nick + ":")) =~ m.message
      m.reply @markov.generate_n_sentences(1)
    elsif m.message.match /(https?:\/\/[^\s]+)/
      return
    else
      @markov.parse_string(m.message)
    end
  end

  def save_dictionary
    @markov.save_dictionary!
  end
end