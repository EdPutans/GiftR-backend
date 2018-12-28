class Api::V1::SantasController < ApplicationController
  def index
    @santa = Santa.all
    render json: @santa, include: ['receiver.first_name, gifter.first_name']
  end
end
