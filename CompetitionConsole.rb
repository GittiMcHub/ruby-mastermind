#
# Eine Klasse fuer ein Competition Modus
#
# Dabei treten 3 Spieler an:
#   Der Codedmaker 
#   Der 1. Codebreaker
#   Der 2. Codebreaker
#
# Der Maker tritt gegegen beide Breaker an
# Zusaetzlich stehen Breaker 1 und Breaker 2 in Konkurrenz
#

require_relative "GameConsolePrinter"
require_relative "Game"
require_relative "CodebreakerHuman"
require_relative "CodebreakerKI"
require_relative "CodemakerHuman"
require_relative "CodemakerKI"
require_relative "RuleViolationError"

class CompetitionConsole
  include GameConsolePrinter
  def initialize(master, player1, player2)

    #Konsole loeschen
    GameConsolePrinter.clear_console()

    puts "Competition mode!"

    # Feste Competition Regeln
    @competition_code_length = 4
    @competition_code_range = 1..6
    @competition_turns = 10

    # Das erste Spiel instanzieren
    @game_one = Game.new(4, 1..6, 10, master, player1)

    # Solange bis ein Gueltiger Code gesetzt ist, den Master auffordern, ein zu erzeugen
    while(!@game_one.code_is_set?())
      begin
      
        print "Hey Master, choose the code: "
        # Hier wird ein Code erzeugt 
        @competition_turn = master.create_code(@game_one)
        @game_one.set_code(@competition_turn)

      rescue RuleViolationError => err
        puts "########################################"
        puts "Ups! #{err}"
        puts "########################################"
      end
    end

    # Bei einem menschlichen Master wird noch einmal der Code aussgegeben.
    # Nach ENTER ist Breaker 1 dran
    if(master.is_a? CodemakerHuman)
      puts "The code is: #{@competition_turn.code}"
      puts "Press ENTER to continue and let #{player1.name()} try..."
      input = gets.chomp()
    end

    # Das Spiel wird gespeielt
    @game_one = play(@game_one)

    # Sieg/Niederlage anezigen
    @game_one.won?() ? GameConsolePrinter.print_thumb_up() : GameConsolePrinter.print_thumb_down()

    puts "Press ENTER to continue..."
    input = gets.chomp()

    # Zweites Spiel - Herausforderer
    GameConsolePrinter.clear_console()
    puts "Game ONE finished! # You will have #{@game_one.turns.size()} turns to beat it"

    puts "Press ENTER to continue..."
    input = gets.chomp()

    # Hier wird das zweite Spiel mit dem Code vom Erseten erzeugt.
    # Da bereits oben auf ein Validen Code geprueft wird, ist das hier nicht mehr notwenig
    # ALLERDINGS bestimmt das erste Spiel, wie viele Zuege gemacht werden duerfen
    @game_two = Game.new(4, 1..6, @game_one.turns.size(), master, player2)
    @game_two.set_code(@competition_turn)

    # Das Spiel wird gespielt
    @game_two = play(@game_two)

    # Sieg/Niederlage anzeigen
    @game_two.won?() ? GameConsolePrinter.print_thumb_up() : GameConsolePrinter.print_thumb_down()

    puts "Press ENTER to continue..."
    input = gets.chomp()

    # Festlegen des Gewinners fuer die Siegerehrung
    winner = ""
    if !@game_one.won?() && !@game_two.won?()
      winner = master.to_s()
    end
    if @game_one.won?() && !@game_two.won?()
      winner = player1.to_s()
    end
    if @game_two.won?()
      winner = player2.to_s()
    end

    GameConsolePrinter.clear_console()

    puts "\tThe competition: #{@competition_turn.code()}"
    puts"********************************************************"
    puts"*___________.__                                        *"
    puts"*\\__    ___/|  |__   ____                              *"
    puts"*  |    |   |  |  \\_/ __ \\                             *"
    puts"*  |    |   |   Y  \\  ___/                             *"
    puts"*  |____|   |___|  /\\___  >                            *"
    puts"*                \\/     \\/                             *"
    puts"*           __      __.__                              *"
    puts"*          /  \\    /  \\__| ____   ____   ___________   *"
    puts"*          \\   \\/\\/   /  |/    \\ /    \\_/ __ \\_  __ \\  *"
    puts"*           \\        /|  |   |  \\   |  \\  ___/|  | \\/  *"
    puts"*            \\__/\\  / |__|___|  /___|  /\\___  >__|     *"
    puts"*                \\/          \\/     \\/     \\/          *"
    puts"*                                                      *"
    puts"      is #{winner}            "
    puts"********************************************************"

    puts "Press ENTER to  go back to main menu..."
    input = gets.chomp()
  end

  # Methode um das Spielen des Spiels zu kapseln
  def play(game)
    while !game.finished?()
      begin
        GameConsolePrinter.clear_console()
        GameConsolePrinter.print_game_field(game)

        puts "\nYou have #{game.turns_left} turns left\n\n"
        turn = game.do_turn(game.player_breaker.guess(game))
        puts "\nReturned #{turn.to_s()} "

      rescue TypeError, RuleViolationError => err
        # Anzeigen des Problems
        puts "########################################"
        puts "Ups! #{err}"
        puts "########################################"
      end
    end

    return game
  end

end