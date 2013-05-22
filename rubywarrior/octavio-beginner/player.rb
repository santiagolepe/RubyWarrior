class Player

  def initialize
    @health = 20  
    @dir = :forward
    @rescued = 0
  end

  def play_turn(warrior)
  	puts "rescatados: #{@rescued}"
  	puts "#{warrior.look}"

  	#si topamos con pared, cambiamos direccion
  	if warrior.feel.wall?
  		warrior.pivot!(:left)
  	#si encuentra un cautivo lo rescata
 	elsif warrior.feel(@dir).captive? 
    	warrior.rescue!(@dir)
    	#sumamos los rescatados y cambiamos la direccion hacia adelante
    	@rescued += 1
    	@dir = :forward
  	elsif
    	#sino somos atacados y estamos dañado, se recupera la sangre
    	if !isAttacked(warrior) and warrior.health < 20
    		warrior.rest!

    	# si encuentra a un mago un espacio alfrente lanza una flecha
  		elsif warrior.look[1].to_s() == "Wizard"
  			warrior.shoot!(@dir)
  		else
  			if warrior.feel.enemy?
  				if warrior.health <= 10
	  				warrior.walk!(:backward)
		  		else
	    			warrior.attack!(@dir)
	    		end
  			else
  				if warrior.health <= 10
	  				warrior.walk!(:backward)
		  		else
	    			warrior.walk!(@dir)
	    		end
			end
		end
   
    	#guardamos la sangre restante
	@health = warrior.health
    end
  end

  #metodo para saber si somos atacados
  def isAttacked(warrior)
  	warrior.health < @health
  end

end

