#
# Diese Klasse repraesentiert einen Spielzug im Mastermind Game
#

require_relative "RuleViolationError"

class Turn
  
  attr_reader :black_hits, :white_hits
  
  def initialize(codes)
    raise TypeError, 'codes needs to be stored as Array' unless codes.is_a? Array
    codes.each do | value |
          raise TypeError, 'Codes need to be integers' unless value.is_a? Integer
    end
    
    @code = codes
    
    # Direkte Treffer
    @black_hits = nil
    # Indirekte Treffer
    @white_hits = nil
  end
  
  
  # Methode zum setzen der Black Hits.
  # Nachdem der Zug analysiert wurde, darf die Auswertung nicht mehr verandert werden
  def black_hits=(hits)
    raise TypeError, "Given black hits must be type of Integer" unless hits.is_a? Integer
    raise RuleViolationError, "Cannot override black hits" unless @black_hits == nil
    
    @black_hits = hits
    return self
  end

  # Methode zum setzen der White Hits.
  # Nachdem der Zug analysiert wurde, darf die Auswertung nicht mehr verandert werden
  def white_hits=(hits)
    raise TypeError, "Given white hits must be type of Integer" unless hits.is_a? Integer
    raise RuleViolationError, "Cannot override white hits" unless @white_hits == nil
      
    @white_hits = hits
    return self
  end
  
  
  def to_s()
    return "#{self.code.to_s()} BH: #{self.black_hits} WH: #{self.white_hits} "
  end
  
  # Eine Kopie des Codes zurueckgeben, damit der gemachte Zug nicht veraendert werden kann
  def code()
    return @code.clone()
  end

end