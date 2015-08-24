class HashStore < Hash
  alias_method :write, :store

  def read(key)
    fetch(key.to_s, nil)
  end

end