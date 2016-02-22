class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings=['G','PG','PG-13','R']
    @ratingsarray=[]
    if (params.has_key?(:ratings)) #workin
      @ratingsarray = (params[:ratings].keys)
      cookies[:ratings] = @ratingsarray
    elsif (cookies.has_key?(:ratings)) #not
      @ratingsarray = cookies[:ratings].split(/&/) #I have no idea why cookies saves an array as a string, but I hate everythign and it is 2:40 in the morning
    else #does work, cookies are not
      @ratingsarray = ['G', 'PG', 'PG-13', 'R']
      cookies[:ratings] = @ratingsarray
    end
    
    
    
    if (params[:sorted] == 'title_sorted') 
      @movies = (Movie.where(rating: @ratingsarray)).order(:title)
      cookies[:sorted] = 'title_sorted'
    elsif (params[:sorted] == 'release_date_sorted') 
      @movies = (Movie.where(rating: @ratingsarray)).order(:release_date)
      cookies[:sorted] = 'release_date_sorted'
    elsif (cookies[:sorted] == 'title_sorted')
      @movies = (Movie.where(rating: @ratingsarray)).order(:title)
    elsif (cookies[:sorted] == 'release_date_sorted')
      @movies = (Movie.where(rating: @ratingsarray)).order(:release_date)
    else
      @movies = Movie.where(rating: @ratingsarray)
    end
  end

  def title_sorted
    @movies = (Movie.all).order(:title)
  end
  
  def release_date_sorted
    @movies = (Movie.all).order(:release_date)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
