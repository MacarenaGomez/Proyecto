namespace :f5App do

  desc "Searching experts for new topics and refresh tweets for experts"
  task search_topic: :environment do
    begin
      Topic.all.each do |topic|
        puts "Init: search_topic"
        Search.new(topic,'',false).info_of 
        puts "End: search_topic"
      end
    rescue Twitter::Error::TooManyRequests => error
      sleep error.rate_limit.reset_in + 1
      retry
    end
  end

end
