json.(user, :id, :email, :name, :role)
json.token user.generate_jwt
