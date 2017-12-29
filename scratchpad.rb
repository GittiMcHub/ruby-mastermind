# [1,2,3,4]
# [1,1,1,1] BH 1

# [1,2,3,4]
# [1,1,3,3] BH 1

# Pattern
# [1,nil,nil,nil]
# [nil,nil,3,nil]

# z.B.:
# echter code       = [5,5,3,5]
# bei prev_code     = [1,2,3,4]
# bei current_code  = [1,1,3,3]
# blackhits         = 1

prev_code     = [1,2,3,4]
current_code  = [1,1,3,3]
blackhits = 2

# Pattern Liste
# bei dem Beispiel dann
#   [1  , nil, 3, nil],
#   [nil, nil, 3, nil]
#
pattern_list = []

# Die Anzahl der gleichen Treffer bestimmt die Anzahl der patterns
same_hit_counter = 0

# Hier wird gezaehlt, wie viele gleiche Treffer es gibt
# den aktuellen Code mit dem vorherigen vergleichen und den counter erhoehen
current_code.each_with_index do | value, index |
  if current_code[index] == prev_code[index]
    same_hit_counter += 1
  end
end

# Hilfscounter fuer die bereites gemachten treffer. Es duerfen nur genauso viele getroffen werden in einem pattern
# die der Anzahl der Blackhits entsprechen
hitcounter = 0
# Damit die breites gematchten pattern uebersprungen werden koennen
next_start_index = 0

(1..same_hit_counter).each do | num |
  # Das Zielpattern
  pattern = []

  # wieder den code pro ziffer durchgehen
  current_code.each_with_index do | value, index |

    # Wenn die aktuelle Ziffer an gleicher Stelle wie die, aus dem vorherigen code steht, und der index groesser dem start_index ist, dann 
    # Hitcounter erhoehen
    # startindex erhoeen, da die Ziffer bereits im pattern ist
    if current_code[index] == prev_code[index] && index >= next_start_index
      hitcounter += 1
      next_start_index = index

      # nur patterns aufnehmen, die gleiche anzahl an blackhits haben
      if hitcounter <= blackhits
        pattern[index] = value
      end
    else
      # Pattern mit nil auffuelen
      pattern[index] = nil
    end

  end
  # In die Patternliste aufnhemen
  pattern_list.push(pattern)
  # Hitcounter wieder zuruecksetzten
  hitcounter = 0
end

puts pattern_list.to_s





#
#
#hitcounter = 0
#pattern_hit_on_index = []
#pattern = []
#
#current_code.each_with_index do | value, index |
#  if current_code[index] == prev_code[index]
#    hitcounter += 1
#    pattern_hit_on_index.push(index)
#
#    if hitcounter == blackhits
#      pattern[index] = value
#    end
#  else
#    pattern[index] = nil
#  end
#  pattern_list.push
#end
#
#puts pattern.to_s















###########################

