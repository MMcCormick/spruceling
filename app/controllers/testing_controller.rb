class TestingController < ApplicationController

  def test
    ThredupData.fetch_item('http://www.thredup.com/items/346634-OshKosh-Bgosh-jean-shorts-2T')
    foo = 'bar'
  end
end
