require 'csv'
class TwitterApi < ActiveRecord::Base

  SLICE_SIZE = 100
  
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
    @friends = []
  end

  def getExpertTweets 
    tweets = getTimeline(@screen_name,true)
    tweets = getTweetsByHashtag(tweets)
    tweets = getTweetsByDate(tweets)
    tweets = getMostRetweetedFavoritTweets(tweets)
    tweets[0..4]
  end

  def getBestFriends
    getFriends
    orderByFollowers
    filterByTopic
    @friends[0..4]
  end
  
  def getTimeline screen_name, keep_searching=true
    begin
      tweets = collect_with_max_id([], keep_searching) do |max_id|
        options = {count: 200, include_rts: true}
        options[:max_id] = max_id unless max_id.nil?

        @@client.user_timeline(screen_name, options)
      end
    rescue Exception => e
      puts e
      puts("Errors: #{e.to_s}")
    end
  end

  def collect_with_max_id(collection=[],continue=true, max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? || !continue ? collection.flatten : collect_with_max_id(collection,true, response.last.id - 1, &block)
  end
  
  def getTweetsByHashtag tweets
    tweets.select! do |item|
      @topic.any? {|str| item.text.include?(str)} 
    end
    tweets
  end

  def getTweetsByDate tweets
    since = (Time.current - 1.year).strftime('%F') 
    tweets.select! do |item|
      item.created_at >= since
    end
    tweets
  end

  def getMostRetweetedFavoritTweets tweets
    tweets.sort! do |t1,t2| 
      t2.retweet_count <=> t1.retweet_count
    end
    tweets
  end

  def getFriends
    begin
      options = {skip_status: true, include_user_entities: true}
      @@client.friend_ids(@screen_name,options).each_slice(SLICE_SIZE).with_index do |slice, i|
        @@client.users(slice).each do |f|
          @friends.push(f)
        end
      end
      @friends
    rescue  Exception => e
      puts e
      puts("Errors: #{e.to_s}")
    # rescue Twitter::Error::TooManyRequests => error
    #   sleep error.rate_limit.reset_in + 1
    #   retry
    end
  end

  def orderByFollowers
    @friends.sort! do |f1,f2| 
      f2.followers_count <=> f1.followers_count
    end
    @friends[0..99]
  end

  def filterByTopic
    begin
      
      @friends.each do |friend|
    
        tweets = getTimeline(friend.screen_name,false)
        tweets = getTweetsByHashtag(tweets)
        if tweets.size > 0
          # tweets = getTimeline(friend.screen_name)
          # tweets = getTweetsByHashtag(tweets)
          # tweets = getTweetsByDate(tweets)
          # tweets = getMostRetweetedFavoritTweets(tweets)
          @friends << friend
        end
      end
    rescue  Exception => e
      puts e
      puts("Errors: #{e.to_s}")
    end  
  end
end
