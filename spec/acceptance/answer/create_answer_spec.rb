require 'rails_helper'

feature 'Create answer', %q{
  In order to help to somebody
  As an authenticated user
  I want to be able to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user tries to create an answer' do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your Answer', with: 'TestContent'
    click_on 'Post Your Answer'

    expect(page).to have_content 'MyQuestionTitle'
    expect(page).to have_content 'MyQuestionBody'
    expect(page).to have_content 'TestContent'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user tries to create an answer' do
    visit question_path(question)
    fill_in 'Your Answer', with: 'TestContent'
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to_not have_content 'TestContent'
    expect(current_path).to eq new_user_session_path
  end
end
