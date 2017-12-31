#
# Eine Klasse fuer ein Competition Modus
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

    GameConsolePrinter.clear_console()

    puts "Competition mode!"

    @competition_code_length = 4
    @competition_code_range = 1..6
    @competition_turns = 10

    print "Hey Master, choose the code: "
    @competition_turn = master.create_code(Game.new(@competition_code_length,@competition_code_range, @competition_turns, CodemakerKI.new("Dummy for rules"),CodebreakerKI.new("Dummy for rules")))

    puts "Competition will be made with code: #{@competition_turn.code.to_s}"

    puts "Press ENTER to continue..."
    input = gets.chomp()

    @game_one = Game.new(4, 1..6, 10, master, player1)
    @game_one.set_code(@competition_turn)
    @game_one = play(@game_one)

    @game_one.won?() ? GameConsolePrinter.print_thumb_up() : GameConsolePrinter.print_thumb_down()

    puts "Press ENTER to continue..."
    input = gets.chomp()

    GameConsolePrinter.clear_console()
    puts "Game ONE finished! # You will have #{@game_one.turns.size()} turns to beat it"

    puts "Press ENTER to continue..."
    input = gets.chomp()

    @game_two = Game.new(4, 1..6, @game_one.turns.size(), master, player2)
    @game_two.set_code(@competition_turn)

    @game_two = play(@game_two)

    @game_two.won?() ? GameConsolePrinter.print_thumb_up() : GameConsolePrinter.print_thumb_down()

    puts "Press ENTER to continue..."
    input = gets.chomp()
    
    winner = ""
    if !@game_one.won?() && !@game_two.won?()
      puts "!one && !two"
      winner = master.to_s()
    end
    if @game_one.won?() && !@game_two.won?()
      puts "one && !two"
      winner = player1.to_s()
    end
    if @game_two.won?()
      puts "!one && two"
      winner = player2.to_s()
    end

    GameConsolePrinter.clear_console()
    
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