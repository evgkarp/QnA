require 'rails_helper'

feature 'User log out', %q{
  In order to be able to close the session
  As an authenticated user
  I want to be able to exit from system
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user does log out' do
    sign_in(user)

    visit root_path
    click_on 'Log out'

    expect(page).to have_content('Signed out successfully.')
  end
end
