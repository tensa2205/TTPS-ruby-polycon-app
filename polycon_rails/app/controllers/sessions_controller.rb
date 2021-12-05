class SessionsController < ApplicationController
    def create
        user = User.find_by(name: params[:session][:name])
        if user && user.authenticate(params[:session][:password])
          session[:user_id] = user.id
          flash.now[:notice] = "Logged in successfully."
          redirect_to root_path
        else
          flash.now[:alert] = "There was something wrong with your login details."
          render 'new'
        end
      end
      
      def destroy
        session[:user_id] = nil
        flash[:notice] = "You have been logged out."
        redirect_to login_path
      end
      
end