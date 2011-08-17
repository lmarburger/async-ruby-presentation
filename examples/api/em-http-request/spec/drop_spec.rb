require 'helper'
require 'drop'

describe Drop do

  # Stolen from em-http-request's specs
  def failed
    EM.stop
    deny { 'fail' }
  end

  describe '.find' do
    it 'finds a bookmark' do
      EM.run do
        VCR.use_cassette 'bookmark' do
          drop = Drop.find '5kXC'

          drop.errback { failed }
          drop.callback do
            assert { drop.is_a? Drop }
            assert { drop.href         == 'http://my.cl.ly/items/4268562' }
            assert { drop.redirect_url == 'http://getcloudapp.com/download' }
            assert { drop.remote_url.nil? }

            EM.stop
          end
        end
      end
    end

    it 'finds a image' do
      EM.run do
        VCR.use_cassette 'image' do
          drop = Drop.find '9KXp'

          drop.errback { failed }
          drop.callback do
            assert { drop.is_a? Drop }
            assert { drop.href       == 'http://my.cl.ly/items/8462162' }
            assert { drop.remote_url == 'http://f.cl.ly/items/2m1n1x2W132C0C0s2C2X/cover.jpg'}
            assert { drop.redirect_url.nil? }

            EM.stop
          end
        end
      end
    end

    it 'fails when finding a nonexistent drop' do
      failed = :not_failed

      EM.run do
        VCR.use_cassette 'nonexistent' do
          drop = Drop.find 'hhgttg'

          drop.callback { failed }
          drop.errback do
            failed = :failed
            EM.stop
          end
        end
      end

      assert { failed == :failed }
    end
  end

end
