class UserForm
  include Virtus.model
  include ActiveModel::Model

  attribute :id, String
  attribute :name, String
  attribute :profile_text, String

  validates_presence_of %i(
    id
    name
    profile_text
  )
end
