# Palettes ----

if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  #dichromat, # get colors between a group
  randomcoloR # tons and tons of colors
)


  yale_lblue  <- "#63aaff"
  yale_medblue   <- "#286dc0"
  yale_blue   <- "#00356b"
  
  
  yale_palette <- colorRampPalette(color = c("white", yale_lblue, yale_medblue, yale_blue))(10)
  yale_exag_palette <- yale_palette[c(1,2,4,6,8,10)]
  
  yale_scheme <- c(yale_palette[c(3,6,4,2,5,3,6,4,2,5)])
  
  my_green <- "#228B22"
  
  
  terrain_palette <- colorRampPalette(color = c("#fff7bc","#fec44f","#d95f0e"))(5)
  
  #https://stackoverflow.com/questions/15282580/how-to-generate-a-number-of-most-distinctive-colors-in-r
  # better for lots of random colors
  rainbow_palette <- randomcoloR::distinctColorPalette(30)