class CodebreakerKI
  def initialize(name)
    @name = name
    @possible_turns = []
  end

  #
  # DIESE KI KANN NIX !
  #
  # TODO: Blackhits genauer auswerten, aktuell wird alles als Whitehit betrachetet

  def guess(game)
    turn = nil

    # Wenn die moeglichen Kombinationen noch nicht berechnet wurden
    if @possible_turns.empty?
      @possible_turns = generate_all_possible_turns(game.setting_code_length, game.setting_code_range)
    end

    #puts "#####################################################"
    #puts "DEBUG: possible turns:\n#{@possible_turns.to_s()}"

    # Wenn noch kein Zug gemacht wurde, einen Zufaelligen aussuchen
    if !game.turns.empty?
      # Es wurde bereits ein Zug gemacht und daher muss ein Ergebnis vorliegen.
      # Jetzt werden die Unmoeglichen Codes entfernt

      working_set = @possible_turns.clone()
      last_turn = game.turns.last

      # Falls keine Zahl vorkam, alle entfernen die diese ziffern enthalten
      # Also: Wenn der letzte Zug das Ergebnis: WH = 0 und BH = 0 hatte, dann kann keine der Ziffern, Teil der Loesung sein
      if (last_turn.white_hits == 0 && last_turn.black_hits == 0)
        #puts "DEBUG: no hits!"
        #Dafuer jede Moeglichkeit durchgehen
        @possible_turns.each do | one_possible_code |

          # Und pruefen ob einer der Ziffern im letzten Zug vorkam. Falls ja, ganze Moeglichkeit entfernen
          one_possible_code.each do |value|
            if last_turn.code.include?(value)
              #puts "DEBUG: Removing #{one_possible_code.to_s} because it's simlar to #{last_turn.code.to_s()}"
              working_set.delete(one_possible_code)
              break
            end
          end # Ziffern abgeglichen

        end # Moeglichkeiten durchsucht
      end # Alle entfernt, die mindestens eine Ziffer enthielten (da WH = 0 und BH = 0)

      # Zweite Block:
      # Falls mindestens ein Hit, dann alle Codes entfernen, die nicht mehr in Frage kommen
      if (last_turn.white_hits + last_turn.black_hits) > 0
        #puts "DEBUG: Hits: #{(last_turn.white_hits + last_turn.black_hits)}"
        @possible_turns.each do | one_possible_code |
          # Jeden Durchgehen
          counter = 0
          one_possible_code.each do |value|
            if last_turn.code.include?(value)
              counter +=1
            end
          end

          if counter < (last_turn.white_hits + last_turn.black_hits)
            # puts "DEBUG: Deleting #{one_possible_code.to_s()} because it's not simlar to #{last_turn.code.to_s()}"
            working_set.delete(one_possible_code)
          end

        end
        @possible_turns = working_set

      end

      # Jetzt die Blackhit auswertung vornhemen
      # geht erst nach dem 2. zug
      prev_turn = game.turns[game.turns.size()-2]

      if game.turns.size() >= 2 && last_turn.black_hits > 0 && prev_turn.black_hits > 0

        #puts "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        puts "DEBUG: Blackhit analysis"
        # Neuen workingset erzeigen
        working_set = @possible_turns.clone()

        @possible_turns.each do | one_possible_code |
          if !code_matches_pattern?(one_possible_code, prev_turn.code(), last_turn.code(), last_turn.black_hits )
            #puts "DEBUG: #{one_possible_code.to_s()} does not match patterns -> REMOVING"
            working_set.delete(one_possible_code)
          end
        end

        # verringerte Anzahl an Moeglichkeiten zurueckschreiben
        @possible_turns = working_set
      end

    end

    #puts "-----------------------------------------------------"
    #puts "DEBUG: Possibilities left:\n#{@possible_turns.to_s()}"

    turn_index = rand(0..(@possible_turns.size() -1))
    turn = Turn.new(@possible_turns[turn_index])
    # Den Zug aus den Moeglichkeiten fuer die naechste Runde entfernen
    @possible_turns.delete(turn.code)

    puts "DEBUG: choosing: #{turn.code.to_s()}"

    return turn
  end

  def code_matches_pattern?(one_possible_code, prev_code, current_code, blackhits)

    pattern_list = generate_blackhit_pattern_list(prev_code, current_code, blackhits)

    match = true

    #puts "DEBUG: #{pattern_list.to_s()}"

    pattern_list.each do |pattern|

      #puts "DEBUG: Pattern is: #{pattern.to_s()}"
      #puts "DEBUG: Checking:   #{one_possible_code.to_s()}"
      pattern.each_with_index do | value, index |
        if one_possible_code[index] != pattern[index] && pattern[index] != nil
          #puts "DEBUG: Pattern value is #{pattern[index]} but Code value is #{one_possible_code[index]}"
          match = false
        end
      end
    end

    return match

  end

  def generate_blackhit_pattern_list(prev_code, current_code, blackhits)
    # z.B.:
    # bei prev_code     = [1,2,3,4]
    # bei current_code  = [1,1,3,3]
    # blackhits         = 2

    #prev_code     = [1,2,3,4]
    #current_code  = [1,1,3,3]
    #blackhits = 2

    # Pattern Liste
    # bei dem Beispiel dann
    #   [1  , nil, 3, nil],
    #   [nil, nil, 3, nil]
    #
    pattern_list = []

    # Die Anzahl der gleichen Treffer bestimmt die Anzahl der patterns
    same_hit_counter = 0

    # Hier wird gezaehlt, wie viele gleiche Treffer es gibt
    # den aktuellen Code mit dem vorherigen vergleichen und den counter erhoehen
    current_code.each_with_index do | value, index |
      if current_code[index] == prev_code[index]
        same_hit_counter += 1
      end
    end

    # Hilfscounter fuer die bereites gemachten treffer. Es duerfen nur genauso viele getroffen werden in einem pattern
    # die der Anzahl der Blackhits entsprechen
    hitcounter = 0
    # Damit die breites gematchten pattern uebersprungen werden koennen
    next_start_index = 0

    (1..same_hit_counter).each do | num |
      # Das Zielpattern
      pattern = []

      # wieder den code pro ziffer durchgehen
      current_code.each_with_index do | value, index |

        # Wenn die aktuelle Ziffer an gleicher Stelle wie die, aus dem vorherigen code steht, und der index groesser dem start_index ist, dann
        # Hitcounter erhoehen
        # startindex erhoeen, da die Ziffer bereits im pattern ist
        if current_code[index] == prev_code[index] && index >= next_start_index
          hitcounter += 1
          next_start_index = index

          # nur patterns aufnehmen, die gleiche anzahl an blackhits haben
          if hitcounter <= blackhits
            pattern[index] = value
          end
        else
          # Pattern mit nil auffuelen
          pattern[index] = nil
        end

      end
      # In die Patternliste aufnhemen
      pattern_list.push(pattern)
      # Hitcounter wieder zuruecksetzten
      hitcounter = 0
    end
    return pattern_list

  end

  def generate_all_possible_turns(length, range)

    ary = range.to_a()
    repeated_permutation = ary.repeated_permutation(length).to_a

    return repeated_permutation
  end

end