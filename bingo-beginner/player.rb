require 'pry'

class Player

  def play_turn(warrior)
    
    @mode = "Explore" unless @mode
    @health = warrior.health unless @health
    @rescued = 0 unless @rescued
    @status = "Fresh" unless @status
    
    #what mode am I in?
    # defensive = 
    # touching someone? => backup
    # not touching anyone? => rest
    # 
    # offensive = move forward or attack
    #  touching someone? => attack
    #  not touching someone? => move forward
    #
    # explore
    # rescued the captive => offensive 
    # not rescued the captive => move backward

    #Get status
    if warrior.health < @health
      @mode = "Offensive"  #ARCHHER!!!
      @status = "Under Attack"
    else
      @status = "Stable"
    end
    
    if @status = "Under Attack"
      
    end

    #Get surroundings
    if warrior.look[0].character == " " && warrior.look[1].character == "w"
      @mode = "Wizard"
    elsif warrior.look[0].character == "w"
      @mode = "Wizard"
    elsif warrior.look[0].character == " " && warrior.look[1].character == " " && warrior.look[2].character == "w"
      @mode = "Wizard"
    elsif warrior.look[0].character == " " && warrior.look[1].character == " " && warrior.look[2].character == " "
      @mode = "Offensive"
    end
    

    output_turn_details(warrior)

    case @mode
      
    when "Explore"
      if warrior.feel.captive?
        warrior.rescue!
        @rescued +=1
        @mode = "Offensive" #START THE KILLING!!!
      elsif warrior.feel.wall?
        warrior.pivot!
      else
        warrior.walk!
      end
      
    when "Offensive"
      if warrior.feel.enemy?
        enemy_present = warrior.feel.to_s
        case enemy_present
        when "Thick Sludge"
          if warrior.health<12
            @mode = "Defensive"
            warrior.walk!(:backward)
          else
            warrior.attack!
          end
        when "Sludge"
          warrior.attack!
        when "Archer"
          warrior.attack!
        end
      else
        warrior.walk!
      end
      
    when "Defensive"
      if warrior.health<12
        warrior.rest!
      else
        @mode = "Offensive"
        warrior.walk!
      end
    
    when "Wizard"
      if warrior.look[0].character == "w"
        warrior.walk!(:backward)
      elsif warrior.look[0].character == " " && warrior.look[1].character == "w"
        warrior.walk!(:backward)
      elsif warrior.look[0].character == " " && warrior.look[1].character == " " && warrior.look[2].character =="w"
        warrior.shoot!
      end
    end
    
    @health = warrior.health
    
  end
  
  def output_turn_details(warrior)
    puts "Mode: #{@mode}"
    puts "Enemy Touching forward: #{warrior.feel}"
    puts "Looking Forward: #{warrior.look}"
    puts "Looking Right: #{warrior.look(:right)}"
    puts "Looking Left: #{warrior.look(:left)}"
    puts "Looking Backwards: #{warrior.look(:backward)}"
    puts "Health: #{warrior.health}"
    puts "Status: #{@status}"
    puts "Rescued: #{@rescued}"
  end
  
end
