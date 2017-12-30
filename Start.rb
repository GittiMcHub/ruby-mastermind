#
# Start Skript fuer das Mastermind Spiel
# Hier werden Rahmenbedinungen festgelegt, wie das Spiel ablaufen soll
#  - Wer spielt gegen Wen
#  - Wie lang darf ein Code sein
#  - Wie viele Versuche hat der Codebreaker

require_relative "Game"
require_relative "GameController"
require_relative "CodebreakerHuman"
require_relative "CodebreakerKI"
require_relative "CodemakerHuman"
require_relative "CodemakerKI"

def new_game()

  system "clear" or system "cls"
  puts "   _____                   __                       .__            .___"
  puts "  /     \\ _____    _______/  |_  ___________  _____ |__| ____    __| _/"
  puts " /  \\ /  \\\\__  \\  /  ___/\\   __\\/ __ \\_  __ \\/     \\|  |/    \\  / __ | "
  puts "/    Y    \\/ __ \\_\\___ \\  |  | \\  ___/|  | \\/  Y Y  \\  |   |  \\/ /_/ | "
  puts "\\____|__  (____  /____  > |__|  \\___  >__|  |__|_|  /__|___|  /\\____ | "
  puts "     \\/     \\/     \\/            \\/            \\/        \\/      \\/"
  puts "                                              by Team.new(\"ALT.F4\")"
  puts "\n10 trys to break a 4-digit code with numbers between 1 and 6"
  puts "\n  # # # Main Menu # # # "
  puts " Code MAKER    vs. BREAKER"
  puts "[ 1 ] Player   vs. Player"
  puts "[ 2 ] Player   vs. Computer"
  puts "[ 3 ] Computer vs. Player"

  player_maker = nil
  player_breaker = nil
  setting_code_length = 4
  setting_code_range = 1..6
  setting_turns = 10

  #TODO: Spielernamen einsammeln
  game_mode = 0

  # Solange ein ungueltiger Game Mode ausgewaehlt wurde, erneut fragen
  while !(1..4).to_a.include?(game_mode)
    print "\nChoose between option 1 and 3: "
    game_mode = gets.chomp.to_i()

    # Verschiedene Spielmodi werden ueber Ziffern ausgewaehlt
    # Code MAKER vs. BREAKER
    case game_mode
    when 1
      # 1 Player   vs. Player
      player_maker = CodemakerHuman.new("Human Maker")
      player_breaker = CodebreakerHuman.new("Human Breaker")

    when 2
      # 2 Player   vs. Computer
      player_maker = CodemakerHuman.new("Human Maker")

      puts "\nChoose your enemy!   | Difficulty | 2-digit | 3-digit | 4-digit "
      puts "----------------------------------------------------------------"
      puts "[ 1 ] Captain Random | Range 1..6 | ~??.?%  | ~??.?%  | ??.?"
      puts "[ 2 ] Fortuna        | Range 1..6 | ~99.9%  | ~94.5%  | 45% - 80%"

      ki_breaker_option = 0
      # Solange ungueltige Aktionen ausgewahelt werden, erneut fragen
      while !(1..2).to_a.include?(ki_breaker_option)
        print "\nChoose between option 1 and 2: "
        ki_breaker_option = gets.chomp.to_i()
        case ki_breaker_option
        when 1
          player_breaker = CodebreakerKIRandom.new("Captain Random")
        when 2
          player_breaker = CodebreakerKI.new("Fortuna")
        end
      end

    when 3
      # 3 Computer vs. Player
      player_maker = CodemakerKI.new("Captain Random")
      player_breaker = CodebreakerHuman.new("Human Breaker")

    when 4
      # 4 Computer vs. Computer
      player_maker = CodemakerKI.new("Captain Random")
      player_breaker = CodebreakerKI.new("Fortuna")
    end

  end

  # Fragen, ob die regeln geaendert werden sollen
  print "Do you want to change the rules? (y/N)"
  different_rules = gets.chomp().to_s()

  if different_rules.downcase() == "y"
    print "Choose allowed amount of turns: "
    setting_turns = gets.chomp().to_i()
    print "Choose Code length: "
    setting_code_length = gets.chomp().to_i()
    print "Choose amount of different numbers: "
    setting_code_range = 1..(gets.chomp.to_i())
  end

  # Neues Spiel mit den vorgegeben Einstellungen
  game = Game.new(setting_code_length, setting_code_range, setting_turns, player_maker, player_breaker)

  # Instanziert den Spielcontroller
  GameController.new(game)
end

while true
  new_game()
end
