require_relative 'acceptance_helper'

feature 'User authorization', %q{
  In order to be able to use the site without sign up
  As an User
  I want to be able to authorization with vkontakte or github
} do
  given(:user) { create(:user) }

  describe 'Authorization with Vkontakte' do
    scenario 'guest sign in with Vkontakte account' do
      mock_auth_hash(:vkontakte)
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'

      fill_in 'Email', with: 'test@example.com'
      click_on 'Send me confirmation instructions'

      open_email('test@example.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed.')

      click_on 'Sign in with Vkontakte'
      expect(page).to have_content('Successfully authenticated from Vkontakte account.')
    end

    scenario 'existing user sign in with Vkontakte account' do
      mock_auth_hash(:vkontakte, user.email)
      visit new_user_session_path

      click_on 'Sign in with Vkontakte'
      expect(page).to have_content('Successfully authenticated from Vkontakte account.')
    end
  end

  describe 'Authorization with GitHub' do
    scenario 'guest sign in with GitHub account' do
      mock_auth_hash(:github)
      visit new_user_session_path
      click_on 'Sign in with GitHub'

      fill_in 'Email', with: 'test@example.com'
      click_on 'Send me confirmation instructions'

      open_email('test@example.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content('Your email address has been successfully confirmed.')

      click_on 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated from GitHub account.')
    end

    scenario 'existing user sign in with GitHub account' do
      mock_auth_hash(:github, user.email)
      visit new_user_session_path

      click_on 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated from GitHub account.')
    end
  end
end
