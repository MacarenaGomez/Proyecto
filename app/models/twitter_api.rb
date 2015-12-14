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
    @friends = []
  end

  def getExpertTweets 
    getTimeline
    getTweetsByDate
    getTweetsByHashtag
    getMostRetweetedFavoritTweets
    @tweets = @tweets[0..10]
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

  def getBestFriends
    begin
      @@client.friends(@screen_name).each do |friend|
        @friends.push(friend)
      end
      @friends
    rescue Exception => e
      puts e
      puts("Errors: #{e.to_s}")
    end
  end

  def orderByFollowers
    @friends = @friends.sort!{|f1,f2| f2.followers_count <=> f1.followers_count}
  end

end
