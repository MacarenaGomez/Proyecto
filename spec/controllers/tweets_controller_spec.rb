require 'rails_helper'

RSpec.describe TweetsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Movie. As you add validations to Movie, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MoviesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  # describe "GET #index" do
  #   it "return tweets and expert from topic in json" do
  #     movie = Movie.create! valid_attributes
  #     get :index, {}, valid_session
  #     expect(assigns(:movies)).to eq([movie])
  #   end
  # end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "loads a expert" do
      expert = Expert.create!
      get :index

      expect(assigns(:experts)[0]).to match_array([expert])
    end
  end

  it "loads tweets" do
    tweet1, tweet2 = Tweet.new, Tweet.new
    get :index

    expect(assigns(:tweets)).to match_array([tweet1, tweet2])
  end

  # describe "GET #show" do
  #   it "assigns the requested movie as @movie" do
  #     movie = Movie.create! valid_attributes
  #     get :show, {:id => movie.to_param}, valid_session
  #     expect(assigns(:movie)).to eq(movie)
  #   end
  # end

  # describe "GET #new" do
  #   it "assigns a new movie as @movie" do
  #     get :new, {}, valid_session
  #     expect(assigns(:movie)).to be_a_new(Movie)
  #   end
  # end

  # describe "GET #edit" do
  #   it "assigns the requested movie as @movie" do
  #     movie = Movie.create! valid_attributes
  #     get :edit, {:id => movie.to_param}, valid_session
  #     expect(assigns(:movie)).to eq(movie)
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Movie" do
  #       expect {
  #         post :create, {:movie => valid_attributes}, valid_session
  #       }.to change(Movie, :count).by(1)
  #     end

  #     it "assigns a newly created movie as @movie" do
  #       post :create, {:movie => valid_attributes}, valid_session
  #       expect(assigns(:movie)).to be_a(Movie)
  #       expect(assigns(:movie)).to be_persisted
  #     end

  #     it "redirects to the created movie" do
  #       post :create, {:movie => valid_attributes}, valid_session
  #       expect(response).to redirect_to(Movie.last)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved movie as @movie" do
  #       post :create, {:movie => invalid_attributes}, valid_session
  #       expect(assigns(:movie)).to be_a_new(Movie)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:movie => invalid_attributes}, valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested movie" do
  #       movie = Movie.create! valid_attributes
  #       put :update, {:id => movie.to_param, :movie => new_attributes}, valid_session
  #       movie.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested movie as @movie" do
  #       movie = Movie.create! valid_attributes
  #       put :update, {:id => movie.to_param, :movie => valid_attributes}, valid_session
  #       expect(assigns(:movie)).to eq(movie)
  #     end

  #     it "redirects to the movie" do
  #       movie = Movie.create! valid_attributes
  #       put :update, {:id => movie.to_param, :movie => valid_attributes}, valid_session
  #       expect(response).to redirect_to(movie)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the movie as @movie" do
  #       movie = Movie.create! valid_attributes
  #       put :update, {:id => movie.to_param, :movie => invalid_attributes}, valid_session
  #       expect(assigns(:movie)).to eq(movie)
  #     end

  #     it "re-renders the 'edit' template" do
  #       movie = Movie.create! valid_attributes
  #       put :update, {:id => movie.to_param, :movie => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested movie" do
  #     movie = Movie.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => movie.to_param}, valid_session
  #     }.to change(Movie, :count).by(-1)
  #   end

  #   it "redirects to the movies list" do
  #     movie = Movie.create! valid_attributes
  #     delete :destroy, {:id => movie.to_param}, valid_session
  #     expect(response).to redirect_to(movies_url)
  #   end
  # end

end
