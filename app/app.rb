# App main
class App < BaseController
  get '/' do
    'Health check'
  end

  post '/lessons/extract_all' do
    render do
      ExtractorAllAsyncJob.perform_async
      return [201, { message: 'Job scheduled' }.to_json]
    end
  end

  post '/lessons' do
    render do
      options = JSON.parse(request.body.read)
      if options['type'] == 'lastest'
        ExtractorAsyncJob.perform_async

        return [201, { message: 'Job scheduled' }.to_json]
      end
    end
  end

  get '/lessons' do
    render(meta: { total: Lesson.count }) do
      search_params = params.reject { |_k, v| v.empty? }

      lessons = if search_params.empty?
                  Lesson.limit(LIMIT)
                else
                  find_lessons(search_params).limit(LIMIT)
                end
      lessons
    end
  end

  get '/lessons/lastest' do
    render do
      Lesson.order_by(date: :desc).first
    end
  end

  get '/lessons/:id' do
    render do
      Lesson.find(params[:id])
    end
  end

  get '/lessons/:id/questions' do
    render(serializer_class_name: 'Question') do
      lesson = Lesson.find(params[:id])
      lesson.questions
    end
  end

  private

  def find_lessons(params)
    query = params.transform_values { |v| Regexp.new(v, Regexp::IGNORECASE) }
    Lesson.where(query)
  end
end
