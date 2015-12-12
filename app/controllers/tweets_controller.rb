class TweetsController < ApplicationController

  def index
    topic = Topic.find_by(name: params[:topic])
    
    if topic.experts.empty?
   
      render(status:400, json: {error: 'Error'})
   
    elsif topic.experts[0].tweets.size == 0
      expert = topic.experts[0]
      #Buscamos twitter...
      screen_name = expert.profiles.where(profile_types: 'twitter')[0].screen_name
      api = TwitterApi.new(screen_name, topic.name)
      tweets = api.getExpertTweets
      tweets.each do |elem|
        new_tweet = Tweet.create(text: elem.text, rate: 0, date: elem.created_at)
      
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
    
    expert = topic.experts[0] #Cogemos el primero por ahora
    tweets = expert.tweets

    render(status:200, json: {expert: expert.name,
                              profile: expert.profiles[0], 
                              tweets: tweets})

  end
end

private 
  def addResources(cosas, tweet)
   if (cosas.size != 0)
      cosas.each do |elem|
        source_type = elem.has_key?(:type) ? elem[:type] : 'link'
        source = elem.has_key?(:expanded_url) ? elem[:expanded_url] : elem[:media_url]
        r = Resource.create(source_type: source_type, source: source)
      
        tweet.resources << r 
      end
    end
  end
=begin
  
def show
    topic = Topic.find_by(name: params[:topic])
    master_twitter = topic.masters[0].twitter
 
    #Buscamos los friends
    friends = TwitterApi.getNameFriends(master_twitter)

    unless friends 
      render json:{error: "Master not found"}, status: 404
      return
      #Dónde lo busco ahora????
    end 
    render(status:200, json: friends)
  end

  def tweets 

    tweets = TwitterApi.getMostPopularTweets("jquery",params[:master])
    unless tweets 
      render json:{error: "Tweets not found"}, status: 404
      return
      #Dónde lo busco ahora????
    end 
    render(status:200, json: tweets)
  end

=end