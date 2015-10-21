class SessionsController < ApplicationController
  def new
  end
  def create
    @user = User.find_by(email: session_params[:email].downcase)
    if @user && @user.authenticate(session_params[:password])
      if @user.activated?
        log_in @user
        session_params[:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = 'Account not activated. Please check your email for activation link!'
        flash[:danger] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
    def session_params
      params.require(:session).permit(:email, :password, :remember_me)
    end
end
