class CodebreakerKIRandom
  def initialize(name)
    @name = name
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

    puts "DEBUG: choosing: #{turn.code.to_s()}"

    return turn
  end

  
  
  def generate_all_possible_turns(length, range)

    ary = range.to_a()
    repeated_permutation = ary.repeated_permutation(length).to_a

    return repeated_permutation
  end

end