# encoding: utf-8
require 'cinch'
require 'mechanize'
require 'shrinker'

class NoMNews
  include Cinch::Plugin

  match /nomnews/, method: :fetch_news

  def fetch_news(m)
    uri = "http://www.northernmaniacs.net/uutiset"

    agent = Mechanize.new
    begin
      page = agent.get(uri)
    rescue Mechanize::ResponseCodeError
      return
    end

    news_result = []
    3.times do |n|
      news_element = page.search('.basic_table_title')[n]
      news_title_el = news_element.search('a')[0]
      news_date_el = news_element.search('span')[0]
      news_link_url = news_title_el.attr('href')
      news_link_url_short = Shrinker.shrink(news_link_url)

      news_result << "#{news_date_el.text} - #{news_title_el.text} - #{news_link_url_short}"
    end

    m.reply news_result.join(" | ")
  end
end