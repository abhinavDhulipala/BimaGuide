module FixtureFileHelpers
  def encrypted_password(password = 'password123')
    Employee.new.send(:password_digest, password)
  end
end
