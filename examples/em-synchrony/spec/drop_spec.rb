require 'helper'
require 'drop'

describe Drop do

  describe '.find' do
    it 'finds a bookmark' do
      EM.synchrony do
        VCR.use_cassette 'bookmark' do
          drop = Drop.find '5kXC'
          EM.stop

          assert { drop.is_a? Drop }
          assert { drop.href         == 'http://my.cl.ly/items/4268562' }
          assert { drop.redirect_url == 'http://getcloudapp.com/download' }
          assert { drop.remote_url.nil? }
        end
      end
    end

    it 'finds a image' do
      EM.synchrony do
        VCR.use_cassette 'image' do
          drop = Drop.find '9KXp'
          EM.stop

          assert { drop.is_a? Drop }
          assert { drop.href       == 'http://my.cl.ly/items/8462162' }
          assert { drop.remote_url == 'http://f.cl.ly/items/2m1n1x2W132C0C0s2C2X/cover.jpg'}
          assert { drop.redirect_url.nil? }
        end
      end
    end

    it 'raises a DropNotFound error' do
      EM.synchrony do
        VCR.use_cassette 'nonexistent' do
          assert { rescuing { Drop.find('hhgttg') }.is_a? Drop::NotFound }

          EM.stop
        end
      end
    end
  end

end
