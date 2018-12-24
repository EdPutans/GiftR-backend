
class Api::V1::UsersController < ApplicationController

# ----critical -----

  def signin
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      render json: {user: @user, token: issue_token({id: @user.id})}
    else
      render json: {error:"Incorrect!"}, status: 401
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
      confirmed_friends = (@user.friendships + @user.back_friendships).flatten.select{|f| f.confirmed}
      friends = confirmed_friends.map{ |friend| User.where(id: friend.friend_id)}.flatten
      render_friends = friends.map{|f| {id: f.id, first_name: f.first_name, last_name: f.last_name, age: f.age, wishes: f.gifts} }
      puts render_friends
      render json: {friends: render_friends}
    else
      render json: {error: 'user not found'}, status: 404
    end
  end

  def unaccepted
    @user = User.find_by(id: params[:id])
    if @user
      unaccepted = (@user.friendships).select{|f| !f.confirmed && !f.rejected}
      unaccepted = unaccepted.map{ |friend| User.where(id: friend.friend_id)}.flatten
      render_unaccepted = unaccepted.map{|f| {id: f.id, first_name: f.first_name, last_name: f.last_name, age: f.age, wishes: f.gifts} }
      puts render_unaccepted
      render json: {unaccepted: render_unaccepted}
    else
      render json: {error: 'user not found'}, status: 404
    end
  end

  def friend_request
    @existing_friendship = Friendship.find_by(user_id: params[:id], friend_id: params[:friend_id], confirmed: true) || Friendship.find_by(user_id: params[:friend_id], friend_id: params[:id], confirmed: true)
    @unconfirmed_friendship = Friendship.find_by(user_id: params[:id], friend_id: params[:friend_id], confirmed: nil, rejected: nil) || Friendship.find_by(user_id: params[:friend_id], friend_id: params[:id], confirmed: nil, rejected: nil)
    if @unconfirmed_friendship
      render json: {error: 'previous request still not replied to'}, status: 400
    elsif !@existing_friendship && !@unconfirmed_friendship
      @friendship = Friendship.create(user_id: params[:id], friend_id: params[:friend_id], confirmed: false, rejected: false)
      render json: @friendship
    else
      render json: {error: 'friendship already exists'}, status: 401
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
  # the request must reverse friend_id and user_id, to match the apps purpose
  @friendship = Friendship.find_by(user_id: params[:user_id], friend_id: [:friend_id] )
  if @friendship.update()
    @friendship.
    render json: @friendship
  else
    render json: {error: "Unable to create this user"}, status: 404
  end
end


  def create
      @user = User.new(user_params)
      if @user.save
          render json: @user
      else
          render json: {error: "Unable to create this user"}, status: 400
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
      render json: user_results.flatten.map{|u| {id: u.id, first_name: u.first_name, last_name: u.last_name, gifts: u.gifts}}
    else
      puts user_results
      render json: {error: "No users found"}, status: 400
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
