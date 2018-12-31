require 'time'

class Api::V1::SantasController < ApplicationController

  def index
    @santa = Santa.all
    render json: @santa, include: ['receiver.first_name, gifter.first_name']
  end


  def create_santa_list
    puts params
    puts params[:budget]
    list = params[:list]
    date = params[:deadline]
    deadline = Date.new(date[0],date[1],date[2])
    result = []
    result << list.map{|e| Santa.create(gifter_id: e[:gifter_id], receiver_id: e[:receiver_id], budget: params[:budget].to_f, deadline: deadline)}

    if result.length > 0
      render json: result.flatten
    else
      render json: {error: 'error creating santas'}
    end
  end



  def show
    @santa = Santa.find_by(params[:id])
    render json: @santa
  end

  def create
    @santa = Santa.new(santa_params)
    if @santa.save
      render json: @santa
    else
      render json: {error: 'error creating secret santa thingy'}
    end
  end

private

  def santa_params
    params.require(:santa).permit(:budget, :receiver_id, :gifter_id, :id, :list, :deadline)
  end
end
