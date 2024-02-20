# Serializer Question Serializer
class QuestionSerializer
  def self.serialize(question)
    {
      id: question.id.to_s,
      title: question.title,
      content: question.content
    }
  end
end
