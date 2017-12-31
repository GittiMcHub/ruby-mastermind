#
# Modul fuer Konsolenausgaben
#
# Beinhaltet funktionen, fuer das Darstellen des Mastermind games
#

require_relative "Game"

module GameConsolePrinter
  # Loescht den Konsolen Inhalt
  def GameConsolePrinter.clear_console()
    system "clear" or system "cls"
    return self
  end

  # Loescht den Konsoleninhalt und gibt das Spielfeld aus
  def GameConsolePrinter.print_game_field(game)
    raise TypeError, "Can only print Mastermind Games" unless game.is_a? Game

    crypt_code = Array.new(game.setting_code_length) { "*" }
    puts "#{crypt_code.to_s().gsub("\"","")}"
    game.turns.each do |turn|
      puts turn.to_s()
    end
    return self
  end

  # Gibt die Spielregeln aus
  def GameConsolePrinter.print_game_rules(game)
    raise TypeError, "Can only print rules of a Mastermind Game" unless game.is_a? Game

    puts "\tCode range:  #{game.setting_code_range.to_s()}"
    puts "\tCode length: #{game.setting_code_length.to_s()}"
    puts "\tBreak trys:  #{game.setting_turns.to_s()}"
    return self
  end

  # Fuehrt die Cheat Methode aus. Gibt einen Sinnvollen naechsten Zug aus, ohne dabei einen Zug des Breakers zu verbrauchen
  def GameConsolePrinter.print_cheat(game)
    puts game.cheat().to_s()
    return self
  end

  def GameConsolePrinter.print_thumb_up()
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

  def GameConsolePrinter.print_thumb_down()
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

  def GameConsolePrinter.print_blame()
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