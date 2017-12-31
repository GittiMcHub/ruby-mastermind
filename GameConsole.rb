#
#
# Diese Klasse Koordiniert das Spiel
#

require_relative "GameConsolePrinter"
require_relative "Game"
require_relative "CodebreakerHuman"
require_relative "CodebreakerKI"
require_relative "CodemakerHuman"
require_relative "CodemakerKI"
require_relative "RuleViolationError"

class GameConsole
  include GameConsolePrinter
  
  def initialize(game)
    @game = game
    GameConsolePrinter.clear_console()
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
          GameConsolePrinter.clear_console()
          GameConsolePrinter.print_game_field(@game)
          guess()
        end
      when "help"
        print_help()
      when "surrender"
        GameConsolePrinter.clear_console()
        GameConsolePrinter.print_game_field(@game)
        @game.surrender()
      when "display"
        GameConsolePrinter.clear_console()
        GameConsolePrinter.print_game_field(@game)
      when "clear"
        GameConsolePrinter.clear_console()
      when "rules"
        GameConsolePrinter.print_game_rules(@game)
      when "cheat"
        GameConsolePrinter.print_cheat(@game)
      when "exit"
        # Vorzeitig beenenden
        return
      else
        print_help()
      end

    end

    # Wenn das spiel vorbei ist, beendet sich die Endlosschleife und es wird ausgewertet, wer gewonnen hat
    GameConsolePrinter.clear_console()
    GameConsolePrinter.print_game_field(@game)
    puts "\nThe code was: #{@game.code.to_s()}\n\n"

    # Pruefen, ob der Breaker gewonnen hat
    if @game.won?
      # Cheater bekommen ein anderes Logo ausgespielt
      @game.cheated?() ? GameConsolePrinter.print_blame() : GameConsolePrinter.print_thumb_up()
      puts " #{@game.player_breaker.to_s().upcase()} is a GENIUS! \\o/ "
    else
      # Cheater bekommen ein anderes Logo ausgespielt
      @game.cheated?() ? GameConsolePrinter.print_blame() : GameConsolePrinter.print_thumb_down()
      puts " #{@game.player_breaker.to_s().upcase()} is a LOOSER! :( - #{@game.player_maker.to_s().upcase()} is your Master!\n"
    end

    puts "\n\nPress ENTER to go back to main menu..."
    gets.chomp()
    return
  end

  # Methode die das erraten steuert
  def guess()

    # Hier gibt es keine While Schleife, damit der Benutzer die Moeglichkeit hat, zwischendurch das Cheat Kommando auszufuerehn
    # und dadurch in eine andere Methode zu springen
    begin
      puts "\nYou have #{@game.turns_left} turns left\n\n"
      turn = @game.do_turn(@game.player_breaker.guess(@game))
      puts "\nReturned #{turn.to_s()} "

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
        GameConsolePrinter.clear_console()
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

  # Zeigt eine Auflist ung der moeglichen Kommandos
  def print_help()
    puts "--------------------------------------"
    puts "Use the following commands"
    puts "--------------------------------------"
    puts "HELP\t\tDisplays this message"
    puts "CLEAR\t\tClears the console"
    puts "DISPLAY\t\tClears the console and shows all Turns"
    puts "SURRENDER\tSurrender the game"
    puts "RULES\t\tDisplay current Rules"
    puts "CHEAT\t\tDisplays a code with blackhit"
    puts "EXIT\t\tBack to main menu"

    puts "\nCurrent status: #{@game.next_action} a code. Just press Enter to get prompted"
    return self
  end

end