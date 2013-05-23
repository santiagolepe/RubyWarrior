class Player

  def initialize
    @dir = :forward
    @flag = false
  end

  def play_turn(warrior)
    puts "#{warrior.health}"
    #guardamos en un array las tresposiciones 
    array = warrior.look(@dir)
    arrayBack = warrior.look(:backward)


    #checamos si ahi un arquero lejos atacando mision 9
    if arrayBack[2].to_s() == "Archer"
      warrior.shoot!(:backward)
    #checamos si hay un cautivo atras mision 6  
    elsif arrayBack[1].to_s() == "Captive" or arrayBack[0].to_s() == "Captive"
      if warrior.feel(:backward).captive?
        warrior.rescue!(:backward)
      else
        warrior.walk!(:backward)
      end
    else
      
      #si la sangre es menor a 8 activamos la bandera
      if warrior.health <= 8
        @flag = true
      end

      if @flag
        doLive(warrior, array)
        if warrior.health >= 20
          @flag = false
        end
      else
        #realizar una accion, segun lo que encuentre en el camino
        doAction(warrior,array)   
      end  
    end
 
  end

  def checkCaptive(array)
    #Captive
  end

  def doLive(warrior, array)
     #arbol de desiciones
    case array[0].to_s()
    when "nothing"
      case array[1].to_s()
      when "nothing"
        case array[2].to_s()
        when "Archer"
          doBack(warrior)
        else
          warrior.rest!
        end
      when "Archer"
        doBack(warrior)
      else
        warrior.rest!
      end
    when "Archer","Thick Sludge", "Sludge","Wizard"
      doBack(warrior)
    else
      warrior.rest!
    end

  end

  def doBack(warrior)
    if @dir == :forward
      warrior.walk!(:backward)
    else
      warrior.walk!(:forward)
    end
  end

  def doReverse(warrior)
    if @dir == :forward
        @dir = :backward
      else
        @dir = :forward
      end
      warrior.pivot!(@dir)
  end

  def doAction(warrior, array)
     #arbol de desiciones
    case array[0].to_s()
    when "nothing"
      case array[1].to_s()
      when "nothing"
        case array[2].to_s()
        when "Wizard", "Archer" 
          warrior.shoot!(@dir)
        else
          warrior.walk!(@dir) 
        end
      when "Wizard"
        warrior.shoot!(@dir)
      else
        warrior.walk!(@dir) 
      end
    when "Thick Sludge", "Sludge", "Archer" 
      warrior.attack!(@dir)
    when "Captive"
      warrior.rescue!(@dir)
    when "wall"
      doReverse(warrior)
    end
  end

end

