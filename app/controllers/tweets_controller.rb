class TweetsController < ApplicationController

  def index
    
    topic = Topic.find_by(name: params[:topic])
    screen_name = params[:screen_name]

    if topic.nil? || topic.experts.nil?
      # y como lo rellenamos?!?!
      #render(status:418, json: {error: 'I'm a teapot!})
      render(status:424, json: {error: 'Vuelva más tarde!'})
    else
     json = Search.new(topic.name,screen_name).info_of topic.name
     render(status:200, json: json)
    end
  end
  
end

=begin
def getTweets screen_name, topic, expert
  
  api = TwitterApi.new(screen_name, topic)
  tweets = api.getExpertTweets
 
  tweets.each do |elem|
    new_tweet = Tweet.create(text: elem.text, rate: 0, date: elem.created_at, 
                             tweet_type:elem.to_h.has_key?('retweeted_status') ? 'RT' : 'TW' ,
                             friend_id: elem.to_h.has_key?('retweeted_status') ? elem.retweeted_status.id : 0)
  
    entities = elem.to_h[:entities]
    if (entities.has_key?(:urls))
      addResources(entities[:urls],new_tweet)
    end

    if (entities.has_key?(:media))
      addResources(entities[:media],new_tweet)
    end
    
    expert.tweets << new_tweet
  end

end

def getBestFriends screen_name, topic, expert
  
  api = TwitterApi.new(screen_name, topic.name)
  friends = api.getBestFriends
  friends.each do |friend|
    
    if expert_not_exits?(friend.name)
      new_expert = Expert.create(name: friend.name)
      topic.experts << new_expert

      profile = Profile.create(url: friend.url, profile_image_url: friend.profile_image_url,
                               location: friend.location, description: friend.description, 
                               profile_type:'twitter', screen_name: friend.screen_name)
      new_expert.profiles << profile
    end

  end
end

def expert_not_exits? name
  Expert.find_by(name: name).nil?
end

private 
  def addResources(collection, tweet)
   if (collection.size != 0)
      collection.each do |elem|
        source_type = elem.has_key?(:type) ? elem[:type] : 'link'
        source = elem.has_key?(:expanded_url) ? elem[:expanded_url] : elem[:media_url]
        r = Resource.create(source_type: source_type, source: source)
      
        tweet.resources << r 
      end
    end
  end
=end