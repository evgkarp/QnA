require_relative '../acceptance_helper'

feature 'Create comment', %q{
  In order to comment the question or the answer
  As an authenticated user
  I want to be able to add comment for the question or the answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user adds a comment for the question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'add a comment'
      fill_in 'Your Comment', with: 'TestComment'
      click_on 'Post Your Comment'

      expect(page).to have_content 'TestComment'
    end
  end

  scenario 'Authenticated user adds a comment for the answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-id-#{answer.id}" do
      click_on 'add a comment'
      fill_in 'Your Comment', with: 'TestComment'
      click_on 'Post Your Comment'

      within '.comments-list' do
        expect(page).to have_content 'TestComment'
      end
    end
  end

  scenario 'Non-authenticated user can not see link add a comment', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'add a comment'
  end
end
