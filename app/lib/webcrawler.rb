# web Crawler
class Webcrawler
  attr_accessor :url, :depth

  BASE_URL = 'https://reformabrasil.com.br/licoes/'.freeze
  LIMIT = 10

  def initialize(depth = 1)
    @url = BASE_URL
    @depth = depth
  end

  def crawl
    page = crawl_page(@url, @depth)
    link = page.at_css('.post-licao a')['href']

    lesson = access_link(link, @depth)
    get_lesson(lesson)
  end

  def crawl_all_for_each_lesson
    crawl_links.each do |links|
      links.each do |link|
        lesson_page = access_link(link, @depth)
        lesson_info = get_lesson(lesson_page) if lesson_page
        yield lesson_info if block_given?
      end
    end
  end

  def crawl_links(current_page = 0, all_links = [])
    return all_links if current_page >= LIMIT

    current_page += 1
    puts "Crawling page: #{current_page}"

    page = crawl_page("#{@url}?pagina=#{current_page}", @depth)
    return all_links unless page

    links = page.css('.post-licao a').map { |el| el['href'] }
    return all_links if links.empty?

    all_links << links

    crawl_links(current_page, all_links)
  end

  private

  # post-licao
  def crawl_page(url, depth)
    return if depth.negative?

    puts "access: #{url}"
    access_page(url)
  rescue StandardError => e
    puts "Erro ao acessar #{url}: #{e.message}"
  end

  def access_page(url)
    ::Nokogiri::HTML(URI.open(url, {
                                ssl_verify_mode: ::OpenSSL::SSL::VERIFY_PEER
                              }))
  end

  def access_link(link, depth)
    url = BASE_URL + link
    crawl_page(url, depth)
  end

  def get_lesson(page)
    LessonExtractor.new(page).exec
  end
end
