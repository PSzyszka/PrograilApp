class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :description, null: false
      t.references :restaurant, index: true, null: false

      t.timestamps null: false
    end
  end
end
