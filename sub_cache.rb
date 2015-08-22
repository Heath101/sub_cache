require 'delegate'

class SubCache < Delegator
  attr_reader :cache_id

  def initialize(cache_id, parent)
    @cache_id = cache_id
    @parent = parent
  end

  def store
    @store ||= {}
  end

  def store=(cache_store)
    @store = cache_store
  end

  def read(key)
    store.fetch(key.to_s, nil)
  end

  def write(key, value)
    store.store(key.to_s, value)
    parent.write(cache_id, store)
  end

  def clear
    super
    parent.clear(cache_id)
  end

  def __getobj__
    store
  end 

  def __setobj__(obj)
  end

private
  attr_reader :parent

end