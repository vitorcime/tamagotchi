require 'date'
require 'json'
require "benchmark"

class Tamagochi
  def initialize(usuario)
    file = File.read('saves/' + usuario + '.json')
    data_hash = JSON.parse(file)
    @name = data_hash["name"]
    @happy = data_hash["happy"]
    @health = data_hash["health"]
    @hunger = data_hash["hunger"]
    @sleep = data_hash["sleep"]
    @state = data_hash["state"]
    @lastTime = Time.now
    @level = data_hash["level"]
    @exp = data_hash["exp"]
  end
  def update()
    deltaTime = Time.now - @lastTime
    @lastTime = Time.now
    print(deltaTime, "\n")
    hungerRate = 0.5
    healthRate = 0.4
    happyRate = 0.3
    sleepRate = 0.1
    @happy -= (happyRate * (rand 1..2)) * deltaTime
    @hunger -= (hungerRate * (rand 1..2)) * deltaTime
    @health -= (healthRate * (rand 1..2)) * deltaTime
    if @state == "acordado"
      @sleep -= (sleepRate * (rand 1..2)) * deltaTime
    elsif @state == "dormindo"
      @sleep += (sleepRate * (rand 1..2)) * deltaTime
    end


    if @exp >= 100
      @level += 1
      @exp = 0
    end

    if @level == 0
      @name = "lotad"
    elsif @level == 1
      @name = "lombre"
    elsif @level > 1
      @name = "ludicolo"
    end

  end
  def alimentar()
    if @hunger+10 > 100
      @hunger = 99
      return
    end
    @hunger += 10
    @exp += 2
  end
  def brincar()
    @happy = 99
    @exp += 2
    Shoes.app :width => 400, :height => 400, :resizable => false do
      paddle_size = 75
      ball_diameter = 20
      vx, vy = [3, 4]
      compuspeed = 10
      bounce = 1.2

      # set up the playing board
      nostroke and background white
      @ball = oval 0, 0, ball_diameter, :fill => "#9B7"
      @you, @comp = [app.height-4, 0].map {|y| rect 0, y, paddle_size, 4, :curve => 2}

      # animates at 40 frames per second
      @anim = animate 40 do

        # check for game over
        if @ball.top + ball_diameter < 0 or @ball.top > app.height
          para strong("GAME OVER", :size => 32), "\n",
               @ball.top < 0 ? "Voce ganhou!" : "Derrota :´(", :top => 140, :align => 'center'
          @ball.hide and @anim.stop
        end

        # move the @you paddle, following the mouse
        @you.left = mouse[1] - (paddle_size / 2)
        nx, ny = (@ball.left + vx).to_i, (@ball.top + vy).to_i

        # move the @comp paddle, speed based on `compuspeed` variable
        @comp.left +=
            if nx + (ball_diameter / 2) > @comp.left + paddle_size;  compuspeed
            elsif nx < @comp.left;                                  -compuspeed
            else 0 end

        # if the @you paddle hits the ball
        if ny + ball_diameter > app.height and vy > 0 and
            (0..paddle_size).include? nx + (ball_diameter / 2) - @you.left
          vx, vy = (nx - @you.left - (paddle_size / 2)) * 0.25, -vy * bounce
          ny = app.height - ball_diameter
        end

        # if the @comp paddle hits the ball
        if ny < 0 and vy < 0 and
            (0..paddle_size).include? nx + (ball_diameter / 2) - @comp.left
          vx, vy = (nx - @comp.left - (paddle_size / 2)) * 0.25, -vy * bounce
          ny = 0
        elsif nx + ball_diameter > app.width or nx < 0
          vx = -vx
        end

        @ball.move nx, ny
      end
    end
  end
  def medicar()
    if @health+20 > 100
      @health = 99
      return
    end
    @health += 20
    @exp += 2
  end
  def dormir()
    if @state == "acordado"
      @state = "dormindo"
    else
      @state = "acordado"
    end
  end
  def get_name()
    return @name
  end
  def get_level()
    return @level
  end
  def get_sprite()
    if @level == 0
      return "img/lotad.gif"
    elsif @level == 1
      return "img/lombre.gif"
    elsif @level > 1
      return "img/ludicolo.gif"
    end
  end
  def get_hunger()
    if @hunger < 1
      return 1
    end
    return @hunger
  end
  def get_happy()
    if @happy < 1
      return 1
    end
    return @happy
  end
  def get_health()
    if @health < 1
      return 1
    end
    return @health
  end
  def get_status()
    return @state
  end
  def get_sleep()
    if @sleep < 1
      return 1
    end
    return @sleep
  end
  def evoluir()
    @level += 1
  end
  def ishungry()
    if @hunger > 50
      return "Sem fome"
    end
    if @hunger < 50 and @hunger > 20
      return "Com fome"
    end
    if @hunger < 20
      return "Faminto"
    end
  end
  def ishealth()
    if @health > 50
      return "Saudável"
    end
    if @health < 50 and @health > 20
      return "Resfriado"
    end
    if @health < 20
      return "Muito doente"
    end
  end
  def ishappy()
    if @happy > 50
      return "Feliz"
    end
    if @happy < 50 and @happy > 20
      return "Triste"
    end
    if @happy < 20
      return "Depressivo"
    end
  end
  def issleepy()
    if @sleep > 50
      return "Sem sono"
    end
    if @sleep < 50 and @sleep > 20
      return "Sonolento"
    end
    if @sleep < 20
      return "Com muito sono"
    end
  end
  def save(nome)
    save = File.open("saves/#{nome}.json", "w")
    atributos ={
        "name" => @name,
        "happy" => @happy,
        "health" => @health,
        "hunger" => @hunger,
        "sleep" => @sleep,
        "state" => @state,
        "lastTime" => @lastTime ,
        "level" => @level,
        "exp" => @exp
    }
    save.write(atributos.to_json)
    save.close
  end
