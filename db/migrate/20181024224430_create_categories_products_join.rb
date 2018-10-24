class CreateCategoriesProductsJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :categories_products do |t|
      t.belongs_to :book, index: true
      t.belongs_to :genre, index: true
    end
  end
end
