class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show]

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

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :portions, :ingredients, :description)
  end

end
