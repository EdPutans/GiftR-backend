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

  def unaccepted_ids
    render json: get_unaccepted.map{ |u| u[:user].id}
  end

  def active_requests
    render json: get_active_requests
  end

  def active_request_ids
    render json: get_active_requests.map{ |u| u[:user].id}
  end

  def get_active_requests
    @user = User.find_by(id: params[:user_id])
    if @user
      unaccepted = (@user.friendships).select{|f| !f.confirmed && !f.rejected}
      unaccepted = unaccepted.map{ |friendship| {user: User.find_by(id: friendship.friend_id), friendship_id: friendship.id, confirmed: friendship.confirmed, rejected: friendship.rejected }}.flatten
      return unaccepted
    else
      return {error: 'user not found'}
    end
  end

  def get_unaccepted
    @user = User.find_by(id: params[:user_id])
    if @user
      unaccepted = (@user.back_friendships).select{|f| !f.confirmed && !f.rejected}
      unaccepted = unaccepted.map{ |friendship| {user: User.find_by(id: friendship.user_id), friendship_id: friendship.id, confirmed: friendship.confirmed, rejected: friendship.rejected }}.flatten
      return unaccepted
    else
      return {error: 'user not found'}
    end
  end

  def unaccepted
    render json: get_unaccepted
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

# def notification_count
#
# end

private

def friendship_params
  params.require(:friendship).permit(:id, :confirmed, :rejected, :user_id, :friend_id)
end
