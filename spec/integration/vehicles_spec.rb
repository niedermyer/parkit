require 'integration/integration_spec_helper'

feature 'Vehicle management', type: :feature do

  scenario 'Adding a new vehicle' do
    visit new_vehicle_path

    select 'Pennsylvania', from: 'State'
    fill_in 'Number', with: 'ABC123'
    fill_in 'Description', with: 'Red Make Model'
    fill_in 'Name', with: 'Alex Jones'
    fill_in 'Phone', with: '(123) 456-7890'
    click_on 'Save Vehicle'

    # redirected to show page
    within 'h1' do
      expect(page).to have_content "PA | ABC123"
    end

    expect(page).to have_content "Red Make Model"
    expect(page).to have_content "Alex Jones"
    expect(page).to have_content "(123) 456-7890"
  end

end
