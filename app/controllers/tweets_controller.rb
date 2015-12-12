class TweetsController < ApplicationController

  def index
    # Devuelve un experto y su lista de tweets relevante
    # Buscamos primero en nuestra bd
    topic = Topic.find_by(name: params[:topic].downcase)
    expert = topic.experts[0]
    tweets = expert.tweets
    if tweets.size == 0 # || expert
      api = TwitterApi.new(expert.twitter, topic.name)
      tweets = api.getExpertTweets
      tweets.each do |elem|
        binding.pry
        #Tweet.create(text: elem.text, rate: 0, date: elem.created_at, link: elem.)
      end
    end
  
    render(status:200, json: {expert: expert, tweets: tweets})

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