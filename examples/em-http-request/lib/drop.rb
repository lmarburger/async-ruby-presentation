require 'em-http-request'
require 'ostruct'
require 'yajl'

class Drop < OpenStruct
  include EM::Deferrable

  def self.find(slug)
    drop = Drop.new

    http = EM::HttpRequest.new("http://api.cld.me/#{ slug }").
                           get(:head => { 'Accept'=> 'application/json' })

    http.errback { drop.fail }
    http.callback do
      if http.response_header.status == 200
        drop.load Yajl::Parser.parse(http.response)
        drop.succeed
      else
        drop.fail
      end
    end

    drop
  end

  def load(attributes)
    attributes_with_symbolized_keys = attributes.map do |key, value|
      [ key.to_sym, value ]
    end

    marshal_load Hash[attributes_with_symbolized_keys]
  end

end
