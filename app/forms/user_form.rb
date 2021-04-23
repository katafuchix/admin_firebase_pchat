class UserForm
  include Virtus.model
  include ActiveModel::Model

  attribute :id, String
  attribute :nickname, String
  attribute :profile_text, String
  attribute :status, Int = 0

  STATUS = { ok: true, ng: false }.with_indifferent_access

  validates_presence_of %i(
    id
    nickname
    profile_text
    status
  )
end
