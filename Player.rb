class Player
  
  def initialize(name, role)
    raise TypeError, 'Name is not a String' unless name.is_a? String
    raise TypeError, 'Role is not a String' unless name.is_a? String
    raise ArgumentError, 'Role is not MAKER or BRAKER' unless (role == "MAKER" || roler == "BREAKER")
    
    @name = name
    @role = role
  end
  
  def doTurn()
    raise NotImplementedError, 'Player Object needs doTurn() method'
  end
  
  
end