class SparseArray
  def length
    if keys.any?
      keys.max + 1
    else
      0
    end
  end
  
  def serialize
    if keys.any?
      (0..(length-1)).map {|i| fetch i, 0 }
    else
      []
    end
  end
end

