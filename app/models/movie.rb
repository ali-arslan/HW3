class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

   @@all_ratings = ["G","PG-13","PG","R","NC-17"]

   cattr_accessor :all_ratings

end
