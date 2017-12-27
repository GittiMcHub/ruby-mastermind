class CodemakerKI
  
  def initialize(name)
    @name = name
  end
  
  def create_code(game)
    
    random_code = []
    
    for i in 1..(game.setting_code_length)
      random_code.push(rand(game.setting_code_range))
    end
    
    return Turn.new(random_code)
    
  end
  
end