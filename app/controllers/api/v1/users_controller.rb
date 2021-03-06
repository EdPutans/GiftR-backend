
class Api::V1::UsersController < ApplicationController

# ----critical -----

  def signin
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      render json: {user: @user, token: issue_token({id: @user.id})}
    else
      render json: {error:"Incorrect login details!"}, status: 401
    end
  end

def validate
  puts request.headers['Authorization']
  @user = get_current_user
  if @user
    render json: {id: @user.id, gifts: @user.gifts, token: issue_token(@user.id), user: @user}
  else
    render json: {error: "Invalid credentianls."}, status: 401
  end
end

# -----------------------------------------------------

  def friends
    @user = User.find_by(id: params[:id])
    if @user
      confirmed_friendships = (@user.friendships + @user.back_friendships).flatten.select{|f| f.confirmed}
      friends = []
      friends << confirmed_friendships.map{ |friendship| User.find_by(id: friendship.friend_id)}.flatten
      friends << confirmed_friendships.map{ |friendship| User.find_by(id: friendship.user_id)}.flatten
      friends = friends.flatten
      render_friends = friends.map{|f| {id: f.id, first_name: f.first_name, last_name: f.last_name, age: f.age, wishes: f.gifts, img_url: f.img_url} }
      # puts render_friends
      render_friends = render_friends.select{|person| person[:id] != @user.id}
      render json: render_friends
    else
      render json: {error: 'user not found'}, status: 404
    end
  end

``


  def friend_request
    @existing_friendship = Friendship.find_by(user_id: params[:id], friend_id: params[:friend_id], confirmed: true) || Friendship.find_by(user_id: params[:friend_id], friend_id: params[:id], confirmed: true)

    @unconfirmed_friendship = Friendship.find_by(user_id: params[:id], friend_id: params[:friend_id], confirmed: false || nil, rejected: false || nil) || Friendship.find_by(user_id: params[:friend_id], friend_id: params[:id], confirmed: false || nil, rejected: false || nil)

    if @unconfirmed_friendship
      render json: {error: 'previous request still not replied to'}, status: 400

    elsif @existing_friendship
      render json: {error: 'friendship already exists'}, status: 401

    elsif !@existing_friendship && !@unconfirmed_friendship
      @friendship = Friendship.create(user_id: params[:id], friend_id: params[:friend_id], confirmed: false, rejected: false)
      if @friendship
        render json: @friendship
      else
        render json: {error: 'could not create friendship'}
      end
    end

  end


  def add_friend
    @user= User.find_by(id: params[:id])
    if @user
      Friendship.create(user_id: params[:id], friend_id: params[:friend_id])
      render json: @user.friendships
    else
      render json: {error: 'user not found'}, status: 404
    end
  end


def confirm_or_reject
  # the request must come in reverse friend_id and user_id from the FRONT END, to match the apps purpose
  @friendship = Friendship.find_by(user_id: params[:user_id], friend_id: [:friend_id] )
  @friendship? (puts @friendship) : (puts "cant find friendhsip")
  puts params
  if @friendship.update()
    render json: @friendship
  else
    render json: {error: "Unable to update request"}, status: 404
  end
end


  def create
      @user = User.find_by(email: params[:email])
      if !@user
        @user = User.new(user_params)
        if @user.save
            render json: @user
        else
            render json: {error: "Unable to create this user"}, status: 400
        end
      else
        render json: {error: 'Email already in use'}, status: 400
      end
  end


  def find_user
    query = params[:search].downcase.split(' ').join('').split('')
    puts query
    puts '^ query'
    user_results=[]
    User.all.each do |u|
      letter_set = "#{u.first_name.downcase}#{u.last_name.downcase}".split('') if u.last_name && u.first_name
      letter_set = u.first_name.downcase.split('') if u.first_name && !u.last_name
      letter_set = u.last_name.downcase.split('') if !u.first_name && u.last_name
      user_results << u if query.all? {|l| letter_set.include?(l)}
    end
    if user_results.length > 0
      puts user_results
      render json: user_results.flatten.map{|u| {id: u.id, first_name: u.first_name, last_name: u.last_name, gifts: u.gifts, img_url: u.img_url}}
    else
      puts user_results
      render json: {error: "No users found"}, status: 400
    end
  end


      def show
          @user = User.find_by(id: params[:id])
          if @user
              render json: @user
          else
              render json: {error: "User was not found"}, status: 404
          end
      end

  def update
      @user = User.find_by(id: params[:id])
      if @user && @user.authenticate(params[:old_password])
          puts "user authenticated"
          @user.update(user_params)
          @user.save
          render json: @user
      else
          render json: {error: "Could not patch user"}, status: 400
      end
  end


  def get_items
    @user = get_current_user
    if @user
      render json: @user.gifts
    else
      render json: {error: "Error rendering stuff"}, status: 400
    end
  end

  private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_digest, :age, :img_url, :old_password, :search, :friend_id, :confirmed, :rejected)
  end

end
