#
# 
# Diese Klasse Koordiniert das Spiel
#

require_relative "Game"
require_relative "CodebreakerHuman"
require_relative "CodebreakerKI"
require_relative "CodemakerHuman"
require_relative "CodemakerKI"
require_relative "RuleViolationError"

class GameController
  def initialize(game)
    @game = game

    control()

  end

  # Control() kuemmert sich um den Spieler Input
  # Standardmaessig wird die Aktion ausgefuehrt, die das Spiel als naechstes erwartet
  # Der benutzer hat aber die Möglichkeit durch die Eingabe von "cheat"
  # sich einen Hilfreichen Hinweis vom Spiel zu holen
  def control()
    while !@game.finished?()

      puts "What to do next? Press Enter to continue..."
      input = gets.chomp()

      # Durch reines Enter druecken bestimmt das Spiel die naechste Aktion
      # Weitere Möglichkeiten wären "cheat" und sich alle zuege nacheinander anzeigen zu lassen
      case input
      when nil || "" || " "
        # Hier bestimmt das Spiel, was als naechstes passiert
        case @game.next_action()
          when "make"
            make()
          when "guess" 
            guess()
          when "finished"    
        end
      when "cheat"
        puts "not implemented"
      end

    end
    # Wenn das spiel vorbei ist, beendet sich die Endlosschleife und es wird ausgewertet, wer gewonnen hat
    
    #TODO: Spielernamen einbauen
    puts "The code was: #{@game.code.to_s()}"
    if @game.won?
      puts "The Codebreaker is a GENIUS! \\o/ "
    else 
      puts "The Codebreaker is a LOOSER! :( - Codemaker is just too good! "
    end
    
  end

  # Methode die das erraten steuert
  def guess()

    # Hier gibt es keine While Schleife, damit der Benutzer die Moeglichkeit hat, zwischendurch das Cheat Kommando auszufuerehn
    # und dadurch in eine andere Methode zu springen
    begin
      puts "You have #{@game.turns_left} turns left"
      turn = @game.analyze_turn(@game.player_breaker.guess())
      puts "Returned #{turn.to_s()} "

    rescue TypeError, RuleViolationError => err
      # Anzeigen des Problems
      puts "########################################"
      puts "Ups! #{err}"
      puts "########################################"
    end

  end

  
  # Methode, die das Code erstellen steuert
  def make()

    # Solange der Code nicht gesetzt ist, den Codemaker dazu auffordern
    while !@game.code_is_set?()

      begin
        puts "Hey Codemaker! It's your turn!"

        turn = @game.player_maker.create_code(@game)

        @game.set_code(turn)

      rescue TypeError, RuleViolationError => err
        # Anzeigen des Problems
        puts "########################################"
        puts "Ups! #{err}"
        puts "########################################"
      end

    end

    
    #system "clear" or system "cls"
    puts "The Code is set!"
    return self
  end

end