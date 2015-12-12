require 'rails_helper'

RSpec.describe "f5App", type: :request do

  describe "GET /f5App/tweets/:topic", type: :request do
    before { @topic = Topic.create name: 'jquery' }

    it "returns a proper tweet" do
      get tweet_path(@topic, format: :json)
      data = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      #El cuerpo del mensaje tiene la palabra jquery
      #Falta esto!
      #expect(data['name']).to eq(@movie.title)
    end
  end
end