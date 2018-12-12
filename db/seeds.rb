# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



User.create(first_name: "Ed", last_name:"Putisaurus", email: "ed@putisaurus.com", age: 25, img_url:'none', password: "123")

User.create(first_name: "Moop", last_name:"Moopster", email: "moop@moopie.com", age: 15, img_url:'none', password: "12345")

Gift.create(name:"PC", user_id: 1, price: 1999.99, url: 'http://www.amazon.com', img_url: 'none', description: 'lorem hipsum pc')
Gift.create(name:"PC for Moop", price: 999.99, user_id: 2, url: 'http://www.amazon.com', img_url: 'none', description: 'lorem hipsum pc')
Gift.create(name:"Board for Moop", price: 29.99, user_id: 2, url: 'http://www.amazon.com', img_url: 'none', description: 'lorem hipsum board')
