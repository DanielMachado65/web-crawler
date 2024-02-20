# config.ru

require_relative 'boot'

# Utilizar a chave secreta com um middleware de cookie de sessão
use Rack::Session::Cookie, secret: File.read('.session.key'), same_site: :strict, max_age: 86_400

# Configuração básica de autenticação para o Sidekiq Web
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  user == 'admin' && password == 'secret'
end

# Mapeamento de URL
run Rack::URLMap.new(
  '/' => App,
  '/sidekiq' => Sidekiq::Web
)
