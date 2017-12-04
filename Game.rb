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
    
    self.start()
    
  end
    
   def start()
     
   end
  
end