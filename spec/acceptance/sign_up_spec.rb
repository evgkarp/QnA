require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to use all the possibilities of the system
  As an User
  I want to be able to sign up
} do
  scenario 'Non-authenticated user tries to sign up' do
    visit root_path
    click_on 'Sign Up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'
    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(current_path).to eq root_path
  end
end
