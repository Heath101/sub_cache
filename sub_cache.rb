require 'delegate'

class SubCache < Delegator
  attr_reader :cache_id, :store

  def initialize(cache_id, parent, store=nil)
    @cache_id = cache_id
    @parent = parent
    @store = store || HashStore.new
  end

  def store=(cache_store)
    @store = cache_store
  end

  def read(key)
    store.read(key)
  end

  def write(key, value)
    store.write(key.to_s, value)
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
