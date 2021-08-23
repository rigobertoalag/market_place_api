class Api::V1::UsersController < ApplicationController
    def show
        #GET /api/v1/users/1
        render json: User.find(params[:id])
    end

    def create
        @user = User.new(user_params)

        if @user.save 
            render json: @user, status: :created
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    private
    def user_params
        params.require(:user).permit(:email, :password)
    end
end


# Actualizar usuarios
# El esquema para actualizar usuarios es muy similar a la de creación. Si eres un desarrollador Rails experimentado, ya sabes las diferencias entre estas dos acciones: