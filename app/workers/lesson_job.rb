# LessonWriteJob
class LessonJob
  def perform(content_lesson)
    content_lesson = JSON.parse(content_lesson, symbolize_names: true)
    lesson_insert = insert_lesson(content_lesson)
    insert_questions(content_lesson[:questions], lesson_insert)
  end

  protected

  def insert_lesson(lesson)
    title = find_data_in_header(lesson[:header], type: 'titulo')
    date = find_data_in_header(lesson[:header], type: 'data')

    Lesson.find_or_create_by(title:, date:) do |new_lesson|
      new_lesson.header_title = lesson[:header]
      new_lesson.header_body = lesson[:header_body]
    end
  end

  def insert_questions(questions, lesson)
    questions.each do |question|
      Question.find_or_create_by(title: question[:title], lesson_id: lesson.id) do |new_question|
        new_question.content = question[:content]
        new_question.lesson = lesson
      end
    end
  end

  def find_data_in_header(header, type: 'titulo')
    header.find { |el| el[:type] == type }[:value]
  end
end
