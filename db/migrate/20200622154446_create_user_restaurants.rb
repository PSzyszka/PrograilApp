class CreateUserRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :user_restaurants do |t|
      t.references :user, index: true, null: false
      t.references :restaurant, index: true, null: false
    end
  end
end
