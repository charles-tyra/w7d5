class SessionsController < ApplicationController

    before_action :require_logged_out, only: [:new, :create]


    def new
        @user = User.new
        render :new
    end 

    def create
        username = params[:user][:username]
        password = params[:user][:password]
        @user = User.find_by_credentials(username, password)

        if @user
            log_in(@user)
            redirect_to user_url(@user)
        else
            redirect_to new_session_url
        end
    end 

    def destroy
        if logged_in?
            log_out!
        end
        redirect_to users_url
    end 
end
