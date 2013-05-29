class Player

  def initialize
    @dir = :forward
    @flag = false
    @pos = [:forward, :right, :backward, :left]
    @bind = true
    @enemys = []
    @binded = 0
    @captive = true
    @surrounded = false
  end

  def play_turn(warrior)
    # add your code here
    array = warrior.listen.map{|item| item.to_s}
    items = warrior.listen
    list = warrior.look(@dir).map{|item| item.to_s}
   

    if warrior.health < 4
      @flag = true
    end

    if @flag
      doLive(warrior)
    else
        #si no hay enemigos ni cautivos, buscamos la escalera
       if items.length == 0
          warrior.walk!(warrior.direction_of_stairs)
        else
          #buscamos los cautivos
          if array.include?'Captive' 
            @dir = warrior.direction_of(items[array.index('Captive')])
          else
            #establecemos la direccion del primer objetivo 
            @dir = warrior.direction_of(items[0])
            @captive = false
          end
          
          #rodeamos la escalera
          if warrior.feel(@dir).stairs?
            goEmpty(warrior)
          else
             #si estamos rodeado por 2 o mas, los inmovilizamos
            unless @surrounded
              isSurrounded(warrior)
            end
            if @surrounded and @bind
              doBind(warrior)
            else
              #si hay 3 enemigos en fila detomamos la bomba
              case list[0]
              when "Thick Sludge", "Sludge"
                case list[1]
                when "Thick Sludge", "Sludge"
                  case list[2]
                   when "Thick Sludge", "Sludge"
                      warrior.detonate!(@dir)
                    else
                      doAction(warrior)  
                   end 
                 else
                  doAction(warrior)  
                end
              else
                doAction(warrior)  
              end
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

  #esquivar enemigo enfrente
  def doElude(warrior)
    if @dir == :forward
      if warrior.feel(:left).empty? and not warrior.feel(:left).stairs?
        warrior.walk!(:left)
      elsif warrior.feel(:right).empty? and not warrior.feel(:right).stairs?
        warrior.walk!(:right)
      end
    elsif @dir == :right
        warrior.walk!(:forward)
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
    if array.length >= 2
      @enemys = array
      @surrounded = true
    end
  end

  def doBind(warrior)
  	warrior.bind!(@enemys[@binded])
  	@binded += 1
  	#si ya se inmovilizarion todos se desactiva en bind
  	if @enemys.length == @binded
  		@bind = false
  	end
  end

end
