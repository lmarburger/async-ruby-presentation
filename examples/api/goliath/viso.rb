require 'goliath'
require 'goliath/rack/templates'
require 'tilt'

require_relative 'drop'

class DropRenderer < Goliath::API
  include Goliath::Rack::Templates  # render template files from ./views

  def response(env)
    [ 200, {}, erb(template) ]
  end

private

  def drop
    @drop ||= Drop.find(params[:slug])
  end

  def template
    drop.image? ? :image : :download
  end

end

class Viso < Goliath::API
  map '/' do
    run(Proc.new do |env|
      [ 301,
        { 'Content-Type' => 'text/plain',
          'Location'     => 'http://getcloudapp.com' },
        [ 'You are being redirected' ]
      ]
    end)
  end

  map '/:slug', DropRenderer

end
