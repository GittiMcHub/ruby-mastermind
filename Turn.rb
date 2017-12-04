class Turn
  
  
  def initialize(codes)
    raise TypeError, 'codes needs to be an Array' unless codes.is_a? Array
    @code = codes
  end
  
  def code()
    return @code.clone()
  end

end