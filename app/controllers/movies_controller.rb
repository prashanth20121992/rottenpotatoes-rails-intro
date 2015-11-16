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
    @movies = Movie.all
    @rating_selected=[]
    if params[:sort] and params[:ratings]
       session[:sort] = params[:sort]
       session[:ratings] = params[:ratings]
       
      if params[:sort].eql? 'title' 
        @movies = @movies.order('title asc')
      elsif params[:sort].eql? 'release' 
        @movies = @movies.order('release_date asc')
      end
      
      params[:ratings].each do |rating|
        @rating_selected.push(rating)
      end
      @movies = @movies.where(:rating => @rating_selected)
    elsif !params[:sort] and !params[:ratings]
      if session[:sort] or session[:ratings]
        flash.keep
        redirect_to movies_path(:sort=>session[:sort], :ratings => session[:ratings])
      end
      #check if we have :sort and :ratings in the session, use them as params 
      #with redirect, also keep flash hash
    elsif !params[:sort] and params[:ratings]
      #use params[:ratings] here, and check if we can use session[:sort]
      #redirect with new params, keep flash
      if session[:sort]
        flash.keep 
        redirect_to movies_path(:sort => session[:sort], :ratings => params[:ratings])
      end
      session[:ratings] = params[:ratings]
      params[:ratings].each do |rating|
        @rating_selected.push(rating)
      end
      @movies = @movies.where(:rating => @rating_selected)
    elsif params[:sort] and !params[:ratings]
      if session[:ratings]
        flash.keep 
        redirect_to movies_path(:sort=>params[:sort], :ratings => session[:ratings])
      end
      session[:sort] = params[:sort]
      if params[:sort].eql? 'title' 
        @movies = @movies.order('title asc')
      elsif params[:sort].eql? 'release' 
        @movies = @movies.order('release_date asc')
      end
    end
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
