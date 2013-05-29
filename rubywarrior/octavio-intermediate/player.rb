class Player

  def initialize
    @dir = :forward
    @flag = false
    @pos = [:forward, :right, :backward, :left]
    @bind = true
    @enemys = []
    @binded = 0
  end

  def play_turn(warrior)
    # add your code here
    array = warrior.listen
    puts "#{array}"

    if warrior.health < 5
      @flag = true
    end


    if @flag
      doLive(warrior)
    else
        #si no hay enemigos ni cautivos, buscamos la escalera
       if array.length == 0
          warrior.walk!(warrior.direction_of_stairs)
        else
          puts "#{array.to_s().include?'Captive'}"
          puts "#{array.to_s().index('Captive')}"
          #establecemos la direccion del primer objetivo (cautivo)
          @dir = warrior.direction_of(array[0])
          #rodeamos la escalera
          if warrior.feel(@dir).stairs?
            goEmpty(warrior)
          else
          	#si estamos rodeado por 2 o mas, los inmovilizamos
          	isSurrounded(warrior)
          	if @enemys.length >= 2 and @bind
          		doBind(warrior)
          	else
          		doAction(warrior)
          	end
            
          end
        end
    end

  end


  def doLive(warrior)
    case warrior.feel(@dir).to_s()
      when "Thick Sludge", "Sludge"
        goEmpty(warrior)
      else
        warrior.rest!
        if warrior.health >= 20
          @flag = false
        end
      end 
  end

  #busca un lugar vacio para moverse
  def goEmpty(warrior)
    if warrior.feel(:forward).empty? and not warrior.feel(:forward).stairs?
      warrior.walk!(:forward)
    elsif warrior.feel(:backward).empty? and not warrior.feel(:backward).stairs?
      warrior.walk!(:backward)
    elsif warrior.feel(:left).empty? and not warrior.feel(:left).stairs?
      warrior.walk!(:left)
    elsif warrior.feel(:right).empty? and not warrior.feel(:right).stairs?
      warrior.walk!(:right)
    end
  end


  def doAction(warrior)
    case warrior.feel(@dir).to_s()
      when "Captive"
        warrior.rescue!(@dir)
      when "Thick Sludge", "Sludge"
        warrior.attack!(@dir)
      else
        warrior.walk!(@dir)
      end 
  end


  def isSurrounded(warrior)
    #devuelve las posiciones en la que esta rodeado
    array = []
    @pos.each do |pos|
      if warrior.feel(pos).enemy?
        array.push(pos)
      end
    end
    @enemys = array
  end

  def doBind(warrior)
  	warrior.bind!(@enemys[@binded])
  	@binded += 1
  	#si ya se inmovilizarion todos se desactiva en bind
  	if @enemys.length == @binded
  		@bind = false
  	end
  end

  def getCaptive(warrior)

  end

end
