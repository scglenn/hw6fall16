class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R NR)
  end
  
class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    movie_list = []
    begin
      
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      Tmdb::Movie.find(string).each do |i|
        movie_element= Hash.new
        movie_element[:tmdb_id] =i.id
        movie_element[:title] =i.title

        rating =self.getRating(i.id)
        
        if(rating[0]==nil)
           movie_element[:rating] = "NR"
        else
          if(rating[0]["certification"].empty?)
            movie_element[:rating] = "NR"
          else
            movie_element[:rating] = rating[0]["certification"]
          end
        end
      
        movie_element[:release_date]=i.release_date
        movie_list.push( movie_element)
      end
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
    return movie_list
  end
  
  def self.getRating(id)
    begin
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      rating =Tmdb::Movie.releases(id)["countries"].select{ |m| m['iso_3166_1'] =="US"}
      return rating
    rescue
      raise Movie::InvalidKeyError, 'Invalid API key'
    end

    
  end  
  
  def self.create_tmdb_movie(tmdb_id)
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    movie_stats = Tmdb::Movie.detail(tmdb_id)
    
    rate =self.getRating(tmdb_id)
        
        if(rate[0]==nil)
           rate = "NR"
        else
          if(rate[0]["certification"].empty?)
            rate = "NR"
          else
            rate = rate[0]["certification"]
          end
        end
    
    Movie.create(title: movie_stats["original_title"], rating: rate, description: movie_stats["overview"], release_date: movie_stats["release_date"])
  end

end
