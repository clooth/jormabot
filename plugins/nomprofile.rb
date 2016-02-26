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
    unless page.at_css('.profile_details_row_data')
      m.reply "Käyttäjää nimeltä #{name} ei löytynyt."
    else
      profile_rows = page.search('.profile_details_row_data')
      profile_rows.each_with_index { |row, index|
        case index
        when 0
          profile[:first_name] = row.text.strip
        when 1
          profile[:last_name] = row.text.strip
        when 2
          profile[:gender] = row.text.strip
        when 3
          profile[:city] = row.text.strip
        when 4
          profile[:joined] = row.search('span').text.strip
        when 5
          profile[:seen] = row.search('span').text.strip
        when 6
          profile[:posts] = row.text.strip
        when 7
          profile[:tag] = row.text.strip
        end
      }

      m.reply "#{profile[:first_name]} #{profile[:last_name]}, #{profile[:gender]} - Paikkakunta: #{profile[:city]} - Liittyi #{profile[:joined]} - Nähty #{profile[:seen]} - #{profile[:posts]} viestiä - BNet: #{profile[:tag]}"
    end
  end
end