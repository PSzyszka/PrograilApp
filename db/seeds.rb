Restaurant.create(
  name: 'Bistro Piccobello',
  facebook_url: 'https://www.facebook.com/pg/bistropiccobello/posts/?ref=page_internal'
)

Restaurant.create(
  name: 'La Nostra',
  facebook_url: 'https://www.facebook.com/pg/LaNostraObiadyPizza/posts/?ref=page_internal'
)

user = User.create(
  name: 'user',
  email: 'user@example.com',
  password: 'password',
  password_confirmation: 'password'
)

restaurants = Restaurant.all

restaurants.each do |restaurant|
  UserRestaurant.create(
    user: user,
    restaurant: restaurant
  )
end
