#
#  Diese Klasse spiegelt einen Codemaker im Mastermindgame wieder
#  Diese KI erzeugt mithilfe der Rand funktion einen zufaelligen code 
#

require_relative "Player"
require_relative "Game"
require_relative "Turn"

class CodemakerKI < Player
  
  def initialize(name)
    super(name)
  end
  
  # Zufalliges erzeugen eines Code
  # Das Game wird als parameter uebergeben, da es die Spielregeln kennt
  def create_code(game)
    
    random_code = []
    
    for i in 1..(game.setting_code_length)
      random_code.push(rand(game.setting_code_range))
    end
    
    return Turn.new(random_code)
    
  end
  
end