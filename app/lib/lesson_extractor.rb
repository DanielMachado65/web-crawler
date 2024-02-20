# lesson extractor
class LessonExtractor
  HEADER_TITLE = {
    'h1' => 'titulo',
    'h5' => 'subtitulo',
    'h6' => 'data'
  }.freeze

  def initialize(page)
    @page = page
  end

  def exec
    {
      header:,
      header_body:,
      questions:
    }
  end

  def header
    p 'extracting title...'
    @page.at_css('.bg-fusion-50').children.select { |el| %w[h1 h5 h6].include?(el.name) }.map do |el|
      { type: HEADER_TITLE[el.name], value: el.text }
    end
  end

  def questions
    p 'extracting body...'
    body_elements = @page.at_css('.panel-content').children.select { |el| el['id'] }
    data = []
    current_data = {}
    count = 0

    body_elements.each do |element|
      case element['id']
      when 'topico_txt'
        data << current_data unless current_data.empty?
        current_data = { title: { type: 'titulo', value: element.text, id: count } }

      when 'pergunta_txt'
        current_data[:content] ||= []
        current_data[:content] << extract_question_block(element, count)
        count += 1
      end
    end

    data << current_data unless current_data.empty?
    data
  end

  def extract_question_block(element, count)
    question = { type: 'pergunta', value: element.text, id: count }
    verse_element = element.next_element
    note_element = verse_element&.next_element&.next_element

    verse = extract_element_data(verse_element, 'verso_txt', 'verso', count) if verse_element
    note = extract_element_data(note_element, 'nota_txt', 'nota', count) if note_element

    { question:, verse:, note: }
  end

  def extract_element_data(element, expected_id, type, count)
    return unless element['id'] == expected_id

    { type:, value: element.text, question_id: count }
  end

  def header_body
    p 'extracting header body...'
    [
      {
        type: 'verso_aurelio',
        value: @page.at_css('#licao_va').text
      },
      {
        type: 'leitura',
        value: @page.at_css('#licao_leitura').text
      },
      {
        type: 'estudo',
        value: @page.at_css('#licao_estudo').text
      }
    ]
  end
end
