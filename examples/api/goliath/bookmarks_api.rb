require 'goliath'
require 'goliath/rack/templates'
require 'tilt'

require 'bookmark'

class BookmarksRenderer < Goliath::API
  include Goliath::Rack::Templates

  def response(env)
    [ 200, {}, erb(:index) ]
  end

private

  def bookmarks
    @bookmarks ||= Bookmark.all
  end

end

class BookmarkRenderer < Goliath::API
  include Goliath::Rack::Templates

  def response(env)
    [ 301,
      { 'Content-Type' => 'text/plain',
        'Location'     => bookmark.url },
      [ "You are being redirected to #{ bookmark.url }" ]
    ]
  rescue Bookmark::NotFound
    [ 404, {}, "Bookmark not found. :'(" ]
  end

private

  def bookmark
    @bookmark ||= Bookmark.new(params[:slug])
  end

end

class BookmarksAPI < Goliath::API

  map '/',      BookmarksRenderer
  map '/:slug', BookmarkRenderer

end
