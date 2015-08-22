require 'active_support'
require 'pry'
require 'pry-debugger'

load "#{Dir.pwd}/sub_cache.rb"

parent = ActiveSupport::Cache::MemoryStore.new


sub_caches = 3.times.with_object([]) do |i, sub_caches|
	sub_caches << SubCache.new("ID#{i}", parent)
end

a, b, c = subcaches

binding.pry