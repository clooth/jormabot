# encoding: utf-8
require 'cinch'
require 'mechanize'

class NoMProfile
  include Cinch::Plugin

  match /nom (\w+)/, method: :fetch_profile

  def fetch_profile(m, name)
    uri = "http://www.northernmaniacs.net/kayttaja/profiili/#{name}"

    agent = Mechanize.new
    begin
      page = agent.get(uri)
    rescue Mechanize::ResponseCodeError
      return
    end

    profile = {}
    if page.to_html.downcase.include? "ei löytynyt"
      m.reply "Käyttäjää nimeltä #{name} ei löytynyt."
    else
      profile_rows = page.search('.profile_details_row_data')
      profile_rows.each_with_index { |row, index|
        case index
        when 0
          profile[:first_name] = row.text
        when 1
          profile[:last_name] = row.text
        when 2
          profile[:gender] = row.text
        when 3
          profile[:city] = row.text
        when 4
          profile[:joined] = row.search('span').text
        when 5
          profile[:seen] = row.search('span').text
        when 6
          profile[:posts] = row.text
        when 7
          profile[:tag] = row.text
        end
      }

      m.reply "#{profile[:first_name]} #{profile[:last_name]} - #{profile[:gender]} - #{profile[:city]} - #{profile[:joined]} - #{profile[:seen]} - #{profile[:posts]} - #{profile[:tag]}"
    end
  end
end