require 'delegate'
require 'rspec'

class SubCache < Delegator
  attr_reader :parent_key, :parent_cache

  def initialize(parent_key, parent_cache)
    @cache = {}
    @parent_key = parent_key
    @parent_cache = parent_cache
  end

  def read(key)
    @cache.fetch(key, nil)
  end

  def write(key, value)
    @cache.store(key, value)
  end

  def __getobj__
    @cache
  end 

  def __setobj__(obj)
    @cache = obj
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

  describe :read do
    it 'returns nil when key does not exist' do
      expect(subject.read('non_existant_key')).to eq nil
    end

    it 'returns a value for the given key' do
      subject.__setobj__({ 'my_key' => 'my_value' })
      expect(subject.read('my_key')).to eq 'my_value'
    end
  end

  describe :write do
    it 'saves a value in the cache' do
      subject.write('key','value')
      expect(subject.read('key')).to eq 'value'
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