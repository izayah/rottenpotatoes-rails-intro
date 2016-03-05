class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    #@saved_sort_by = session[:sort_by]
   # @saved_ratings_filter = params["ratings"].keys
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    #session[:return_to] ||= request.referer
    
    #redirect_to session.delete(:return_to)
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    @sorting_style = params[:sort_by]
    session[:params] ||= {}
    old_params = session[:params]
    
   # params[:sort_by] = old_params[:sort_by] if params[:sort_by].nil?
   #params[:ratings] = old_params[:ratings] if params[:ratings].nil?
    #redirect_to movies_path if({:sort_by => old_params[:sort_by], :ratings => old_params[:ratings]}) if (params[:sort_by].blank? && old[:sort_by].present?) || (params[:ratings].blank? && old_params[:ratings].present?)
    
     if params[:ratings].nil?
      ratings_filter = @all_ratings
     else
      ratings_filter = params["ratings"].keys
     end
    
    #if params[:ratings] || params[:sort_by]
    if @sorting_style == "alpha"
      @title_sort=true
      return @movies = Movie.where(:rating => ratings_filter).order(title: :asc)
    end
   if @sorting_style == "date"
     @release_date_sort=true
   return @movies = Movie.where(:rating => ratings_filter).order(release_date: :asc)
   end
   if session[:ratings] || session[:sort_by]
     flash.keep 
     redirect_to movies_path :sort_by => session[:sort_by], :ratings => session[:ratings]
   # @movies = Movie.where(:rating => ratings_filter)
   end
   # end
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
