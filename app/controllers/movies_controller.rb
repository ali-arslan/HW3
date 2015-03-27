# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  def index
    @movies = Movie.all

    @all_ratings = Movie.all_ratings
    ratings_hash = params[:ratings]

    @selected_ratings = @all_ratings if @selected_ratings.nil?
      
      # if params(:sort) != nil
   @sort_by = params[:sort_by]

    
    if cookies[:ratings]!=nil
      ratings_pers = YAML::load cookies[:ratings]
      sort_pers = YAML::load cookies[:sort]
    end

    if sort_pers == nil and @sort_by !=nil
      cookies[:sort] = @sort_by
      sort_pers = @sort_by
      flash.keep
      redirect_to movies_path(@sort_by)
    elsif @sort_by == nil and sort_pers !=nil
      @sort_by = sort_pers
      cookies[:sort] = @sort_by
    elsif @sort_by != sort_pers and @sort_by != nil and sort_pers != nil
      sort_pers = @sort_by
      cookies[:sort] = @sort_by
    end

    if ratings_pers == nil and ratings_hash !=nil 
      cookies[:ratings] = YAML::dump ratings_hash
      ratings_pers = ratings_hash
      flash.keep
      redirect_to movies_path(ratings_hash)
    elsif ratings_hash == nil and ratings_pers !=nil 
      ratings_hash = ratings_pers
      cookies[:ratings] = YAML::dump ratings_hash
    elsif ratings_hash != ratings_pers and ratings_hash!= nil and ratings_pers!= nil 
      ratings_pers = ratings_hash
      cookies[:ratings] = YAML::dump ratings_hash
    end

    if ratings_hash != nil
      @selected_ratings = ratings_hash.keys
      extracted = ratings_hash.select{|key, hash| hash == "1"}.map{|i| i[0]}
      newMovs = []
      (0..extracted.size - 1).each do |i|
        x = Movie.find(:all,:conditions =>{:rating => extracted[i]})
        (0..x.size - 1).each do|j|
          newMovs.push(x[j])
        end
      end
      if @sort_by == "title"
        @movies = newMovs.sort!{|a,b| a.title <=> b.title}
      end
      if @sort_by == "release_date"
        @movies = newMovs.sort!{|a,b| a.release_date <=> b.release_date}
      end
      if @sort_by == nil
        @movies = newMovs
      end
    else
      begin
        @movies = Movie.order("#{@sort_by} ASC").find(:all)
      rescue ActiveRecord::StatementInvalid
      end
    end

  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # Look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
