require_relative '../sub_cache'

describe SubCache do
  subject { SubCache.new('ID123', parent) }
  let(:parent) { double(write: nil)}

  describe :new do

    it 'sets the parent_key attribute' do
      expect(subject.parent_key).to eq 'ID123'
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

    it 'updates parent cache with serialized version of cache' do
      parent = double
      cache = SubCache.new('123',parent)
      expect(parent).to receive(:write).with('123', "\x04\b{\x06I\"\vmy_key\x06:\x06EFI\"\rmy_value\x06;\x00F")
      cache.write('my_key','my_value')
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