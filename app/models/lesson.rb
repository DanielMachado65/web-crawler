# model Lesson
class Lesson
  include Mongoid::Document
  include Mongoid::Timestamps

  field :header_title, type: Array
  field :header_body, type: Array
  field :title, type: String
  field :date, type: String

  has_many :questions
end
