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
  
  def turns()
    return @made_turns.clone()
  end
  
  
  # TODO: check code + rules
  def valid_code(code)
    return true
  end
  
  # TODO: check code + rules
  def analyze_turn(turn)
    return true
  end
  
  def game_finished()
    return (@made_turns.size() >= @setting_turns)
  end
  
    
   def start()
     while(@code == nil)
       puts "Please define a code, Codemaker"
       turn = player_maker.do_turn()
       
       if(valid_code(turn.code()))
         @code = turn.code()
       end
       
     end
     
     while(!game_finished())
       puts "It's your turn, Codebreaker"
       turn = player_breaker.do_turn()
       
       if(analyze_turn(turn))
         @made_turns.push(turn)
       end
       
     end
     
     
   end
  
end