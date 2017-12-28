#
# Diese Klasse spiegelt das Spiel Mastermind wieder
#

require_relative "RuleViolationError"
require_relative "Turn"

class Game

  attr_reader :player_maker, :player_breaker, :turns, :setting_code_length,  :setting_code_range, :setting_turns
  # Instanzierung mit folgenden Parametern
  # setting_code_length = Die laenge des Codes
  # setting_turns       = Bestimmt wie viele Zuege der codebrekaer zum Knacken des Codes hat
  # player_maker        = Das Player Objekt des Codemakers
  # player_breaker      = Das Player Objekt des Codebreakers
  def initialize(setting_code_length, setting_turns, player_maker, player_breaker)
    raise TypeError, 'Codelength needs to be an Integer' unless setting_code_length.is_a? Integer
    raise TypeError, 'Turns needs to be an Integer' unless setting_turns.is_a? Integer
    raise TypeError, 'Given Argument is not a Player object' unless player_maker.is_a? CodemakerHuman or player_maker.is_a? CodemakerKI
    raise TypeError, 'Given Argument is not a Player object' unless player_breaker.is_a? CodebreakerHuman or player_breaker.is_a? CodebreakerKI

    @setting_code_length = setting_code_length
    @setting_turns = setting_turns
    @player_maker = player_maker
    @player_breaker = player_breaker

    # Beinhaltet alle gemachten Zuege
    @turns = []
    # Bei Instanizierung hat der Codemaker noch kein Code definiert
    @code = nil
    # "won" beschreibt, ob der Codebraker gegen den Maker gewonnen hat
    @won = false
    # Aktuell statische Range von 1 - 6
    @setting_code_range = 1..6

  end

  # Zugriffsmethode im boolean stil
  def won?()
    return @won
  end

  # Gibt den letzten Zug zurueck
  def previous_turn()
    return @turns.last()
  end

  # Gibt zurueck, wie viele Zuege der Codebreaker noch hat
  def turns_left()
    return @setting_turns - @turns.size()
  end

  # Pruefmethode fuer den Code
  def code_is_set?()
    return @code != nil
  end

  # Gibt aus, ob das Spiel beendet ist
  def finished?()
    return (@turns.size() >= @setting_turns || won?())
  end

  def code()
    raise RuleViolationError, "You are not allowed to view the code when the game is running" unless finished?()
    return @code
  end

  # Gibt zrueck, was als naechstes Laut Regelwerk passieren sollte
  def next_action()
    if(@code == nil)
      return "make"
    end
    if(@code != nil && !self.finished?())
      return "guess"
    end
    return "finished"
  end

  # Prueft ob der gemachte Zug den Fachlichen und Programmtechnischen Regeln entspricht
  def valid_turn?(turn)
    raise TypeError, 'This must be a Turn' unless turn.is_a? Turn
    raise RuleViolationError, 'Code does not match rules' unless turn.code.length() == @setting_code_length
    turn.code.each do | value |
      raise RuleViolationError, 'At least one code is out of range' unless value.is_a? Integer or @setting_code_range.member?(value)
    end
    return true
  end

  # Setter Methode fuer den Code
  # Der Code wird aus dem Zug (Turn) geholt
  def set_code(turn)
    raise RuleViolationError, 'Code can only be set once!' unless @code == nil
    raise RuleViolationError, 'Turn invalid' unless valid_turn?(turn)

    @code = turn.code

    return self
  end

  # Analysiert den gemachten Zug des Codemakers
  def analyze_turn(turn)
    raise RuleViolationError, 'Code must be set first!' unless @code != nil
    raise RuleViolationError, 'Turn invalid' unless valid_turn?(turn)
    raise RuleViolationError, 'Game finished already' unless !finished?()

    # Direkte Treffer
    black_hits = 0
    # Indirekte Treffer
    white_hits = 0

    # Hier wird der Code geklont, damit in der each_with_index schleife die bereits analysierten Ziffern aus dem Array entfernt werden duerfen
    analyze_clone = @code.clone()
    turn_code = turn.code()
    
    # Beispiel Kombination:
    #Code 1,4,3,1
    #Turn 4,3,3,1

    # Berechnung der Black Hits
    turn_code.each_with_index do | value, index|
      # Wenn an der gleichen Stelle der selbe Wert steht, ist es ein Black Hit
      if value == @code[index]
        black_hits += 1
        # Die Ziffern die bereits gezaehlt ausgewertet wurden, werden auf Nil setzen
        # Bei delete_at wuerde sonst der Index fuer diese schleife "kaputt" gehen
        analyze_clone[index] = nil
        turn_code[index] = nil
      end
    end

    # Die beiden Arrays sehen hier so aus:
    #Code 1,4,nil,nil
    #Turn 4,3,nil,nil
    
    # Berechnung der White Hits
    turn_code.each_with_index do | value, index|
      # Wenn der Code aus dem Zug im Code enhalten ist, und es sich nicht um ein Nil Wert handelt, so sei es ein White Hit
      if analyze_clone.include?(value) && value != nil
        white_hits += 1
        # AUch hier die gerade verarbeiteten Werte auf Nil setzen, damit die bereits ausgewerteten Ziffern nicht das Ergebnis verfaleschen
        analyze_clone[analyze_clone.find_index(value)] = nil
        turn_code[index] = nil
      end
    end
  
    
    # Auswertung des Zuges speichern
    turn.black_hits=black_hits
    turn.white_hits=white_hits

    # Zug in die Historie Aufnehmen, wird benoetigt, um das Ende des Spiels duch zu viele Zuege zu bestimmen
    @turns.push(turn)

    # Ist der Code korrekt, wird "won" auf TRUE gesetzt. Signalisiert, dass der Codebreaker gewonnen hat
    if @code == turn.code
      @won = true
    end

    return turn
  end

  # TODO: return a hint
  def give_hint()
    return # a Turn
  end

end