GiftR is a social application which allows a user to look up other registered users and see their gift preferences.

The applications is built using React on the front end and Ruby on Rails on the back end. The front end of the app can be located here: https://github.com/edPutans/giftr-frontend

To install:

clone the repository and navigate into it
run ```bundle install```
run ```rails db:create && rails db:migrate```
```rails s``` to run server

The back end uses Rails v 5.2, with the addition of the following gems:
- Active Model Serializer to render additional data in JSON
- JWT allows the user to stay logged in
- bcrypt hashes the user's password before storing it

Functionality:

The application allows a user:
 - to sign up / log into the application
 - edit the user's details, including uploading a profile picture, which gets stored on Cloudinary
 - full CRUD for items on the wishlist, with price, purchase links and image url
 - find other users by their first and last name, see their gift preferences
 - add people as friends
 - receive notification when someone adds the user as a friend (note: Users on both sides only become friends when the addressant accepts  the request from the notification area)
Secret santa generator (currently in development) allows creating a list of users and after clicking "Randomize" allocates a gift receiver for each person on the list. Randomization can be done as many times as the user likes. After confirming the lists, everybody on the list receives a notification with the details, which can later be viewed in the Secret Santa tab. Once the Secret santa deadline has passed, the information will no longer be shown to the user.

Contributing:

At this stage the application is still in the development stage. All suggestions are welcome. Pull requests will also be reviewed.
