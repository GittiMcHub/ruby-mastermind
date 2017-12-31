#
# Klasse des Codebreakers
# Im speziellen ein Menschlicher Spieler
# Sobald dieser aufgefordert wird den Code zu erraten, wird User Input angefordert
#
require_relative "Turn"

class CodebreakerHuman < Player
  
  def initialize(name)
    @name = name
  end
  
  # Der Input mus komma Separiert kommen
  # z.b: 1,2,3
  def guess(game)
    print "Please insert code comma separated: "
    input = gets.chomp()
       
    code_array = input.split(',')
       
    for i in 0..(code_array.length() - 1)
      code_array[i] = code_array[i].to_i
    end
       
    turn = Turn.new(code_array)
       
    return turn
  end
  
end