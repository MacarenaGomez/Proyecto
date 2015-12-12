class TwitterApi < ActiveRecord::Base

  attr_reader :topic, :expert_twitter

  #Configuración
  @@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"] 
    config.access_token        = ENV["ACCESS_TOKEN"] 
    config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
  end

  def initialize screen_name, topic
    @screen_name = screen_name
    @topic = [topic,topic.upcase,topic.downcase,topic.capitalize]
    @tweets = []
  end

  def getExpertTweets
    getTimeline
    getTweetsByDate
    getTweetsByHashtag
    getMostRetweetedFavoritTweets
    @tweets
  end
  
  def getTimeline
    begin
      @tweets = collect_with_max_id do |max_id|
        options = {count: 200, include_rts: true}
        options[:max_id] = max_id unless max_id.nil?

        @@client.user_timeline(@screen_name, options)
      end
    rescue Exception => e
      puts e
      puts("Errors: #{e.to_s}")
    end
  end

  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end
  
  def getTweetsByHashtag
    @tweets = @tweets.select! do |item|
      @topic.any?{ |str| item.text.include?(str) } 
    end
  end

  def getTweetsByDate
    since = (Time.current - 1.year).strftime('%F') 
    @tweets = @tweets.select! do |item|
      item.created_at >= since
    end
  end

  def getMostRetweetedFavoritTweets
    @tweets.sort! do |t1,t2| 
      t2.retweet_count.to_i <=> t1.retweet_count.to_i
    end
  end

  # def getNameFriends(screen_name)
  #   begin
  #     @friends = Array.new
  #     @@client.friends(screen_name: screen_name).take(30).each do |friend|
  #       @friends.push({screen_name: friend.screen_name, name: friend.name, id: friend.id})
  #     end
  #     @friends
  #   rescue Exception => e
  #     puts e
  #     puts("Errors: #{e.to_s}")
  #   end
  # end

  # def getMostPopularTweets(hashtag,screen_name)
    
  #   begin
  #     @tweets = Array.new

  #     since_date = (Time.now - 1.year).strftime('%Y-%m-%d')
  #     until_date = Time.now.strftime('%Y-%m-%d')

  #     #jQuery jQuery #jQuery from:jeresig since:2015-07-10 until:2015-12-10 include:retweets
  #     to_search = transformHastag(hashtag) + " from:#{screen_name}"
    
  #     @@client.search("from:jeresig").each do |tweet|
  #        @tweets.push(tweet.to_h)
  #     end
  #     binding.pry
  #     @tweets
  #   rescue Exception => e
  #     puts e
  #     puts("Errors: #{e.to_s}")
  #   end
  
  # end  
end
