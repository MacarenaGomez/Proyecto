require "rails_helper"

RSpec.describe TopicsController, type: :routing do
  describe "routing" do

    it "routes to #home" do
      expect(:get => "/").to route_to("site#home")
    end

    it "routes to #show" do
      expect(:get => "/f5App/tweets/jquery").to route_to("tweets#index", :topic => "jquery")
    end
    
  end
end