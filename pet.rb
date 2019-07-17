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
    @sleep -= (sleepRate * (rand 1..2)) * deltaTime

    if @level == 0
      @name = "lotad"
    elsif @level == 1
      @name = "lombre"
    elsif @level > 1
      @name = "ludicolo"
    end

  end
  def alimentar()
    @hunger += 10
  end
  def brincar()
    @happy += 3
  end
  def medicar()
    @health += 20
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
    return @hunger
  end
  def get_happy()
    return @happy
  end
  def get_health()
    return @health
  end
  def get_sleep()
    return @sleep
  end
  def evoluir()
    @level += 1
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
      "state" => "normal",
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
        background("img/teladopet.jpg")
        pet = Tamagochi.new(usuario)
        @imagem = image "pet.get_sprite()" , width: 300 , height: 300, :top => 20 , :left => 150
        para "Fome", :top => 380, :left => 0
        @hunger_progress = progress :width => 0.2, height: 0.7, :top => 70 , :left => 0
        para "Saude", :top => 380, :left => 150
        @health_progress = progress :width => 0.2, height: 0.7, :top => 70 , :left => 150
        para "Felicidade", :top => 380, :left => 300
        @happy_progress = progress :width => 0.2, height: 0.7, :top => 70 , :left => 300
        para "Sono", :top => 380, :left => 450
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
          end
          para " "
          button "Jogar"do
            pet.brincar()
          end
          para " "
          button "Medicar-se"do
            pet.medicar()
          end
          button "Evoluir" do
            pet.evoluir()
          end
        end
        animate do
          @hunger_progress.fraction = (pet.get_hunger() % 100) / 100.0
          @health_progress.fraction = (pet.get_health() % 100) / 100.0
          @happy_progress.fraction = (pet.get_happy() % 100) / 100.0
          @sleep_progress.fraction = (pet.get_sleep() % 100) / 100.0
          @imagem.path = pet.get_sprite()
          pet.update()
        end


      end
  close()
    end
    end
  end

