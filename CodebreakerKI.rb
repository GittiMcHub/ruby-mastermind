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

    puts "#####################################################"
    puts "DEBUG: possible turns:\n#{@possible_turns.to_s()}"
    
    # Wenn noch kein Zug gemacht wurde, einen Zufaelligen aussuchen
    if !game.turns.empty?
      # Es wurde bereits ein Zug gemacht und daher muss ein Ergebnis vorliegen.
      # Jetzt werden die Unmoeglichen Codes entfernt

      working_set = @possible_turns.clone()
      last_turn = game.turns.last

      # Falls keine Zahl vorkam, alle entfernen die diese ziffern enthalten
      # Also: Wenn der letzte Zug das Ergebnis: WH = 0 und BH = 0 hatte, dann kann keine der Ziffern, Teil der Loesung sein
      if (last_turn.white_hits == 0 && last_turn.black_hits == 0)
        puts "DEBUG: no hits!"
        #Dafuer jede Moeglichkeit durchgehen
        @possible_turns.each do | one_possible_code |

          # Und pruefen ob einer der Ziffern im letzten Zug vorkam. Falls ja, ganze Moeglichkeit entfernen
          one_possible_code.each do |value|
            if last_turn.code.include?(value)
              puts "Removing #{one_possible_code.to_s} because it's simlar to #{last_turn.code.to_s()}"
              working_set.delete(one_possible_code)
              break
            end
          end # Ziffern abgeglichen

        end # Moeglichkeiten durchsucht
      end # Alle entfernt, die mindestens eine Ziffer enthielten (da WH = 0 und BH = 0)

      # Zweite Block:
      # Falls mindestens ein Hit, dann alle Codes entfernen, die nicht mehr in Frage kommen
      if (last_turn.white_hits + last_turn.black_hits) > 0
        puts "DEBUG: Hits: #{(last_turn.white_hits + last_turn.black_hits)}"
        @possible_turns.each do | one_possible_code |
          # Jeden Durchgehen
          counter = 0
          one_possible_code.each do |value|
            if last_turn.code.include?(value)
              counter +=1
            end
          end
          
          if counter < (last_turn.white_hits + last_turn.black_hits)
            puts "Deleting #{one_possible_code.to_s()} because it's not simlar to #{last_turn.code.to_s()}"
            working_set.delete(one_possible_code)
          end
          
        end
      @possible_turns = working_set  
    
      puts "-----------------------------------------------------"
      puts "DEBUG: Possibilities left:\n#{@possible_turns.to_s()}"
      
      end

    end

    turn_index = rand(0..(@possible_turns.size() -1))
    turn = Turn.new(@possible_turns[turn_index])
    # Den Zug aus den Moeglichkeiten fuer die naechste Runde entfernen
    @possible_turns.delete(turn.code)
    
    puts "DEBUG: choosing: #{turn.to_s()}"
    
    return turn
  end

  
  def generate_all_possible_turns(length, range)

    ary = range.to_a()
    repeated_permutation = ary.repeated_permutation(length).to_a

    return repeated_permutation
  end

end