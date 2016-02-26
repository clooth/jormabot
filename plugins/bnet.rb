require 'cinch'
require 'mechanize'
require 'daybreak'
require 'json'

class BattleNet
  include Cinch::Plugin

  match /addbnet (\w+) (\w+)/, method: :add_profile
  match /bnet (\w+)/, method: :get_profile
  match /bnetupdate (\w+)/, method: :update_profile

  def initialize(*args)
    super(*args)

    @db = Daybreak::DB.new 'bnet.db'
  end

  def add_profile(m, name, id)
    fetch_profile(name, id)
    fetch_ladder(name, id)

    add_response(m, name, id)
  end

  def add_response(m, name, id)
    if @db["#{name.downcase}-profile"]
      m.reply "Käyttäjä #{name} lisätty. Voit nyt hakea tilastosi kirjoittamalla !bnet #{name}"
    else
      m.reply "Käyttäjää #{name} ei löytynyt."
    end
  end

  def get_profile(m, name)
    get_response(m, name)
  end

  def get_response(m, name)
    user = @db["#{name.downcase}-profile"]
    debug user
    if user
      m.reply "#{user[:clanTag]} #{user[:displayName]} - Games this season: #{user[:season][:totalGamesThisSeason]}"
    else
      m.reply "Käyttäjää #{name} ei löytynyt."
    end
  end

  def update_profile(m, name)
    update_response(m, name)
  end

  def update_response(m, name)
    user = @db["#{name.downcase}-profile"]
    if user
      fetch_profile(user['id'], user['displayName'])
      fetch_ladder(user['id'], user['displayName'])
      m.reply "Käyttäjä #{name} päivitetty."
    else
      m.reply "Käyttäjää #{name} ei löytynyt."
    end
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
    @db.set!(name.downcase + '-profile', json)
  end

  def fetch_ladder(name, id)
    uri = "https://eu.api.battle.net/sc2/profile/#{id}/1/#{name}/?locale=en_GB&apikey=#{ENV['BNET_APP_KEY']}"

    agent = Mechanize.new
    begin
      page = agent.get(uri)
    rescue Mechanize::ResponseCodeError
      return
    end

    json = JSON.parse page.body
    @db.set!(name.downcase + '-ladder', json)
  end
end