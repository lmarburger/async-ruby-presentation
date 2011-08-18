require 'helper'
require 'bookmark'

describe Bookmark do

  describe '.new' do
    it 'loads a bookmark' do
      bookmark = Bookmark.new 'hhgttg'

      assert { bookmark.slug == 'hhgttg' }
      assert { bookmark.url  == "http://en.wikipedia.org/wiki/The_Hitchhiker's_Guide_to_the_Galaxy" }
    end

    it 'returns a bookmark with slug and url' do
      bookmark = Bookmark.new 'goog', 'http://google.com'

      assert { bookmark.slug == 'goog' }
      assert { bookmark.url  == 'http://google.com' }
    end

    it 'raises a NotFound error' do
      assert do
        rescuing { Bookmark.new('larry') }.is_a? Bookmark::NotFound
      end
    end
  end

  describe '.all' do
    it 'finds all bookmarks' do
      bookmarks = Bookmark.all

      assert { bookmarks.size == 6 }
    end

    it 'returns bookmarks' do
      hhgttg = Bookmark.all.find { |bookmark| bookmark.slug == 'hhgttg' }

      assert { hhgttg.is_a? Bookmark }
    end
  end

end
