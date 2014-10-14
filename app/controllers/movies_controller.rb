class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def sort_title
    session[:sort_by] = :title
    session[:title_class] = 'hilite'
    session[:date_class]=''
    redirect_to movies_path
  end

  def sort_date
    session[:sort_by] = :release_date
    session[:date_class]='hilite'
    session[:title_class]=''
    redirect_to movies_path
  end

  def index
    @movies = Movie.all
    sort_symbol = session[:sort_by]
    unless sort_symbol.nil?
      @movies = @movies.sort_by { |movie| movie.send(sort_symbol)}
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
