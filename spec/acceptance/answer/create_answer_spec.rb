require 'rails_helper'

feature 'Create answer', %q{
  In order to help to somebody
  As an authenticated user
  I want to be able to answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your Answer', with: 'TestContent'
    click_on 'Post Your Answer'
    # wait_for_ajax
    expect(page).to have_content 'Answer successfully created.'
    within '.answers' do
      expect(page).to have_content 'TestContent'
    end
  end

  scenario 'Non-authenticated user creates an answer', js: true do
    visit question_path(question)
    fill_in 'Your Answer', with: 'TestContent'
    click_on 'Post Your Answer'
    # wait_for_ajax
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(page).to_not have_content 'TestContent'
  end

  scenario 'Authenticated user creates an invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Post Your Answer'
    # wait_for_ajax
    expect(page).to have_content "Body can't be blank"
  end
end
