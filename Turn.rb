class Turn
  
  
  def initialize(codes)
    raise TypeError, 'codes needs to be an Array' unless codes.is_a? Array
    @codes = codes
  end
  
  def codes()
    return @codes.clone()
  end

end