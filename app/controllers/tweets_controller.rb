class TweetsController < ApplicationController

  def index
    
    topic = Topic.find_by(name: params[:topic])
    screen_name = params[:screen_name]

    if topic.nil? || topic.experts.nil?
      Topic.create(name: params[:topic])
      render(status:424, json: {error: 'Vuelva más tarde!'})
    else
     json = Search.new(topic,screen_name,screen_name=="").info_of 
     render(status:200, json: json)
    end
  end

end