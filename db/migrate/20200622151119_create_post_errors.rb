class CreatePostErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :post_errors do |t|
      t.string :description, null: false
      t.references :restaurant, index: true, null: false

      t.timestamps null: false
    end
  end
end
