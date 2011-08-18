require 'em-synchrony'
require 'em-synchrony/em-http'
require 'ostruct'
require 'yajl'

class Drop < OpenStruct

  class NotFound < StandardError; end

  def self.find(slug)
    request = EM::HttpRequest.new("http://api.cld.me/#{ slug }").
                              get(:head => { 'Accept'=> 'application/json' })

    raise NotFound unless request.response_header.status == 200

    Drop.new Yajl::Parser.parse(request.response)
  end

end
