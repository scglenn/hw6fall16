require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    
    
    #controller has search_tmdb function 
    #controler has add_tmdb function
    it 'should redirect the user to the main movies page no results are found' do
      post :search_tmdb, {:search_terms => 'aaghauioweghauipgh'}
      allow(Movie).to receive(:find_in_tmdb)
      expect(response).to redirect_to('/movies')
    end
    
    it 'should redirect the user to the index page if search term is nil' do
      post :search_tmdb, {:search_terms => nil}
      allow(Movie).to receive(:find_in_tmdb)
      expect(response).to redirect_to('/movies')
    end
    
    it 'should redirect the user to the main movies page if search term is empty' do
      post :search_tmdb, {:search_terms => ''}
      allow(Movie).to receive(:find_in_tmdb)
      expect(response).to redirect_to('/movies')
    end


  end
  describe 'Finding movie in TMDb' do
    it 'should call the find_in_tmdb method' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Bull'}
      expect(response).to render_template('search_tmdb')
    end
  end
  describe 'Create movie from TMDb' do
     it 'should call the model method that performs create_from_tmdb' do
        post :add_tmdb, {"tmdb_movies"=>{"941"=>"1"}, }
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to('/movies')
     end
     it 'should notify No movies selected and redirect to movies' do
        post :add_tmdb, {"tmdb_movies"=> nil}
        expect(flash[:warning]).to eq "No movies selected"
        expect(response).to redirect_to('/movies')
     end
  end
  
end
