#EACH FEED IN THE PAGE IS A COLLECTION OF STORIES
class ArssFeed

  attr_accessor :name, :url, :last_fetched, :stories

  def initialize feed_url, story_pattern, image_pattern
    @story_pattern = story_pattern
    @image_pattern = image_pattern
    @rss = SimpleRSS.parse open(feed_url)
    @name = @rss.channel.title
    @stories = Array.new
  end

  #SCRAPE ACTUAL SITE AND POPULATE STORY OBJECTS
  def suck_arss_feed 
    
    @last_fetched = Time.now
    
    #EACH ARTICLE
    @rss.items.each do |item|
      begin
        story_page = Hpricot(open(item.link))
      rescue Timeout::Error => e
        puts "#{e} timeout on #{item.link}"
      end
      story_elements = story_page.search(@story_pattern)
      image_elements = story_page.search(@image_pattern)
      
      #CREATE STORY 
      story = ArssStory.new      
      story.title = item.title
      story.published_date = item.pubDate.to_date
      body_text = ""
      
      image_elements.each do |image|
        body_text << image.to_html
      end

      story_elements.each do |element|
        body_text << element.to_html
      end
      story.text = body_text
      
      #SAVE STORY
      @stories << story
    end
  end
end