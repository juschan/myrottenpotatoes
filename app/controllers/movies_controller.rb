class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.select(:rating).map(&:rating).uniq
    @selected_ratings = Hash.new
    if session[:first_time] == nil
      @all_ratings.each {|rating| @selected_ratings[rating] = "1"}
      @movies = Movie.all
      session[:first_time] = false
    else
      @selected_ratings = params[:ratings]
      @movies = Movie.find(:all, :conditions => {:rating => params[:ratings].keys}, :order => params[:sort])
      #session[:sort]= params[:sort]
      #session[:rating] = @selected_rating
    end
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
