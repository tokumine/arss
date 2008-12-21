require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'hpricot'
require 'activesupport'
Dir.glob(File.join(File.dirname(__FILE__), '../templates/*.rb')).each {|f| require f }

#SETUP BASIC VARS
rss = SimpleRSS.parse open('http://www.economist.com/rss/full_print_edition_rss.xml')
story_element_tags = ".col-left p:not([@class])"
story_image_tags = '.col-left div img[@src^="http://media.economist.com/images"]'

#OVERALL TITLING
puts rss.channel.title
puts rss.channel.link

#EACH ARTICLE
rss.items.each do |item|
  story_page = Hpricot(open(item.link))
  story_elements = story_page.search(story_element_tags)
  image_elements = story_page.search(story_image_tags)
    
  #OUTPUT
  puts "#{item.pubDate.to_date}: #{item.title}"
  
  image_elements.each do |image|
    puts image.to_html
  end
  
  story_elements.each do |element|
    puts element.to_html
  end
end
  