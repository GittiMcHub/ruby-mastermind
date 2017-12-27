#
#
# Dieses Skript laesst den Benutzer auswaehlen, mit welchen Regeln und wer gegen wen spielen soll
#

require_relative "Game"
require_relative "GameController"
require_relative "CodebreakerHuman"
require_relative "CodebreakerKI"
require_relative "CodemakerHuman"
require_relative "CodemakerKI"


puts "   _____                   __                       .__            .___"
puts "  /     \\ _____    _______/  |_  ___________  _____ |__| ____    __| _/"
puts " /  \\ /  \\\\__  \\  /  ___/\\   __\\/ __ \\_  __ \\/     \\|  |/    \\  / __ | "
puts "/    Y    \\/ __ \\_\\___ \\  |  | \\  ___/|  | \\/  Y Y  \\  |   |  \\/ /_/ | "
puts "\\____|__  (____  /____  > |__|  \\___  >__|  |__|_|  /__|___|  /\\____ | "
puts "     \\/     \\/     \\/            \\/            \\/        \\/      \\/"

puts "\nChoose between options 1-3"
puts " Code MAKER    vs. BREAKER"
puts "[ 1 ] Player   vs. Player"
puts "[ 2 ] Player   vs. Computer"
puts "[ 3 ] Computer vs. Player"


game_mode = gets.chomp.to_i()

player_maker = nil
player_breaker = nil
setting_codelength = 4
setting_turns = 10

#TODO: Spielernamen einsammeln 
case game_mode
  when 1
    player_maker = CodemakerHuman.new("Human Maker")
    player_breaker = CodebreakerHuman.new("Human Breaker")
  when 2
    player_maker = CodemakerHuman.new("Human Maker")
    player_breaker = CodebreakerKI.new("KI Breaker")
  when 3
    player_maker = CodemakerKI.new("KI Maker")
    player_breaker = CodebreakerHuman.new("Human Breaker") 
end

puts "Choose Code length: "
setting_codelength = gets.chomp().to_i()
puts "Choose allowed amount of turns: "
setting_turns = gets.chomp().to_i()

# Neues Spiel mit den vorgegeben Einstellungen
game = Game.new(setting_codelength, setting_turns, player_maker, player_breaker)

# Instanziert den Spielcontroller
GameController.new(game)