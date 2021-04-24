class ArticleForm
  include Virtus.model
  include ActiveModel::Model

  attribute :id, String
  attribute :text, String
  attribute :status, Integer

  validates_presence_of %i(
    id
    text
    status
  )
end
