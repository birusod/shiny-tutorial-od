dir.create("neiss")

download_data <- function(name) {
  #url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
  url <- "https://github.com/hadley/mastering-shiny/tree/main/neiss"
  download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
}
download_data("injuries.tsv.gz")
download_data("population.tsv")
download_data("products.tsv")

#https://github.com/hadley/neiss/blob/master/data/injuries.rda
#https://github.com/hadley/mastering-shiny/tree/main/neiss


# above method did not work. Downloaded file amnually.
# Reading file and saving as csv/tsv.
library(tidyverse)

load_and_save <- function(file){
  write_csv(
    load(paste0('neiss/', file)), paste0("neiss/", file, ".csv"))
}

load_and_save("population.rda")

load(file='neiss/injuries.rda')
write_csv(injuries, "neiss/injuries.csv")
write.table(injuries, file = "neiss/injuries.tsv", sep = "\t")

load(file='neiss/population.rda')
write_csv(population, "neiss/population.csv")
write.table(population, file = "neiss/population.tsv", sep = "\t")

load(file='neiss/products.rda')
write_csv(products, "neiss/products.csv")
write.table(products, file = "neiss/products.tsv", sep = "\t")

# 2017 data
population <- vroom::vroom("neiss/population.csv", delim = ',')

population_2017 <- population |> filter(year == 2017)
write_csv(population_2017, "neiss/population_2017.csv")

dd <- injuries_2017 |> mutate(age = case_when(age < 1 ~ 0, age < 2 ~ 1, TRUE ~ age))
write_csv(dd, "neiss/injuries_2017.csv")


pop <- population_2017 |> rename(population = n) |> select(-1) |> count(sex)
dd |> filter(sex != 'Unknown') |> count(age, sex, wt = weight) |> 
  left_join(pop, by = c('age', 'sex'))
