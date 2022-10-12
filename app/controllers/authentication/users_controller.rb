class Authentication::UsersController < ApplicationController
    skip_before_action :protect_pages
    
    def new
        @user = User.new 
    end

    def create
        @user = User.new(user_params)
        if @user.save 
            session[:user_id] = @user.id
            redirect_to levels_path, notice: 'Usuario creado correctamente'
        else
            render :new, status: :unprocessable_entity
        end     
    end     
    private
    def user_params
        params.require(:user).permit(:document, :name, :username, :email, :password)
    end    
end    