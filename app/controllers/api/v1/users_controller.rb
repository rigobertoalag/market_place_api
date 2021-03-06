class Api::V1::UsersController < ApplicationController
    before_action :set_user, only:[:show, :update, :destroy]
    before_action :check_owner, only: [:update, :destroy]

    def show
        #GET /api/v1/users/1
        options = { include: [:products]}
        render json: UserSerializer.new(@user, options).serializable_hash
    end

    def create
        @user = User.new(user_params)

        if @user.save 
            # render json: @user, status: :created
            render json: UserSerializer.new(@user).serializable_hash, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def update 
        if @user.update(user_params)
            # render json: @user, status: :ok
            render json: UserSerializer.new(@user).serializable_hash
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def destroy 
        @user.destroy
        head 204
    end

    private
    def user_params
        params.require(:user).permit(:email, :password)
    end

    def set_user
        @user = User.find(params[:id])
    end

    def check_owner 
        head :forbidden unless @user.id == current_user&.id
    end
end