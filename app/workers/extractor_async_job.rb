# extractor
class ExtractorAsyncJob < LessonJob

  def perform
    crawler = Webcrawler.new
    content_lesson = crawler.crawl
    lesson = insert_lesson(content_lesson)
    insert_questions(content_lesson[:questions], lesson)
  end
end
