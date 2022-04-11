LuckyCache.configure do |settings|
  settings.storage = LuckyCache::MemoryStore.new
  settings.default_duration = 1.week
end
