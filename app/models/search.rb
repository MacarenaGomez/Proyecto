class Search 
  
  attr_accessor :screen_name, :topic

  def initialize topic, screen_name, second_round
    @screen_name = screen_name
    @topic = topic
    @expert = ''
    @tweets = []
    @friends = []
    @second_round = second_round
  end

  def create_tweet tweet
    new_tweet = Tweet.create(text: tweet.text, rate: 0, date: tweet.created_at, 
                             tweet_type: tweet.to_h.has_key?('retweeted_status') ? 'RT' : 'TW' ,
                             friend_id: tweet.to_h.has_key?('retweeted_status') ? tweet.retweeted_status.id : 0)
  
    if !(tweet.to_h[:entities].nil?)
      entities = tweet.to_h[:entities]
      add_resources(entities[:urls],new_tweet)
      add_resources(entities[:media],new_tweet)
    end
    new_tweet
  end

  def create_expert name
    e = Expert.create(name: name, rate: 0)
  end

  def create_profile friend
    p = Profile.create(url: friend.url, profile_image_url: friend.profile_image_url,
                       location: friend.location, description: friend.description, 
                       profile_type:'twitter', screen_name: friend.screen_name)
  end

  def create_resource resource
    source_type = resource.has_key?(:type) ? resource[:type] : 'link'
    source = resource.has_key?(:expanded_url) ? resource[:expanded_url] : resource[:media_url]

    r = Resource.create(source_type: source_type, source: source)
  end

  def tweets_by_hashtag tweets
    topic = [@topic.name,@topic.name.upcase,@topic.name.downcase,@topic.name.capitalize]
    tweets.select! do |item|
      topic.any? {|str| item.text.include?(str)} 
    end
    tweets
  end

  def tweets_by_date tweets
    since = (Time.current - 1.year).strftime('%F') 
    tweets.select! do |item|
      item.created_at >= since
    end
    tweets
  end

  def most_retweeted_favorit_tweets tweets
    tweets.sort! do |t1,t2| 
      t2.retweet_count <=> t1.retweet_count
    end
    tweets
  end

  def tweets_of name, keep_tracking
    tweets = TwitterApi.twitter_timeline(@screen_name, keep_tracking)

    tweets = filter_tweets(tweets)
    expert = Expert.find_by(name: name)
   
    tweets.each do |tweet|
      expert.tweets << create_tweet(tweet)
    end

    tweets
    puts "Tweets loaded..."
  end

  def filter_tweets tweets
    tweets_by_hashtag(tweets)
    tweets_by_date(tweets)
    most_retweeted_favorit_tweets(tweets)
    tweets[0..4]
  end

  def friends_of
    @friends = TwitterApi.twitter_friends(@screen_name)

    order_by_followers
    
    @friends[0..24].each do |friend|
      if expert_no_exits?(friend.name) 
        
        new_expert = create_expert(friend.name)
        new_expert.profiles << create_profile(friend)
      
        @topic.experts << new_expert
      end
      @topic.experts.each do |ex|
        if (ex.name != @expert.name)
          @screen_name = ex.profiles.find_by(profile_type: 'twitter').screen_name
          tweets = tweets_of(ex.name,true)
        end  
      end
    end

    delete_experts

    puts "Friends loaded..."
  end

  def delete_experts
    experts = @topic.experts.select do |expert| 
      binding.pry
      expert.tweets.size != 0
      binding.pry
    end
    binding.pry
    @topic.experts = experts
  end

  def expert_no_exits? name
    Expert.find_by(name: name).nil?
  end

  def order_by_followers 
    @friends.sort! do |f1,f2| 
      f2.followers_count <=> f1.followers_count
    end
    @friends[0..24]
  end

  def add_resources collection, tweet
    if !collection.nil?
      collection.each do |elem|
        tweet.resources << (create_resource elem) 
      end
    end
  end

  def most_rated_expert 
    begin
      @expert = Topic.find_by(name: @topic.name).experts.order('rate DESC').first
    rescue Exception => e
      @expert = nil
    end
  end

  def get_screen_name 
    @screen_name = @expert.profiles.where(profile_type: 'twitter')[0].screen_name
  end

  def get_expert_screen_name
    if (@screen_name != nil) 
      @expert = Profile.find_by(screen_name: @screen_name).expert 
    else
      most_rated_expert
      get_screen_name
    end
  end

  def others
    others_experts = []
    Expert.where.not(name: @expert.name).each do |expert|
      others_experts << {expert: expert.name, screen_name:expert.profiles[0].screen_name, profile: expert.profiles[0],tweets: expert.tweets}
    end
    others_experts
  end

  def info_of  
  
    get_expert_screen_name

    if @expert.tweets.size == 0 
      puts "Searching for tweets..."
      tweets_of @expert.name, true
      
      if !@second_round
        puts "Searching for friends..."
        friends_of
      end

    end

    json = {expert: @expert.name,
            screen_name: @expert.profiles[0].screen_name,
            profile: @expert.profiles[0], 
            tweets: @expert.tweets,
            others: others}
  end

end
