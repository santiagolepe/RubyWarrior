class Player

  def initialize
    @flag = false
    @turn = 1
  end

  def play_turn(warrior)
    # add your code here
    dirS = warrior.direction_of_stairs
    array = warrior.listen
    puts "#{warrior.direction_of(array[0])}"


  end
end
