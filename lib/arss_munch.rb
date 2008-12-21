require 'rubygems'
require 'simple-rss'
require 'open-uri'
require 'hpricot'
require 'activesupport'

#OVERALL CLASS FOR HOLDING THE FEEDS
class ArssMunch
  class CantBeArssedError < StandardError; end
  
  attr_accessor :arss_feeds 

  #main_url, rss_link_pattern, story_pattern, image_pattern, optional_clean_pattern  
  def initialize args
    
    if args[:main_url].blank? or args[:rss_link_pattern].blank? or args[:story_pattern].blank?
      throw CantBeArssedError
    end

    #GET ALL RSS LINKS AND CLEAN    
    rss_page = Hpricot(open(args[:main_url]))
    rss_links = rss_page.search(args[:rss_link_pattern])
    rss_links = rss_links.inject([]) { |links, element| links << element.attributes["href"] }
    (rss_links = rss_links.inject([]) { |links, link| link.include?(args[:optional_clean_pattern]) ? links : links << link }) unless args[:optional_clean_pattern].blank?
    
    #create array of feeds
    @arss_feeds = Array.new
    rss_links.each do |link|
      new_feed = ArssFeed.new(link, args[:story_pattern], args[:image_pattern])
      @arss_feeds << new_feed
    end
  end
  
end