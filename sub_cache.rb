require 'delegate'

class SubCache < Delegator
  attr_reader :parent_key, :parent_cache

  def initialize(parent_key, parent_cache)
    @cache = {}
    @parent_key = parent_key
    @parent_cache = parent_cache
  end

  def read(key)
    @cache.fetch(key.to_s, nil)
  end

  def write(key, value)
    @cache.store(key.to_s, value)
  end

  def __getobj__
    @cache
  end 

  def __setobj__(obj)
    @cache = obj
  end
end