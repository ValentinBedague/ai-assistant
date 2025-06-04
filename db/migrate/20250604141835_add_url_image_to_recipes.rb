class AddUrlImageToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :url_image, :string
  end
end
