# Serializer for a Lesson model
class LessonSerializer
  def self.serialize(lesson)
    {
      id: lesson.id.to_s,
      title: lesson.title,
      date: lesson.date,
      header_title: lesson.header_title,
      header_body: lesson.header_body,
      questions: lesson.questions.map { |q| QuestionSerializer.serialize(q) }
    }
  end
end
