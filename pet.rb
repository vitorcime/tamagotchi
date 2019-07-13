require 'date'
class Tamagochi
  def initialize(name)
    @name = name
    @happy = 99
    @health = 99
    @hunger = 99
    @state = 'normal'
  end
  def update(lastTime)
    deltaTime = DateTime.now - lastTime
    print(deltaTime.strftime "%H:%M")
    hungerRate = 5
    healthRate = 4
    happyRate = 3

    @happy -= (happyRate * (rand 1..2)) * deltaTime
    @hunger -= (hungerRate * (rand 1..2)) * deltaTime
    @health -= (healthRate * (rand 1..2)) * deltaTime
  end
end

d = Tamagochi.new('vitor')
d.update(5)
