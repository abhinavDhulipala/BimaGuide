# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
def encrypted_password(password = 'password123')
  Employee.new.send(:password_digest, password)
end

employees = [
  {
    first_name: 'green',
    last_name: 'beans',
    email: 'green.beans2143@gmail.com',
    role: :admin,
    occupation: :guide,
    password: encrypted_password
  },
  {
    first_name: 'rico',
    last_name: 'suave',
    email: 'rico.suave10@gmail.com',
    role: :member,
    occupation: :cook,
    password: encrypted_password
  }
]

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