install.packages("dplyr")
install.packages("ggplot2")
library(dplyr)
library(DBI)
library(RMySQL)
library(ggplot2)

MyDataBase <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "shinydemo",
  host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
  username = "guest",
  password = "guest")

dbListTables(MyDataBase)

dbListFields(MyDataBase, 'CountryLanguage')

DataDB <- dbGetQuery(MyDataBase, "select * from CountryLanguage")
names(DataDB)

#Una vez hecha la conexión a la BDD, generar una busqueda con dplyr que devuelva el
#porcentaje de personas que hablan español en todos los países

SP <- DataDB %>% filter(Language == "Spanish")
SP.df <- as.data.frame(SP) 

#Realizar una gráfica con ggplot que represente este porcentaje de tal modo que en el eje de las Y aparezca el
#país y en X el porcentaje, y que diferencíe entre aquellos que es su lengua oficial y los que no con diferente
#color (puedes utilizar la geom_bin2d() y coord_flip())

SP.df %>% ggplot(aes( x = CountryCode, y=Percentage, fill = IsOfficial )) + 
  geom_bin2d() +  coord_flip()