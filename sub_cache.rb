require 'delegate'

class SubCache < Delegator
  attr_reader :cache_id, :parent_cache

  def initialize(cache_id, parent_cache)
    @cache = {}
    @cache_id = cache_id
    @parent_cache = parent_cache
  end

  def read(key)
    @cache.fetch(key.to_s, nil)
  end

  def write(key, value)
    @cache.store(key.to_s, value)
    parent_cache.persist(cache_id, @cache)
  end

  def clear
    super
    parent_cache.clear(cache_id)
  end

  def __getobj__
    @cache
  end 

  def __setobj__(obj)
    @cache = obj
  end
end