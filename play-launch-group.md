play-launch-group
================
Rick O. Gilmore
2017-05-30 09:00:12

Background
----------

This report describes the characteristics of the data collection and coding sites and the launch group members.

Generate data file
------------------

Open the project roster.

``` r
launch_group <- read.csv(paste0(csv.dir, "play-roster.csv"), stringsAsFactors = FALSE)

# New/Not_new
launch_group %>% 
  group_by(New) %>% 
  summarise(N = n()) %>%
  knitr::kable()
```

| New      |    N|
|:---------|----:|
| New      |   20|
| Not\_new |   42|

``` r
# Gender
launch_group %>% 
  group_by(Gender) %>% 
  summarise(N = n()) %>%
  knitr::kable()
```

| Gender |    N|
|:-------|----:|
| Female |   41|
| Male   |   21|

``` r
# White/non
launch_group %>% 
  group_by(Race_eth) %>% 
  summarise(N = n()) %>%
  knitr::kable()
```

| Race\_eth  |    N|
|:-----------|----:|
| Non\_white |   12|
| White      |   50|

``` r
# Institution Type
launch_group %>% 
  group_by(Institution_Type) %>% 
  summarise(N = n()) %>%
  knitr::kable()
```

| Institution\_Type |    N|
|:------------------|----:|
| Govt              |    1|
| Hospital          |    1|
| Private           |   22|
| Public            |   38|

``` r
# R-15 eligible
# Institution Type
launch_group %>% 
  group_by(R15_eligible) %>% 
  summarise(N = n()) %>%
  knitr::kable()
```

| R15\_eligible |    N|
|:--------------|----:|
| Eligible      |   12|
| Not\_eligible |   50|
