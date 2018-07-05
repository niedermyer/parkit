require 'integration/integration_spec_helper'

describe 'Space management', type: :feature do

  feature 'Viewing available spaces' do

    scenario 'when spaces are available' do
      create :space, floor: 1, section: 'A', number: 1
      create :space, floor: 1, section: 'A', number: 2

      visit root_path

      expect(page).to have_content "1A-1"
      expect(page).to have_content "1A-2"
    end

    scenario 'when no spaces are available' do
      visit root_path

      expect(page).to have_content "There are no spaces available."
    end
  end

end

