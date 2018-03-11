require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Author of new question' do
    background do
      sign_in(user)
      visit new_question_path
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'adds one file when he asks question', js: true do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'adds two files when he asks question', js: true do
      click_on 'add attachment'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Create'

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end

  describe 'Author of existing question' do
    before do
      sign_in(user)
      visit questions_path
      click_on 'Edit'
    end

    scenario 'adds one file when he edits question', js: true do
      click_on 'add attachment'

      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'
      click_on question.title

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'adds two files when he edits question', js: true do
      click_on 'add attachment'
      click_on 'add attachment'
      inputs = all('input[type="file"]')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
      click_on 'Save'
      click_on question.title

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
