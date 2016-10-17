
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  
  describe 'adding to RP by id' do
    it 'should call tmdb with id' do
      expect(Tmdb::Movie).to receive(:detail).with('2').and_call_original
      Movie.create_from_tmdb('2')
      
    end
  end 
  
  describe 'adding to RP' do
    it 'should call model method that creates from TMDb' do
      fake_results = [double('movie3')]
      expect(Movie).to receive(:create_from_tmdb).with('2') and return(fake_results)
      post :add_tmdb, {:checkbox => {'2':'1'}}
    end
    it 'should call model method id of the selected movie' do
      expect(Movie).to receive(:create_from_tmdb).with('2')
      post :add_tmdb, {:checkbox => {'2':'1'}}
    end
    it 'should redirect to movies if no movies selected' do
      post :add_tmdb, {}
      expect(response).to redirect_to('/movies')
    end
  end
end
