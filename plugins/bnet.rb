require 'cinch'
require 'mechanize'
require 'daybreak'
require 'json'

class BattleNet
  include Cinch::Plugin

  match /addbnet (\w+) (\w+)/, method: :add_profile
  match /bnet (\w+)/, method: :get_profile

  def initialize(*args)
    super(*args)

    @db = Daybreak::DB.new 'bnet.db'
  end

  def add_profile(m, name, id)
    fetch_profile(name, id)
  end

  def get_profile(m, name)

  end

  def fetch_profile(name, id)
    uri = "https://eu.api.battle.net/sc2/profile/#{id}/1/#{name}/?locale=en_GB&apikey=#{ENV['BNET_APP_KEY']}"

    agent = Mechanize.new
    begin
      page = agent.get(uri)
    rescue Mechanize::ResponseCodeError
      return
    end

    json = JSON.parse page.body
    puts json
  end

  def fetch_ladder(name, id)

  end
end