# extractor
class ExtractorAllAsyncJob < LessonJob
  def perform
    crawler = Webcrawler.new
    crawler.crawl_all_for_each_lesson do |content_lesson|
      p "Lesson #{content_lesson[:header]}"
      lesson = insert_lesson(content_lesson)
      insert_questions(content_lesson[:questions], lesson)
      lesson
    end
  end
end