end

def criaConta(nome)
  novaconta = File.open("saves/#{nome}.json", "w")
  atributos ={
      "name" => "lotad",
      "happy" => 99,
      "health" => 99,
      "hunger" => 99,
      "sleep" => 99,
      "state" => "acordado",
      "lastTime" => nil ,
      "level" => 0,
      "exp" => 0
  }
  novaconta.write(atributos.to_json)
  novaconta.close
end

def logar(usuario)
logado = File.open("logado.json", "w")
login = {
    "usuario" => usuario
}
logado.write(login.to_json)
logado.close
end

Shoes.app title:"Pet" ,:width => 800, :height => 700 do
  background 'img/tela_inicial.png'
  @conta = edit_box :width => 200, :height => 30
  para " "
  button "Criar conta" do
  criaConta(@conta.text)
  end
  stack :margin => 300 do
    para "Digite seu login"
    @edit = edit_box :width => 200, :height => 20 do end
    button  "Logar"  do
      logar(@edit.text)

      window title: @edit.text do
        file = File.read('logado.json')
        data_hash = JSON.parse(file)
        usuario = data_hash["usuario"]
        @background = background "img/teladopet.jpg"
        pet = Tamagochi.new(usuario)
        @dormindo = image "img/dormindo.png" , width: 50, height: 50, :top => 120, :left => 340
        @imagem = image "pet.get_sprite()" , width: 300 , height: 300, :top => 20 , :left => 150
        @fome = para  :top => 380, :left => 0
        @hunger_progress = progress :width => 0.2, height: 0.7, :top => 70 , :left => 0
        @saude = para  :top => 380, :left => 150
        @health_progress = progress :width => 0.2, height: 0.7, :top => 70 , :left => 150
        @felicidade = para  :top => 380, :left => 300
        @happy_progress = progress :width => 0.2, height: 0.7, :top => 70 , :left => 300
        @sono = para  :top => 380, :left => 470
        @sleep_progress = progress :width => 0.2, height: 0.7, :top => 70 , :left => 450
        flow do
          button "Salvar" do
            pet.save(usuario)
          end
          para " "
          button "Comer" do
            pet.alimentar()
          end
          para " "
          button "Dormir" do
            pet.dormir()
          end
          para " "
          button "Jogar"do
            pet.brincar()
          end
          para " "
          button "Medicar-se"do
            pet.medicar()
          end
          para " "
          button "Evoluir" do
            pet.evoluir()
          end
        end
        animate do
            if pet.get_status() == "acordado"
              @dormindo.hide()
            elsif pet.get_status() == "dormindo"
              @dormindo.show()
            end
          @hunger_progress.fraction = (pet.get_hunger() % 100) / 100.0
          @health_progress.fraction = (pet.get_health() % 100) / 100.0
          @happy_progress.fraction = (pet.get_happy() % 100) / 100.0
          @sleep_progress.fraction = (pet.get_sleep() % 100) / 100.0
          @imagem.path = pet.get_sprite()
          @felicidade.replace "Felicidade: #{pet.ishappy()}"
          @sono.replace "Sono: #{pet.issleepy()}"
          @fome.replace "Fome: #{pet.ishungry()}"
          @saude.replace "Saude: #{pet.ishealth()}"
          pet.update()
        end


      end
  close()
    end
    end
  end

