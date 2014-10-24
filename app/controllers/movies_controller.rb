class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @ratings = session[:ratings]==nil ? @all_ratings:session[:ratings]
    unless params[:ratings].nil? 
      @ratings = params[:ratings]
      session[:ratings] = @ratings
    end
    
    @movies = []
    Movie.all.each do |movie|
      if @ratings.include? movie[:rating]
        @movies.push(movie)
      end
    end

    unless params[:sort_by].nil?
    session[:sort_by] = params[:sort_by]
      if params[:sort_by] == 'title'
      session[:title_class] = 'hilite' 
      session[:date_class] = '' end
      if params[:sort_by] == 'release_date'
      session[:date_class] = 'hilite' 
      session[:title_class] = '' end
    end
    unless session[:sort_by].nil?
      @movies = @movies.sort_by { |movie| movie.send(session[:sort_by])}
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