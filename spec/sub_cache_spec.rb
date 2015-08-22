require_relative '../sub_cache'

describe SubCache do
  subject { SubCache.new('ID123', parent) }
  let(:parent) { double(persist: nil, clear: nil)}

  describe :new do

    it 'sets the cache_id attribute' do
      expect(subject.cache_id).to eq 'ID123'
    end

    it 'sets the parent_cache attribute' do
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

    it 'treats string keys and symbol keys as the same key' do
      subject.__setobj__({ 'my_key' => 'my_value' })
      expect(subject.read(:my_key)).to eq 'my_value'
    end
  end

  describe :write do
    it 'saves a value in the cache' do
      subject.write('my_key','my_value')
      expect(subject.read('my_key')).to eq 'my_value'
    end

    it 'converts symbol keys to strings' do
      subject.write(:my_key, 'my_value')
      expect(subject.__getobj__['my_key']).to eq 'my_value'
    end

    it 'sends message to parent cache to save' do
      parent = double
      cache = SubCache.new('123',parent)
      expect(parent).to receive(:persist).with('123', cache.__getobj__)
      cache.write('my_key','my_value')
    end
  end

  describe :clear do
    it 'clears the cache' do
      subject.__setobj__({'my_key' => 'my_val'})
      subject.clear
      expect(subject.read('my_key')).to eq nil
    end

    it 'removes itself from the parent cache' do
      subject.__setobj__({'my_key' => 'my_val'})
      expect(parent).to receive(:clear).with('ID123')
      subject.clear
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