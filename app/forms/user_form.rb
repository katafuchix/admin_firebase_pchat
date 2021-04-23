class UserForm
  include Virtus.model
  include ActiveModel::Model

  attribute :id, String
  attribute :nickname, String
  attribute :profile_text, String

  validates_presence_of %i(
    id
    nickname
    profile_text
  )
end
