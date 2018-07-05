require 'csv'

spaces_seed_data_file = Rails.root.join('db', 'seed_data', 'development', 'spaces.csv')
spaces_csv_text = File.read(spaces_seed_data_file)
spaces_csv = CSV.parse(spaces_csv_text, headers: true, header_converters: [:downcase])

Space.transaction do
  spaces_csv.each do |row|
    space = Space.find_or_initialize_by(floor: row['floor'], section: row['section'], number: row['number'])
    space.save!
  end
end
