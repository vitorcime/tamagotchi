Shoes.app(:width => 700,
          :height => 600,
          :title => "Ludicolo")  do
  background("grass-type-pokemon-pattern-vector.jpg")
  @pet = nil
  flow(:width  => 700,
       :height => 600,
       :scroll => false) do

    style(:margin_left => "40%", :margin_top => "30%")
    image "ludicolo.gif" , width: 170 , height: 170
  end

end
