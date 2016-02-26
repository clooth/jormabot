# encoding: utf-8
require 'cinch'
require 'daybreak'
require './plugins/grammar.rb'
require './plugins/raceop.rb'
require './plugins/joinpart.rb'
require './plugins/markov.rb'
require './plugins/nomnews.rb'
require './plugins/nomprofile.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.quakenet.org'
    c.channels = ['#jormabot']
    c.nick = 'jormabot'
    c.verbose = true
    c.plugins.plugins = [Grammar, RaceOP, JoinPart, Markov, NoMNews, NoMProfile]
  end
end

bot.start