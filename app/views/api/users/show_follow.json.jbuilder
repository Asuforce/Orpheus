json.user do
  json.id @user.id
  json.name @user.name
  json.admin @user.admin
end

json.set! @title.downcase do
  json.users do
    json.array!(@users) do |user|
      json.extract! user, :id, :name
      json.img gravatar_url(user, size: 50)
    end
  end
end
