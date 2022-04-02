# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
logger = Rails.logger


def encrypted_password(password='password123')
  Employee.new.send(:password_digest, password)
end

logger.info "seeding admin"
employees = [
  {
    first_name: 'green',
    last_name: 'beans',
    email: 'green.beans2143@gmail.com',
    role: :admin,
    occupation: :guide,
    password: encrypted_password
  }
]

# seed members along with their requirements
logger.info "seeding mock members"
5.times do
  emp = Employee.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    role: :member,
    occupation: Employee.occupations.keys.sample,
    password: encrypted_password
  )

  5.times do |i|
    emp.jobs.create!(
      total_pay: Faker::Number.between(from: 25.0, to: 70.0),
      role: Employee.occupations.keys.sample,
      date_completed: i.months.ago,
      date_started: i.months.ago - Faker::Number.between(from: 2, to: 10),
      )
  end

  11.times.reverse_each do |i|
    emp.contributions.create!(
      amount: Faker::Number.between(from: 2, to: 25),
      purpose: 'seeded contribution',
      created_at: i.months.ago
    )
  end
end

logger.info "members mocked\n seeding contributors"
employees += 10.times.collect do
  {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    role: :contributor,
    occupation: Employee.occupations.keys.sample,
    password: encrypted_password
  }
end


# possibly use insert all to avoid validation errors:
# https://api.rubyonrails.org/classes/ActiveRecord/Persistence/ClassMethods.html#method-i-insert_all
Employee.create!(employees)

logger.info "contributors mocked"

