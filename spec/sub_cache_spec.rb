require_relative '../sub_cache'
require_relative '../hash_store'

describe SubCache do
  let(:parent) { double(write: nil, clear: nil) }
  let(:store)  { HashStore.new }
  let(:cache)  { SubCache.new('ID123', parent, store) }

  describe :new do
    it 'sets the cache_id attribute' do
      expect(cache.cache_id).to eq 'ID123'
    end
  end

  describe :read do
    it 'returns the cache value for a given key' do
      # store = double(read: 'my_value')
      # sub_cache = SubCache.new('ID123', parent, store)
      
      expect(sub_cache.read('my_key')).to eq 'my_value'
    end
  end

  describe :write do

    it 'saves a value in the cache' do
      cache.write('my_key', 'my_value')
      expect(cache.read('my_key')).to eq 'my_value'
    end

    it 'converts symbol keys to strings' do
      cache.write(:my_key, 'my_value')
      expect(cache.read('my_key')).to eq 'my_value'
    end

    it 'sends message to parent cache to save' do
      expect(parent).to receive(:write).with('ID123', cache.store)
      cache.write('my_key','my_value')
    end
  end

  describe :clear do

    it 'clears the cache' do
      cache.write 'my_key', 'my_val'
      cache.clear
      expect(cache.read('my_key')).to eq nil
    end

    it 'removes itself from the parent cache' do
      expect(parent).to receive(:clear).with('ID123')
      cache.clear
    end
  end

  describe :__getobj__ do
    it 'is defined' do
      expect{cache.__getobj__}.not_to raise_error
    end
  end

  describe :__setobj__ do
    it 'is defined' do
      expect{cache.__setobj__(double)}.not_to raise_error
    end
  end
end

describe :HashStore do
  let(:store) { HashStore.new }

  it 'is a specialization of Hash' do
    expect(HashStore.ancestors).to include(Hash)
  end

  describe :read do
    it 'returns nil when key does not exist' do
      expect(store.read('non_existant_key')).to eq nil
    end

    it 'returns a value for the given key' do
      store['my_key'] = 'my_value'
      expect(store.read('my_key')).to eq 'my_value'
    end

    it 'treats string keys and symbol keys as the same key' do
      store['my_key'] = 'my_value'
      expect(store.read(:my_key)).to eq 'my_value'
    end
  end
end