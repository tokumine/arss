#SETUP BASIC VARS
overall_page_link = "http://www.economist.com/rss/"
overall_page = Hpricot(open(overall_page_link))
overall_pattern_for_rss = '.col-left li a[@href$=".xml"]'

#GET ALL RSS AND CLEAN
overall_rss_feeds = overall_page.search(overall_pattern_for_rss)
links = overall_rss_feeds.inject([]) { |rss_links, element| rss_links << element.attributes["href"] }
links = links.inject([]) { |array_in, link| link.include?("yahoo") ? array_in : array_in << link }

links.each do |link|

  rss = SimpleRSS.parse open(link)
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
end