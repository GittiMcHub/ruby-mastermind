#
# Captain Random fuehrt nur Zufaellige Zuege aus...
#

require_relative "Player"
require_relative "Game"
require_relative "Turn"

class CodebreakerKIRandom < Player
  def initialize(name)
    super(name)
    @possible_turns = []
  end

  #
  # Captain Random
  #

  def guess(game)
    turn = nil

    # Wenn die moeglichen Kombinationen noch nicht berechnet wurden
    if @possible_turns.empty?
      @possible_turns = generate_all_possible_turns(game.setting_code_length, game.setting_code_range)
    end

    turn_index = rand(0..(@possible_turns.size() -1))
    turn = Turn.new(@possible_turns[turn_index])
    # Den Zug aus den Moeglichkeiten fuer die naechste Runde entfernen
    @possible_turns.delete(turn.code)

    puts ""
    case turn.code[0]
    when 1
      print "Ahoy, Matey!"
    when 2
      print "Gimme the treasure! I'll give you"
    when 3
      print "I'm looking for that booty!"
    when 4
      print "Savvy? I said"
    when 5
      print "Aaaarrrrgggghhhh!"
    when 6
      print "Blimey!"
    end

    print " #{turn.code.to_s()}\n"

    return turn
  end

  def generate_all_possible_turns(length, range)

    ary = range.to_a()
    repeated_permutation = ary.repeated_permutation(length).to_a

    return repeated_permutation
  end

end