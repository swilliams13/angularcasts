require 'rss'
require 'open-uri'

class ScreencastImporter
  def self.import_railscasts

    # because the Railscasts feed is targeted at itunes, there is additional metadata that
    # is not collected by Feedzirra by default. By using add_common_feed_entry_element,
    # we can let Feedzirra know how to map those values. See more information at
    # http://www.ruby-doc.org/gems/docs/f/feedzirra-0.1.2/Feedzirra/Feed.html
    #Feedzirra::Feed.add_common_feed_entry_element(:enclosure, :value => :url, :as => :video_url)
    #Feedzirra::Feed.add_common_feed_entry_element('itunes:duration', :as => :duration)

    # Capture the feed and iterate over each entry
    #feed = Feedzirra::Feed.fetch_and_parse("http://feeds.feedburner.com/railscasts")
    feed = RSS::Parser.parse open('http://feeds.feedburner.com/railscasts')
   
    feed.items.each do |item|

      # Strip out the episode number from the title
      title = item.title.gsub(/^#\d+\s/, '')
      duration = item.itunes_duration.value.to_s

      # Find or create the screencast data into our database
      Screencast.where(video_url: item.enclosure.url).first_or_create(
        title:        title,
        summary:      item.itunes_summary,
        duration:     duration,
        link:         item.link,
        published_at: item.pubDate,
        source:       'railscasts' # set this manually
      )
    end

    # Return the number of total screencasts for the source
    Screencast.where(source: 'railscasts').count
  end

end