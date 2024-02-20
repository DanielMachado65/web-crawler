# question model
class Question
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :content, type: Array

  belongs_to :lesson
end
