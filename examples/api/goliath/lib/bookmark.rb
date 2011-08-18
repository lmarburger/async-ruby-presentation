class Bookmark

  class NotFound < StandardError; end

  @@bookmarks = {
    'hhgttg'   => "http://en.wikipedia.org/wiki/The_Hitchhiker's_Guide_to_the_Galaxy",
    'ford'     => 'http://en.wikipedia.org/wiki/Ford_Prefect_(character)',
    'arthur'   => 'http://en.wikipedia.org/wiki/Arthur_Dent',
    'zaphod'   => 'http://en.wikipedia.org/wiki/Zaphod_Beeblebrox',
    'trillian' => 'http://en.wikipedia.org/wiki/Trillian_(character)',
    'marvin'   => 'http://en.wikipedia.org/wiki/Marvin_the_Paranoid_Android' }

  attr_accessor :slug, :url

  def initialize(slug, url = nil)
    @slug = slug
    @url  = url || @@bookmarks.fetch(slug) { raise NotFound }
  end

  def self.all
    @@bookmarks.map do |slug, url|
      Bookmark.new slug, url
    end
  end

end
