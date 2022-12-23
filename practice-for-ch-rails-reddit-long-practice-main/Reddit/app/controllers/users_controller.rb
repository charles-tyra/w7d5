class UsersController < ApplicationController

    before_action :require_logged_out, only: [:create, :new]
    before_action :require_logged_in, only: [:index, :show]

    def index
        @users = User.all
        render :index
    end

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            log_in(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = "Please provide a unique username and valid password, try again :)"
            render :new
        end
    end 

    def show
        @user = User.find(params[:id])
        render :show
    end 

    private
    def user_params
        params.require(:user).permit(:username, :password)
    end
end
