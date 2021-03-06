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
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @sorting_style = params[:sort_by]
     if params[:ratings].nil?
      ratings_filter = @all_ratings
     else
      session[:sort_by] = params[:sort_by]
      ratings_filter = params["ratings"].keys
     end
      session[:ratings] = params[:ratings]
      if @sorting_style == "alpha"
        @title_sort=true
        return @movies = Movie.where(:rating => ratings_filter).order(title: :asc)
      end
      if @sorting_style == "date"
       @release_date_sort=true
       return @movies = Movie.where(:rating => ratings_filter).order(release_date: :asc)
      end
      @movies = Movie.where(:rating => ratings_filter)
    
      #if !params[:ratings] || !params[:sort_by]
      #  flash.keep
      # redirect_to movies_path session[:ratings], session[:sort_by] 
      #end 
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
