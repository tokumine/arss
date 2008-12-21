Arss - Economist Full RSS generator 
===================================

Introduction
-------------

The economist website content is fully accessible, but the feeds they provide are still the crappy sort. 

Arss parses the entire RSS page from the economist, scrapes the links then scrapes the relevant content from the site.

Usage
-------

<code>
arss_munch = ArssMunch.new  :main_url => "http://www.economist.com/rss/",
                            :rss_link_pattern => '.col-left li a[@href$=".xml"]',
                            :story_pattern => ".col-left p:not([@class])",
                            :image_pattern => '.col-left div img[@src^="http://media.economist.com/images"]',
                            :optional_clean_pattern => "yahoo"

arss_munch.arss_feeds.first.name # => "Title of the first RSS feed"

arss_munch.arss_feeds.each do |feed|
	feed.suck_arss_feed
end

arss_munch.arss_feeds.first.stories.first.name # => "Name of the first story"
arss_munch.arss_feeds.first.stories.first.published_date # => Date object
arss_munch.arss_feeds.first.stories.first.text # => "Body text of the article"
</code>


Prerequisites
--------------

* simple-rss
* open-uri
* hpricot
* activesupport
