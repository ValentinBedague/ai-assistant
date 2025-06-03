class RecipesController < ApplicationController

  def index
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

  def edit_portions
  end

  def edit_ingredients
  end

  def update
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :portions, :ingredients, :description)
  end

end
