class Search 
  
  attr_accessor :screen_name, :topic

  def initialize topic, screen_name
    @screen_name = screen_name
    @topic = topic
    @expert = ''
    @tweets = []
    @friends = []
  end

  def create_api
    @api = TwitterApi.new(@screen_name, @topic)
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
    @expert = Expert.create(name: name)
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

  def tweets_of
    @tweets = @api.getExpertTweets.each do |tweet|
      @expert.tweets << create_tweet(tweet)
    end
  end

  def friends_of
    
    @friends = @api.getBestFriends.each do |friend|
      binding.pry
     
      if expert_no_exits?(friend.name) 
        new_expert = create_expert friend.name
       binding.pry 
        topic.experts << new_expert
    binding.pry
        profile = create_profile friend
        new_expert.profiles << profile
    binding.pry
      end

    end

  end

  def expert_no_exits? name
    Expert.find_by(name: name).nil?
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
      @expert = Topic.find_by(name: @topic).experts.order('rate DESC').first
    rescue Exception => e
      @expert = nil
    end
  end

  def get_screen_name 
    @screen_name = @expert.profiles.where(profile_type: 'twitter')[0].screen_name
  end

  def get_expert_screen_name
    if (@screen_name != nil) 
          binding.pry
      @expert = Profile.find_by(screen_name: @screen_name).expert 
    else
      most_rated_expert
      get_screen_name
    end
  end

  def others
    others = []
    experts = Expert.where.not(name: @expert.name)
    experts.each do |expert|
      others << {expert: expert.name, screen_name:expert.profiles[0].screen_name, profile: expert.profiles[0],tweets: expert.tweets}
    end
    others
    binding.pry
  end

  def info_of topic 
  
    @topic = topic
    get_expert_screen_name
    
    if @expert.tweets.size == 0
      create_api
      tweets_of
      friends_of
    end

    binding.pry

    json = {expert: @expert.name,
            screen_name: @expert.profiles[0].screen_name,
            profile: @expert.profiles[0], 
            tweets: @expert.tweets,
            others: others}
  end
end
