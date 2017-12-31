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

class GameConsole
  def initialize(game)
    @game = game
    clear_console()
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
      when "rules"
        print_rules()
      when "cheat"
        print_cheat()
      when "exit"
        return
      else
        print_help()
      end

    end
    # Wenn das spiel vorbei ist, beendet sich die Endlosschleife und es wird ausgewertet, wer gewonnen hat

    #TODO: Spielernamen einbauen
    clear_console()
    print_game()
    puts "\nThe code was: #{@game.code.to_s()}\n\n"

    if @game.won?
      
      @game.cheated?() ? print_blame() : print_thumb_up()
      puts " #{@game.player_breaker.to_s().upcase()} is a GENIUS! \\o/ "

    else

      @game.cheated?() ? print_blame() : print_thumb_down()
      puts " #{@game.player_breaker.to_s().upcase()} is a LOOSER! :( - #{@game.player_maker.to_s().upcase()} is your Master!\n"
    end

    puts "\n\nPress ENTER to go back to main menu..."
    gets.chomp()

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

  # Gibt die Spielregeln aus
  def print_rules()
    puts "\tCode range:  #{@game.setting_code_range.to_s()}"
    puts "\tCode length: #{@game.setting_code_length.to_s()}"
    puts "\tBreak trys:  #{@game.setting_turns.to_s()}"
    return self
  end

  # Zeigt eine Auflistung der moeglichen Kommandos
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

  def print_thumb_up()
    puts "░░░░░░░░░░░░░░░░░░░░░░█████████"
    puts "░░███████░░░░░░░░░░███▒▒▒▒▒▒▒▒███"
    puts "░░█▒▒▒▒▒▒█░░░░░░░███▒▒▒▒▒▒▒▒▒▒▒▒▒███"
    puts "░░░█▒▒▒▒▒▒█░░░░██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██"
    puts "░░░░█▒▒▒▒▒█░░░██▒▒▒▒▒██▒▒▒▒▒▒██▒▒▒▒▒███"
    puts "░░░░░█▒▒▒█░░░█▒▒▒▒▒▒████▒▒▒▒████▒▒▒▒▒▒██"
    puts "░░░█████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██"
    puts "░░░█▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒██"
    puts "░██▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒██▒▒▒▒▒▒▒▒▒▒██▒▒▒▒██"
    puts "██▒▒▒███████████▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒▒██"
    puts "█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒████████▒▒▒▒▒▒▒██"
    puts "██▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██"
    puts "░█▒▒▒███████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██"
    puts "░██▒▒▒▒▒▒▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█"
    puts "░░████████████░░░█████████████████"
    puts ""
  end

  def print_thumb_down()
    puts "███████▄▄███████████▄"
    puts "▓▓▓▓▓▓█░░░░░░░░░░░░░░█"
    puts "▓▓▓▓▓▓█░░░░░░░░░░░░░░█"
    puts "▓▓▓▓▓▓█░░░░░░░░░░░░░░█"
    puts "▓▓▓▓▓▓█░░░░░░░░░░░░░░█"
    puts "▓▓▓▓▓▓█░░░░░░░░░░░░░░█"
    puts "▓▓▓▓▓▓███░░░░░░░░░░░░█"
    puts "██████▀░░░░░░░██████▀"
    puts "░░░░░░░░░█░░░░█"
    puts "░░░░░░░░░░█░░░█"
    puts "░░░░░░░░░░░█░░█"
    puts "░░░░░░░░░░░█░░█"
    puts "░░░░░░░░░░░░▀▀"
    puts ""
  end

  def print_blame()
    puts "░░▄▀░░░░░░░░░░░░░░░▀▀▄▄░░░░░ "
    puts "░░▄▀░░░░░░░░░░░░░░░░░░░░▀▄░░░"
    puts "░▄▀░░░░░░░░░░░░░░░░░░░░░░░█░░ "
    puts "░█░░░░░░░░░░░░░░░░░░░░░░░░░█░ "
    puts "▐░░░░░░░░░░░░░░░░░░░░░░░░░░░█ "
    puts "█░░░░▀▀▄▄▄▄░░░▄▌░░░░░░░░░░░░▐ "
    puts "▌░░░░░▌░░▀▀█▀▀░░░▄▄░░░░░░░▌░▐ "
    puts "▌░░░░░░▀▀▀▀░░░░░░▌░▀██▄▄▄▀░░▐ "
    puts "▌░░░░░░░░░░░░░░░░░▀▄▄▄▄▀░░░▄▌ "
    puts "▐░░░░▐░░░░░░░░░░░░░░░░░░░░▄▀░ "
    puts "░█░░░▌░░▌▀▀▀▄▄▄▄░░░░░░░░░▄▀░░ "
    puts "░░█░░▀░░░░░░░░░░▀▌░░▌░░░█░░░░ "
    puts "░░░▀▄░░░░░░░░░░░░░▄▀░░▄▀░░░░░ "
    puts "░░░░░▀▄▄▄░░░░░░░░░▄▄▀▀░░░░░░░ "
    puts "░░░░░░░░▐▌▀▀▀▀▀▀▀▀░░░░░░░░░░░ "
    puts "░░░░░░░░█░░░░░░░░░░░░░░░░░░░░ "
    puts "░░╔═╗╔═╗╔═╗░░░░░║░║╔═╗║░║░░░░ "
    puts "░░╠═╣╠╦╝╠╣░░░░░░╚╦╝║░║║░║░░░░ "
    puts "░░║░║║╚═╚═╝░░░░░░║░╚═╝╚═╝░░░░ "
    puts "║╔═░╦░╦═╗╦═╗╦╔╗║╔═╗░░╔╦╗╔═╗╔╗ "
    puts "╠╩╗░║░║░║║░║║║║║║═╗░░║║║╠╣░╔╝ "
    puts "║░╚░╩░╩═╝╩═╝╩║╚╝╚═╝░░║║║╚═╝▄░ "
    puts ""
  end
end