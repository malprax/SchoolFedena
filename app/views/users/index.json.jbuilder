json.array!(@users) do |user|
  json.extract! user, :id, :username, :first_name, :last_name, :email, :admin, :student, :employee, :hashed_password, :salt, :reset_password_code, :reset_password_code_until
  json.url user_url(user, format: :json)
end
