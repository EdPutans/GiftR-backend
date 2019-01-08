require 'time'

class Api::V1::SantasController < ApplicationController

  def index
    @santa = Santa.all
    render json: @santa, include: ['receiver.first_name, gifter.first_name']
  end

  def mark_read
    @santa = Santa.find_by(id: params[:id])
    if @santa
      @santa.update(read: true)
      render json: @santa
    else
      render json: {error: 'could not find santa'}, status: 404
    end
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
      render json: {error: 'error creating santas'}, status: 401
    end
  end


  def get_gifter_santas
    @santas = Santa.where(gifter_id: params[:user_id])
    puts 'REEE'
    @santas = @santas.select{|e| e.deadline > Time.new }
    puts @santas
    puts 'UUU'
    if @santas || @santas && @santas.length > 0
      render json: @santas
    else
      render json: {error: "User has no santas"}, status: 400
    end
  end



  def show
    @santa = Santa.find_by(params[:id])
    if @santa
      render json: @santa
    else
      render json: {error: "no santas"}, status: 402
    end
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
