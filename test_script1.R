library(reactable)
library(tidyverse)

mtcars |> rownames_to_column(var = 'model')


dat1 <- rnorm(300, mean = 0, sd = 0.5)
dat2 <- rnorm(300, mean = 0.15, sd = 0.9)
tibble(val = c(dat1, dat2),
       grp = c(
         rep("x1", length(dat1)), 
         rep("x2", length(dat2))
       )
) |> 
  ggplot(aes(val, color = grp)) +
  geom_freqpoly(binwidth = 0.1, size = 1) +
  coord_cartesian(xlim = c(-3, 3)) +
  theme(legend.position = c(.9,.9)) +
  labs(title = 'Shiny Demo Plot', color = 'Distributions')


freqpoly <- function(dat1, dat2, binwidth = 0.1, xlim = c(-3, 3)){
  df <- data.frame(
    x = c(dat1, dat2),
    g = c(
      rep("x1", length(dat1)), 
      rep("x2", length(dat2))
    )
  )
  ggplot(df,
         aes(x, color = g)) +
    geom_freqpoly(binwidth = 0.1, size = 1) +
    coord_cartesian(xlim = c(-3, 3))
}

tst_func <- function(dat1, dat2){
  test <- t.test(dat1, dat2)
  # use sprintf() to format t.test() results compactly
  sprintf(
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2]
  )
}

freqpoly(x1, x2)
cat(tst_func(dat1, dat2))


m <- mtcars |> rownames_to_column(var = 'cars') |> tibble()

d <- read_csv('neiss/injuries_2017.csv') |> filter(prod1 == 649) ;
d |> select(2:4, 7:8) |> 
  count(diag)

d |> select(2:4, 7:8) |> 
  head(50) |> 
  mutate(diag = fct_infreq(diag)) |> 
  count(diag)

d |> select(2:4, 7:8) |> 
  head(50) |> 
  mutate(diag = fct_lump_n(diag, 3)) |> 
  count(diag)


d |> select(2:4, 7:8) |> 
  head(50) |> 
  mutate(diag = fct_lump_min(diag, 3)) |> 
  count(diag)

d |> select(2:4, 7:8) |> 
  head(50) |> 
  mutate(diag = fct_lump_prop(diag, .1)) |> 
  count(diag)

d |> select(2:4, 7:8) |> 
  head(50) |> 
  mutate(diag = fct_lump_lowfreq(diag)) |> 
  count(diag)


d |> 
  mutate(diag = fct_lump(fct_infreq(diag), 5)) |> 
  group_by(diag) |> 
  summarise(tot = as.integer(sum(weight)))


mytop5 <- function(df, var, n = 5){
  df |> 
    mutate({{var}} := fct_lump(fct_infreq({{var}}), n = n)) |> 
    group_by({{var}}) |> 
    summarise(tot = as.integer(sum(weight)))
}
mytop5(d, diag)
