class Game
  
  def initialize(settingCodelength, settingTurns, playerMaker, playeBreaker)
    raise TypeError, 'Codelength needs to be an Interger' unless settingCodelength.is_a? Integer
    raise TypeError, 'Turns needs to be an Interger' unless settingTurns.is_a? Integer
    
    @settingCodelength = settingCodelength
    @settingTurns = settingTurns
    @madeTurns = []
    @code = nil
    
  end
  
  
end