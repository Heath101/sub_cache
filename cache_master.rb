
class CacheMaster

  # def initialize(cache)
  #   @@cache = cache
  #   @@serializer = Marshal
  # end

  # def self.sub_cache_for(cache_id)
  #   existing_cache = Marshal.load(@@cache.read(cache_id))
  #   subCache = SubCache.new(cache_id, self)
  #   subCache.cache = existing_cache
  #   subCache
  # end

  # def self.persist(sub_cache)
  #   key = sub_cache.cache_id
  #   value = Marshal.dump(sub_cache.__getobj__)
  #   cache.write(key, value)
  # end
end