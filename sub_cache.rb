require 'delegate'
require 'rspec'

class SubCache < Delegator
  attr_reader :parent_key, :parent_cache

  def initialize(parent_key, parent_cache)
    @store = {}
    @parent_key = parent_key
    @parent_cache = parent_cache
  end

  def __getobj__
    @store
  end 

  def __setobj__(obj)
    @store = obj
  end

end


describe SubCache do
  subject { SubCache.new('ID123', double) }

  describe :new do

    it 'sets the parent_key attribute' do
      expect(subject.parent_key).to eq 'ID123'
    end

    it 'sets the parent_cache' do
      parent = double
      cache = SubCache.new('ID123', parent)
      expect(cache.parent_cache).to eq parent
    end
  end

  describe :__getobj__ do
    it 'is defined' do
      expect{subject.__getobj__}.not_to raise_error
    end
  end

  describe :__setobj__ do
    it 'is defined' do
      expect{subject.__setobj__(double)}.not_to raise_error
    end

    it 'sets the delegate object' do
      delegate = {}
      subject.__setobj__(delegate)
      expect(subject.__getobj__).to eq delegate
    end
  end
end