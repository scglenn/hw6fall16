require 'spec_helper'
require 'rails_helper'
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
      context 'with no match found' do
        it 'should return  an array taht is empty' do
          allow(Tmdb::Movie).to receive(:find).with('').and_return (nil)
          expect(Movie.find_in_tmdb('')).to eq([])
        end
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
end

