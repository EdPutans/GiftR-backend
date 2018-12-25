class Api::V1::FriendshipsController < ApplicationController

  def index
    render json: Friendship.all
  end

  def create
    puts "PARAMS:"
    puts params
    puts 'eeeeeeee'
    @existing_friendship = Friendship.find_by(user_id: params[:user_id], friend_id: params[:friend_id], confirmed: true)
    @existing_friendship = Friendship.find_by(user_id: params[:friend_id], friend_id: params[:id], confirmed: true) if !@existing_friendship
    puts "found it!"
    puts @existing_friendship
    @unconfirmed_friendship = Friendship.find_by(user_id: params[:user_id], friend_id: params[:friend_id], confirmed: false, rejected: false)
    @unconfirmed_friendship =  Friendship.find_by(user_id: params[:friend_id], friend_id: params[:user_id], confirmed: false, rejected: false) if !@unconfirmed_friendship
    puts 'unconfirmed:'
    puts @unconfirmed_friendship
    if @unconfirmed_friendship
      render json: {error: 'previous request still not replied to'}, status: 400

    elsif @existing_friendship
      render json: {error: 'friendship already exists'}, status: 401

    elsif !@existing_friendship && !@unconfirmed_friendship
      @friendship = Friendship.create(user_id: params[:user_id], friend_id: params[:friend_id], confirmed: false, rejected: false)
      if @friendship
        render json: @friendship
      else
        render json: {error: 'could not create friendship'}
      end
    end
  end


  def unaccepted
    @user = User.find_by(id: params[:user_id])
    if @user
      unaccepted = (@user.friendships).select{|f| !f.confirmed && !f.rejected}
      unaccepted = unaccepted.map{ |friendship| {user: User.find_by(id: friendship.friend_id), friendship_id: friendship.id, confirmed: friendship.confirmed, rejected: friendship.rejected }}.flatten
      puts "unaccepted:"
      puts unaccepted
      puts "-----------------"
      # render_unaccepted = unaccepted.map{|f| {id: f[:user].id, first_name: f[:user].first_name, last_name: f[:user].last_name, age: f[:user].age, wishes: f[:user].gifts} }
      # puts render_unaccepted
      render json: unaccepted
    else
      render json: {error: 'user not found'}, status: 404
    end
  end


  def update
    puts 'updating with these params:'
    puts params
    puts '---------'

    @friendship=Friendship.find_by(id: params[:id])
    if @friendship.update(friendship_params)
      render json: @friendship
    else
      render json: {error: "Friendship is not magic. it broke."}, status: 400
    end
  end
end


private

def friendship_params
  params.require(:friendship).permit(:id, :confirmed, :rejected, :user_id, :friend_id)
end
