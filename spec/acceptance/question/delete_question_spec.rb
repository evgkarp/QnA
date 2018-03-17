require_relative '../acceptance_helper'

feature 'Delete question', %q{
  In order to be able to delete question
  As an authenticated user
  I want to be able to delete question
} do
  given(:author) { create(:user) }
  given(:non_author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Authenticated user deletes his question', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).not_to have_content question.title
  end

  scenario 'Authenticated user deletes someone else question', js: true do
    sign_in(non_author)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
    expect(page).to have_content question.title
  end

  scenario 'Non-authenticated user deletes someone else question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
    expect(page).to have_content question.title
  end
end
