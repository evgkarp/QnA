require_relative '../acceptance_helper'

feature 'Delete files from question', %q{
  In order to be able to delete files from my question
  As an author of question
  I want to be able delete files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }
  given(:second_user) { create(:user) }

  describe 'Author of question' do
    before do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'deletes file when he edits question', js: true do
      click_on 'Delete attachment'

      expect(page).to_not have_content attachment.file.identifier
    end
  end

  scenario "Authenticated user can not see link Delete attachment from other user's question" do
    sign_in(second_user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
    expect(page).to_not have_link 'Delete attachment'
  end

  scenario "Unauthenticated user can not see link Delete attachment from other user's question" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
    expect(page).to_not have_link 'Delete attachment'
  end
end
