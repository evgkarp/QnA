require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  In order to be able to delete answer
  As an authenticated user
  I want to be able to delete answer
} do
  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Authenticated user deletes his answer', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).not_to have_content answer.body
  end

  scenario 'Authenticated user deletes someone else answer', js: true do
    sign_in(non_author)
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Non-authenticated user deletes someone else answer', js: true do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
