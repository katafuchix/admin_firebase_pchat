class UserForm
  include Virtus.model
  include ActiveModel::Model

  attribute :id, String
  attribute :nickname, String
  attribute :profile_text, String
  attribute :status, Integer #= 0
  attribute :age, Integer #= 0
  attribute :sex, Integer #= 0
  attribute :prefecture_id, Integer #= 0

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
