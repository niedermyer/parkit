# ParkIt

A simple Ruby on Rails application for valets to manage cars and parking spaces for a single garage. 
This simple implementation will seed 10 spaces across two sections on a single floor. It will allow 
the user to view a list of available spaces and assign a car to that space. It will then allow the user
to archive the parkign assignment to free the space up for the next car.

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
