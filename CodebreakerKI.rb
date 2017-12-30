require_relative "Game"
require_relative "Turn"

class CodebreakerKI
  def initialize(name)
    @name = name
    @possible_turns = []
  end

  #
  # KI gewinnt mit ca. 71%
  #
  # TODO: Blackhits genauer auswerten, aktuell wird alles als Whitehit betrachetet

  def guess(game)
    turn = nil

    # Wenn die moeglichen Kombinationen noch nicht berechnet wurden
    if @possible_turns.empty?
      @possible_turns = generate_all_possible_turns(game.setting_code_length, game.setting_code_range)
    end

   
    # Wenn noch kein Zug gemacht wurde, einen Zufaelligen aussuchen
    if !game.turns.empty?
      # Es wurde bereits ein Zug gemacht und daher muss ein Ergebnis vorliegen.
      # Jetzt werden die Unmoeglichen Codes entfernt

      working_set = @possible_turns.clone()
      last_turn = game.turns.last

      # Falls keine Zahl vorkam, alle entfernen die diese ziffern enthalten
      # Also: Wenn der letzte Zug das Ergebnis: WH = 0 und BH = 0 hatte, dann kann keine der Ziffern, Teil der Loesung sein
      if last_turn.white_hits == 0 && last_turn.black_hits == 0
        puts "KI: Oh no! I can do better!"
        #Dafuer jede Moeglichkeit durchgehen
        @possible_turns.each do | one_possible_code |

          # Und pruefen ob einer der Ziffern im letzten Zug vorkam. Falls ja, ganze Moeglichkeit entfernen
          one_possible_code.each do |value|
            if last_turn.code.include?(value)
              working_set.delete(one_possible_code)
              break
            end
          end # Ziffern abgeglichen

        end # Moeglichkeiten durchsucht
        @possible_turns = working_set
      end # Alle entfernt, die mindestens eine Ziffer enthielten (da WH = 0 und BH = 0)

      # Zweite Block:
      # Falls mindestens ein Hit, dann alle Codes entfernen, die nicht mehr in Frage kommen
      if (last_turn.white_hits + last_turn.black_hits) > 0
        @possible_turns.each do | one_possible_code |
          # Jeden Durchgehen
          counter = 0
          one_possible_code.each do |value|
            if last_turn.code.include?(value)
              counter +=1
            end
          end

          # Wenn nicht genuegend treffer mit dieser Moeglichkeit moeglich sind, dann Diese entfernen
          if counter < (last_turn.white_hits + last_turn.black_hits)
            working_set.delete(one_possible_code)
          end

        end
        @possible_turns = working_set

      end

      
      # Jetzt die Blackhit auswertung vornhemen
      if( last_turn.black_hits > 0 )
        # Bei Blackhits sind deutlich weniger moeglichkeiten Uebrig, als bei white Hits, daher wird hier eine 
        # Liste mit den Restlichen erstellt
        remaining_possibilities = []

        # Wie bei der Allgemeinen Hit Verabrietung, alle Moeglichkeiten durchgehen
        @possible_turns.each do | possible |

          hitcount = 0
          possible.each_with_index do | value, index |
            if possible[index] == last_turn.code[index]
              hitcount += 1
            end
          end

          # Und nur die Speichern, bei denen die gleichen Blackhits moeglich waeren
          if hitcount >= last_turn.black_hits
            remaining_possibilities.push(possible)
          end
        end
        
        # Die moeglichen Zuege durch die verbleibenden moeglichen ersetzen
        @possible_turns = remaining_possibilities

      end

    end

    puts "KI: Sooo... I guess there are #{@possible_turns.size()} possibilities left...\n"

    turn_index = rand(0..(@possible_turns.size() -1))
    turn = Turn.new(@possible_turns[turn_index])
    # Den Zug aus den Moeglichkeiten fuer die naechste Runde entfernen
    @possible_turns.delete(turn.code)

    puts "KI: I'll try with: #{turn.code.to_s()}"

    return turn
  end


  def generate_all_possible_turns(length, range)

    ary = range.to_a()
    repeated_permutation = ary.repeated_permutation(length).to_a

    return repeated_permutation
  end

end