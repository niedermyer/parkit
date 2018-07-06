# ParkIt

A simple Ruby on Rails application for valets to manage cars and parking spaces for a single garage. 
This simple implementation will seed 10 spaces across two sections on a single floor. It will allow 
the user to add vehicles to the database that can then be assigned to parking spaces. It will then allow 
the user to archive the parking assignment to free the space up for the next vehicle.

## Usage

### Create a Parking Assignment

On the dashboard, the user simply clicks the 'Park Next Vehicle' button. This will find the closest
available space (lowest floor, lowest section), and allow you to pick the vehicle that you want to assign.
If your vehicle is not on the list, you'll need to add it by following the 'Add New Vehicle' link in the
form field hint. If your vehicle is in the dropdown, select it and click 'Create Parking Assignment'.

If you want to choose your parking space manually, click the 'Spaces' link in the header navigation.
You see a list of available spaces in the left column (on a large monitor). Select the space you would
like to assign, and then follow the same directions as above.

You'll now see the new parking assignment listed on the dashboard.

### Archiving a Parking Assignment

All active parking assignments are listed on the dashboard. Click the 'Check Out' link for the assignment
tha you want to archive. This will take you to the Parking assignment show page in order to double check
all the details for the record. Once you are sure, you click 'Archive this Parking Assignment'. This will
redirect you back to the dashboard and the space will now be available for a new assignment.

## Requirements

- Ruby 2.5.1
- PostgreSQL

## Database Setup

To setup your local database run:

`bin/rake db:setup`

This will create your development and test databases. It will load the current schema into your development database
and it will seed 10 parking spaces into development data.

## Test Suite

Testing is implemented using RSpec. To run the entire suite simply run `bin/rspec` from the app's root directory.
