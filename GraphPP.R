library(plotly)
library(ggplot2)
library(tidyverse)

fert<-read.csv("https://raw.githubusercontent.com/kitadasmalley/FA2020_DataViz/main/data/gapminderFert.csv", 
               header=TRUE)

head(fert)
str(fert)
summary(fert)


#Fertility rate---------------------

library(dplyr)
library(ggplot2)
p<- fert%>%
  filter(year == 2015)%>%
  ggplot(aes(fert, life, size = pop, color = continent)) +
  labs(x="Fertility Rate", y = "Life expectancy at birth (years)", 
       caption = "(Based on data from Hans Rosling - gapminder.com)", 
       color = 'Continent',size = "Population (millions)") + 
  ylim(30,100) +
  geom_point()
ggplotly(p)

#Dynamic graph---------------------
#install.packages("plotly")
library(plotly)
library(ggplot2)
p<- fert%>%
  ggplot(aes(x=fert, y=life, size = pop, color = continent,frame = year)) +
  labs(x="Fertility Rate", y = "Life expectancy at birth (years)", 
       caption = "(Based on data from Hans Rosling - gapminder.com)", 
       color = 'Continent',size = "Population (millions)") + 
  ylim(30,100) +
  geom_point(aes(text=Country))

ggplotly(p)


#Using the gganimate-------------------------
library(gganimate)
library(gifski)

temp_file_proc <- tempfile(pattern = "", fileext = ".png")

outout_file_proc <- paste("C:/Users/amand/OneDrive/Escritorio/Data_Viz", Sys.getenv("USERNAME"), "_DynamicGraphs.pptx", sep = "")

p1 <- ggplot(fert, aes(fert, life, size = pop, color = continent, frame = year)) +
  labs(x="Fertility Rate", y = "Life expectancy at birth (years)", 
       caption = "(Based on data from Hans Rosling - gapminder.com)", 
       color = 'Continent',size = "Population (millions)") + 
  ylim(30,100) +
  geom_point() +
  #ggtitle("Year: {frame_time}") +
  transition_time(year) +
  ease_aes("linear") +
  enter_fade() +
  exit_fade()

x <- animate(p1,fps = 4, width = 600, height = 400, renderer = gifski_renderer())
saveWidget(x, "temp.html")

#webshot::install_phantomjs()
webshot("temp.html", temp_file_proc)

doc <- read_pptx()
doc <- add_slide(doc, layout = "Title and Content", master = "Office Theme")
doc <- ph_with(x = doc, value = "Title of the PPT", location = ph_location_type(type = "title"))
image_add <- external_img(temp_file_proc, width = 5, height = 5)
doc <- ph_with(x = doc, image_add,
               location = ph_location(left = 2.5, top = 2), use_loc_size = FALSE)

print(doc, target = outout_file_proc)
