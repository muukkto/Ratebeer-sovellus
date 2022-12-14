class RatingsController < ApplicationController
  def index
    # rating/index.html.erb sivulla on cache joka pitää tietoja 5 minuuttia
    return if request.format.html? && fragment_exist?("ratings_page")

    @ratings = Rating.all
    @recent = Rating.recent
    @top_breweries = Brewery.top 3
    @top_beers = Beer.top 3
    @top_styles = Style.top 3
    @top_users = User.top 3
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    expire_fragment('brewerylist')
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user
    if @rating.save
      redirect_to current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
