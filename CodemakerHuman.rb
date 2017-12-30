#
# Klasse des Codemakers
# Im speziellen ein Menschlicher Spieler
# Sobald dieser aufgefordert wird ein Code zu erstellen, wird User Input angefordert
#


require_relative "Player"
require_relative "Game"
require_relative "Turn"

class CodemakerHuman < Player
  
  def initialize(name)
    super(name)
  end
  
  # Das Spiel wird uebergeben, da es die Regeln uber den Code enthaelt
  # Der Input mus komma Separiert kommen
    # z.b: 1,2,3
  def create_code(game)
    
    puts "The rules are:"
    puts "\tCode range: #{game.setting_code_range.to_s()}"
    puts "\tCode length: #{game.setting_code_length.to_s()}"

    print "Please insert code comma separated: "
    input = gets.chomp()
    
    code_array = input.split(',')
    
    for i in 0..(code_array.length() - 1)
      code_array[i] = code_array[i].to_i
    end
    
    return Turn.new(code_array)
  end
  
end