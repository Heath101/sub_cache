require 'delegate'
require 'rspec'

class SubCache < Delegator

  def initialize
    @store = {}
  end

  def __getobj__
    @store
  end 

  def __setobj__(obj)
    @store = obj
  end

end


describe SubCache do

  describe :__getobj__ do
    it 'is defined' do
      expect{SubCache.new.__getobj__}.not_to raise_error
    end
  end

  describe :__setobj__ do
    it 'is defined' do
      expect{SubCache.new.__setobj__(double)}.not_to raise_error
    end

    it 'sets the delegate object' do
      delegate = {}
      cache = SubCache.new
      cache.__setobj__(delegate)
      expect(cache.__getobj__).to eq delegate
    end
  end
end