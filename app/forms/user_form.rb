class UserForm
  include Virtus.model
  include ActiveModel::Model

  attribute :id, String
  attribute :nickname, String
  attribute :profile_text, String
  attribute :status, Int = 0
  attribute :age, Int = 0
  attribute :sex, Int = 0
  attribute :prefecture_id, Int = 0

  validates_presence_of %i(
    id
    nickname
    profile_text
    status
    age
    sex
    prefecture_id
  )
end
