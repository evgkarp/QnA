class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    omniauth_callback('Vkontakte')
  end

  def github
    omniauth_callback('GitHub')
  end

  protected

  def omniauth_callback(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.confirmed?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to edit_email_path(@user)
    end
  end
end
