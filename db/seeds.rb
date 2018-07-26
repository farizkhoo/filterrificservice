# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create countries
    Country.delete_all
    country_names = [
      'United States',
      'Canada',
      'Australia',
      'South Africa',
      'New Zealand',
      'Puerto Rico',
      'Ireland',
      'United Kingdom',
    ]
    countries = country_names.map do |country_name|
      Country.create(:name => country_name)
    end

    # Create services
    Service.delete_all
    1000.times.each do
      name = Random.firstname
      price = 40 + rand(160)
      country = countries.sample
      cost = 20 + rand(50)
      Service.create(
        :name => name,
        :price => price,
        :country_id => country.id,
        :cost => cost,
        :created_at => Random.date(-500..0),
      )
    end