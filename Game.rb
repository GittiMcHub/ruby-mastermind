class Game
  
  def initialize(setting_codelength, setting_turns, player_maker, player_breaker)
    raise TypeError, 'Codelength needs to be an Integer' unless setting_codelength.is_a? Integer
    raise TypeError, 'Turns needs to be an Integer' unless setting_turns.is_a? Integer
    raise TypeError, 'Given Argument is not a Player object' unless player_maker.is_a? Player
    raise TypeError, 'Given Argument is not a Player object' unless player_breaker.is_a? Player
    
    @setting_codelength = setting_codelength
    @setting_turns = setting_turns
    @made_turns = []
    @code = nil
    @player_maker = player_maker
    @player_breaker = player_breaker
       
  end
  
  def turns()
    return @made_turns.clone()
  end
  
  # TODO: return a hint 
  def give_hint()
    
    
    return # a Turn
  end
  
  # TODO: check code + rules
  def valid_code(code)
    return true
  end
  
  # TODO: check code + rules
  def analyze_turn(turn)
    return true
  end
  
  def game_finished?()
    return (@made_turns.size() >= @setting_turns)
  end
  
    
end