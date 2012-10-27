class MoviesController < ApplicationController
  @all_ratings = ['G']
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    #will render app/views/movies/show.<extension> by default
  end

  def index
    if params.has_key?(:ratings) 
      @selected_keys = params[:ratings].keys

      #if @selected_keys.length > 0 
        conds = []
        @selected_keys.each do |k|
          conds << [ "rating = '" + k+"'"]
        end
        conds = conds.join(' or ')
        inter_result = Movie.all(:conditions => conds)
    else
      inter_result = Movie.all
    end

    @sort = params[:sort] 

    if params[:sort] == "by_title"
      @movies = Movie.find(:all, :order => "title")
    elsif params[:sort] == "by_date"
      @movies = Movie.find(:all, :order => "release_date")
    else
      @movies = Movie.all
      @movies = inter_result
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
