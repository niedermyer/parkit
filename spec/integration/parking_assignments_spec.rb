require 'integration/integration_spec_helper'

describe 'Parking Assignment management', type: :feature do

  feature 'Assigning a vehicle to a space' do
    let!(:space) { create :space, floor: 1, section: 'A', number: 1 }
    let!(:vehicle) { create :vehicle, license_state: 'PA', license_number: 'ZZZZZ', description: 'Red' }

    scenario 'selecting a vehicle for an available space' do
      visit root_path
      click_on "Park Next Vehicle"

      select 'ZZZZZ | PA | Red', from: 'Vehicle'
      click_on 'Create Parking Assignment'

      expect(page).to have_content "The parking assignment was successfully created"

      within "#active-parking-assignments" do
        expect(page).to have_content "1A-1"
        expect(page).to have_content "ZZZZZ | PA | Red"
        expect(page).to have_link "Check Out"
      end
    end

    scenario 'forgetting to select a vehicle for an available space' do
      visit root_path
      click_on "Park Next Vehicle"

      click_on 'Create Parking Assignment'

      expect(page).to have_content "There was a problem with creating the parking assignment"

      # still on form page with error
      expect(page).to have_content "New Parking Assignment for 1A-1"
    end

    scenario 'selecting a vehicle for an unavailable space' do
      create :parking_assignment, space: space, vehicle: vehicle
      visit space_parking_assignments_new_path(space)

      select 'ZZZZZ | PA | Red', from: 'Vehicle'
      click_on 'Create Parking Assignment'

      expect(page).to have_content "The parking assignment could not be created because the space is no longer be available"

      # back on the dashboard
      expect(page.current_path).to eq root_path
    end
  end

end

