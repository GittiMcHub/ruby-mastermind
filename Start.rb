require_relative "PlayerHuman"
require_relative "Game"

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

case game_mode
when 1
  player_maker = PlayerHuman.new("Human", "MAKER")
  player_breaker = PlayerHuman.new("Human", "BREAKER")
# NOT IMPLEMENTED
 # when 2
 # when 3
end

puts "Choose Code length: "
setting_codelength = gets.chomp().to_i()
puts "Choose allowed amount of turns: "
setting_turns = gets.chomp().to_i()

Game.new(setting_codelength, setting_turns, player_maker, player_breaker)