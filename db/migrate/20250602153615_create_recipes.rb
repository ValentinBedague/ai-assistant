class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :name
      t.integer :portions_displayed
      t.integer :portions
      t.text :ingredients_displayed
      t.text :ingredients
      t.text :description_displayed
      t.text :description

      t.timestamps
    end
  end
end
