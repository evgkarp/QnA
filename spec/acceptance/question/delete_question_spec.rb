require 'rails_helper'

feature 'Delete question', %q{
  In order to be able to delete question
  As an authenticated user
  I want to be able to delete question
} do
  given(:user) { create(:user) }
  given(:user_2) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user tries to delete his question' do
    sign_in(user)
    visit questions_path
    click_on 'Delete'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).not_to have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Authenticated user tries to delete someone else question' do
    sign_in(user_2)
    visit questions_path

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Non-authenticated user tries to delete someone else question' do
    visit questions_path

    expect(page).to_not have_content 'Delete'
    expect(page).to have_content question.title
    expect(current_path).to eq questions_path
  end
end
