require 'rails_helper'

feature 'Create answer', %q{
  In order to help to somebody
  As an authenticated user
  I want to be able to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates an answer' do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your Answer', with: 'TestContent'
    click_on 'Post Your Answer'

    expect(page).to have_content 'TestContent'
    expect(page).to have_content 'Answer successfully created.'
  end

  scenario 'Non-authenticated user creates an answer' do
    visit question_path(question)
    fill_in 'Your Answer', with: 'TestContent'
    click_on 'Post Your Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to_not have_content 'TestContent'
  end

  scenario 'Authenticated user creates an invalid answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Post Your Answer'
    # save_and_open_page
    expect(page).to have_content "Body can't be blank"
  end
end
