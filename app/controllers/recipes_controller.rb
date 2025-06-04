class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :reset_recipe]

  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.save
      redirect_to @recipe, notice: "#{@recipe.name} recipe was successfully created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def reset_recipe
    @recipe.portions_displayed = @recipe.portions
    @recipe.ingredients_displayed = @recipe.ingredients
    @recipe.description_displayed = @recipe.description

    if @recipe.save
      redirect_to @recipe, notice: "#{@recipe.name} has been succesfully reset ✅"
    else
      redirect_to @recipe, status: :unprocessable_entity
    end

  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(:name, :portions, :ingredients, :description, :url_image)
  end

end
