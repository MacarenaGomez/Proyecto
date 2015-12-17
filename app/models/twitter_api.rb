class TwitterApi < ActiveRecord::Base

  SLICE_SIZE = 100
  
  attr_reader :topic, :expert_twitter

  @@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"] 
    config.access_token        = ENV["ACCESS_TOKEN"] 
    config.access_token_secret = ENV["ACCESS_TOKEN_SECRET"]
  end

  def self.twitter_timeline screen_name, keep_searching=true
    begin
      tweets = collect_with_max_id([], keep_searching) do |max_id|
        options = {count: 200, include_rts: true}
        options[:max_id] = max_id unless max_id.nil?

        @@client.user_timeline(screen_name, options)
      end
      tweets
    rescue Exception => e
      puts e
      puts("Errors: #{e.to_s}")
    end
  end

  def self.twitter_friends screen_name
    begin
      options = {skip_status: true, include_user_entities: true}
      friends = []
      @@client.friend_ids(screen_name,options).each_slice(SLICE_SIZE).with_index do |slice, i|
        @@client.users(slice).each do |f|
          friends.push(f)
        end
      end
      friends
    rescue  Exception => e
      puts e
      puts("Errors: #{e.to_s}")
    end
  end

  def self.collect_with_max_id(collection=[],continue=true, max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? || !continue ? collection.flatten : collect_with_max_id(collection,true, response.last.id - 1, &block)
  end
  
end
