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

      puts ""
      puts "Press ENTER to continue... (or type HELP for more)"
      input = gets.chomp()

      # Durch reines Enter druecken bestimmt das Spiel die naechste Aktion
      # Weitere Möglichkeiten wären "cheat" und sich alle zuege nacheinander anzeigen zu lassen
      case input.downcase
      when nil || "" || " " || "enter"
        # Hier bestimmt das Spiel, was als naechstes passiert
        case @game.next_action()
        when "make"
          make()
        when "guess"
          print_game()
          guess()
        end
      when "help"
        print_help()
      when "surrender"
        print_game()
        @game.surrender()
      when "display"
        print_game()
      when "clear"
        clear_console()
      when "cheat"
        print_cheat()
      else
        print_help()
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
      turn = @game.do_turn(@game.player_breaker.guess(@game))
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
        clear_console()
        puts "The Code is set!"
      rescue TypeError, RuleViolationError => err
        # Anzeigen des Problems
        puts "########################################"
        puts "Ups! #{err}"
        puts "########################################"
      end

    end

    return self
  end

  # Fuehrt die Cheat Methode aus. Gibt einen Sinnvollen naechsten Zug aus, ohne dabei einen Zug des Breakers zu verbrauchen
  def print_cheat()
    puts @game.cheat().to_s()
    return self
  end

  # Loescht den Konsolen Inhalt
  def clear_console()
    system "clear" or system "cls"
    return self
  end

  # Loescht den Konsoleninhalt und gibt das Spielfeld aus
  def print_game()
    clear_console()
    
    crypt_code = Array.new(@game.setting_code_length) { "*" }
    puts "#{crypt_code.to_s().gsub("\"","")}"
    @game.turns.each do |turn|
      puts turn.to_s()
    end
    return self
  end

  def print_help()
    puts "--------------------------------------"
    puts "Use the following commands"
    puts "--------------------------------------"
    puts "HELP\t\tDisplays this message"
    puts "CLEAR\t\tClear the console"
    puts "DISPLAY\t\tClears the console and shows all Turns"
    puts "SURRENDER\tSurrender the game"

    puts "\nCurrent status: #{@game.next_action} a code. Just press Enter to get prompted"
    return self
  end

end