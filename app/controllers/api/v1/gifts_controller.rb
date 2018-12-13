class Api::V1::GiftsController < ApplicationController


    def index
        @gifts = Gift.all
        render json: @gifts
    end

    def create
        @gift = Gift.new(gift_params)
        if @gift.save
            render json: @gift
        else
            render json: {error: "Unable to create this gift"}, status: 400
        end
    end

    def show
        @gift = Gift.find_by(id: params[:id])
        if @gift
            render json: @gift
        else
            render json: {error: "Gift was not found"}, status: 404
        end
    end

    def update
        @gift = Gift.find(params[:id])
        if @gift.update(gift_params)
            @gift.save
            render json: @gift
        else
            render json: {error: "Unable to create this gift"}, status: 400
        end
    end

    def destroy
      @gift = Gift.find_by(id: params[:id])
      @gift.delete
      render json: Gift.all
    end

    private

    def gift_params
        require(:params).permit(:id, :name, :url, :img_url, :rating, :description, :price)
    end

end
