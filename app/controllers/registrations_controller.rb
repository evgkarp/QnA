class RegistrationsController < Devise::RegistrationsController
  before_action :set_user, only: [:edit_email, :update_email]

  def edit_email
    render 'users/edit_email'
  end

  def update_email
    if @user.update(user_params)
      redirect_to root_path
      flash[:notice] = "You will receive an email with instructions for how to confirm your email address in a few minutes."
    else
      render 'users/edit_email'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
