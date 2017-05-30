Data collection site demographics
================
Rick O. Gilmore
2017-05-30 08:23:20

Background
----------

This report provides preliminary analysis of the demographic characteristics of the sites under consideration to collect data for the PLAY project. This report focuses on data at the county level. It uses the [`choroplethr`](https://cran.r-project.org/web/packages/choroplethr/index.html) package.

Generate data file(s)
---------------------

Load county names, and add county FIPS from `choroplethr` package's `county.regions` dataset. With this, I can extract demographic data using the `get_county_demographics()` function.

``` r
counties <- read.csv(paste0(csv.dir, "city-state-county.csv"), stringsAsFactors = FALSE)

# Load county data from choroplethr
# Could also use acs package to get updated info.
data("county.regions")

counties <- left_join(counties, county.regions)

demo <- get_county_demographics(endyear=2013, span=5)

county.demo <- left_join(counties, demo)

# Recapitalize county
county.demo$County <- unlist(lapply(county.demo$County, Cap.all))
```

Tabular summary
---------------

``` r
# Select collecting sites only
county.demo %>%
  filter(Collecting == "Collecting") ->
  county.demo

county.demo %>%
  arrange(US.Region, Site.code, State, City, County) %>%
  select(US.Region, Site.code, City, State, County, total_population, percent_white,
         percent_black, percent_asian, percent_hispanic) %>%
  knitr::kable()
```

| US.Region | Site.code | City            | State | County               |  total\_population|  percent\_white|  percent\_black|  percent\_asian|  percent\_hispanic|
|:----------|:----------|:----------------|:------|:---------------------|------------------:|---------------:|---------------:|---------------:|------------------:|
| East      | BU        | Boston          | MA    | Suffolk              |             735701|              48|              20|               8|                 20|
| East      | CHOP      | Camden          | NJ    | Camden               |             513512|              60|              18|               5|                 15|
| East      | CHOP      | Woodbury        | NJ    | Gloucester           |             289098|              80|              10|               3|                  5|
| East      | CHOP      | Doylestown      | PA    | Bucks                |             625977|              86|               4|               4|                  4|
| East      | CHOP      | Media           | PA    | Delaware             |             559771|              70|              20|               5|                  3|
| East      | CHOP      | Norristown      | PA    | Montgomery           |             804621|              78|               9|               7|                  4|
| East      | CHOP      | Philadelphia    | PA    | Philadelphia         |            1536704|              37|              42|               6|                 13|
| East      | CHOP      | West Chester    | PA    | Chester              |             503075|              82|               6|               4|                  7|
| East      | COR       | Ithaca          | NY    | Tompkins             |             102270|              79|               4|              10|                  4|
| East      | CUNYSI    | Staten Island   | NY    | Richmond             |             470223|              64|              10|               8|                 17|
| East      | GTN       | Washington      | DC    | District Of columbia |             619371|              35|              49|               3|                 10|
| East      | GTN       | Bethesda        | MD    | Montgomery           |             989474|              48|              17|              14|                 17|
| East      | GTN       | Arlington       | VA    | Arlington            |             214861|              64|               8|               9|                 15|
| East      | NYU       | New York        | NY    | New York             |            1605272|              48|              13|              11|                 26|
| East      | PRIN      | Princeton       | NJ    | Mercer               |             368094|              54|              19|               9|                 16|
| East      | PSU       | University Park | PA    | Centre               |             154460|              88|               3|               5|                  3|
| East      | RUTG      | Newark          | NJ    | Essex                |             785853|              33|              39|               5|                 21|
| East      | VCU       | Chesterfield    | VA    | Chesterfield         |             320430|              65|              22|               3|                  7|
| East      | VCU       | Richmond        | VA    | Richmond             |             207878|              39|              49|               2|                  6|
| Midwest   | IU        | Bloomington     | IN    | Monroe               |             139634|              86|               3|               6|                  3|
| Midwest   | MSU       | East Lansing    | MI    | Clinton              |              14017|              96|               1|               1|                  1|
| Midwest   | MSU       | East Lansing    | MI    | Ingham               |             281531|              72|              11|               5|                  7|
| Midwest   | OSU       | Columbus        | OH    | Franklin             |            1181824|              67|              21|               4|                  5|
| Midwest   | PITT      | Pittsburgh      | PA    | Allegheny            |            1226933|              80|              13|               3|                  2|
| Midwest   | PUR       | W. Lafayette    | IN    | Tippecanoe           |             175628|              80|               4|               7|                  8|
| South     | EMRY      | Atlanta         | GA    | Fulton               |             948554|              41|              44|               6|                  8|
| South     | HOU       | Houston         | TX    | Harris               |            4182285|              33|              19|               6|                 41|
| South     | TUL       | New Orleans     | LA    | Orleans              |             357013|              31|              59|               3|                  5|
| South     | UMIA      | Miami           | FL    | Miami-Dade           |            2549075|              16|              17|               2|                 65|
| South     | UT        | Austin          | TX    | Travis               |            1063248|              50|               8|               6|                 34|
| South     | VBLT      | Franklin        | TN    | Williamson           |             188935|              86|               4|               3|                  5|
| South     | VBLT      | Nashville       | TN    | Davidson             |             638395|              57|              28|               3|                 10|
| South     | VCU       | Richmond        | VA    | Henrico              |             311314|              56|              29|               7|                  5|
| South     | WM        | Williamsburg    | VA    | James City           |              68171|              77|              13|               3|                  5|
| West      | CSF       | Fullerton       | CA    | Orange               |            3051771|              43|               2|              18|                 34|
| West      | CSL       | Long Beach      | CA    | Los Angeles          |            9893481|              28|               8|              14|                 48|
| West      | STAN      | Palo Alto       | CA    | San Mateo            |             729543|              42|               3|              25|                 25|
| West      | STAN      | Palo Alto       | CA    | Santa Clara          |            1812208|              35|               2|              32|                 27|
| West      | UCD       | Davis           | CA    | Yolo                 |             202288|              49|               2|              13|                 31|
| West      | UCM       | Merced          | CA    | Merced               |             258707|              31|               3|               8|                 56|
| West      | UCR       | Riverside       | CA    | Riverside            |            2228528|              39|               6|               6|                 46|
| West      | UCSC      | Santa Cruz      | CA    | Santa Cruz           |             264808|              59|               1|               4|                 32|
| West      | UO        | Eugene          | OR    | Lane                 |             353382|              84|               1|               2|                  8|

### Summaries across sites

``` r
county.demo %>%
  arrange(US.Region, Site.code, State, City, County) %>%
  select(US.Region, Site.code, City, State, County, total_population, percent_white,
         percent_black, percent_asian, percent_hispanic) %>%
  group_by(US.Region) %>%
  summarise(med_black = median(percent_black),
            min_black = min(percent_black),
            max_black = max(percent_black),
            med_hisp = median(percent_hispanic),
            min_hisp = min(percent_hispanic),
            max_hisp = max(percent_hispanic))%>%
  knitr::kable()
```

|  med\_black|  min\_black|  max\_black|  med\_hisp|  min\_hisp|  max\_hisp|
|-----------:|-----------:|-----------:|----------:|----------:|----------:|
|          10|           1|          59|         10|          1|         65|

Population by region
--------------------

``` r
county.demo %>%
  ggplot() +
  aes(x = US.Region, y = total_population) +
  geom_violin() +
  geom_point() +
  ggtitle("Population by region")
```

![](img/pop-by-region-boxplot-1.png)

Race, ethnicity, & age
----------------------

``` r
county.demo %>%
  ggplot() +
  aes(x = US.Region, y = percent_black) +
  geom_violin() +
  geom_point() +
  ggtitle("African American population by region") +
  ylab("% African American")
```

![](img/black-1.png)

``` r
county.demo %>%
  ggplot() +
  aes(x = US.Region, y = percent_hispanic) +
  geom_violin() +
  geom_point() +
  ggtitle("Hispanic population by region") +
  ylab("% Hispanic")
```

![](img/hispanic-1.png)

``` r
county.demo %>%
  ggplot() +
  aes(x = US.Region, y = percent_asian) +
  geom_violin() +
  geom_point() +
  ggtitle("Asian population by region") +
  ylab("% Asian")
```

![](img/asian-1.png)

``` r
county.demo %>%
  ggplot() +
  aes(x = percent_black, y = percent_hispanic, 
      color = US.Region,
      size = total_population) +
  geom_point() +
  ggtitle("Percent African American vs. Hispanic") +
  xlab("% African American") +
  ylab("% Hispanic")
```

![](img/black-hispanic-region-1.png)

``` r
county.demo %>%
  ggplot() +
  aes(x = percent_black, y = percent_asian, 
      color = US.Region,
      size = total_population) +
  geom_point() +
  ggtitle("Percent African American vs. Asian") +
  xlab("% African American") +
  ylab("% Asian")
```

![](img/black-asian-region-1.png)

``` r
county.demo %>%
  ggplot() +
  aes(x = percent_hispanic, y = percent_asian, 
      color = US.Region,
      size = total_population) +
  geom_point() +
  ggtitle("Percent Hispanic vs. Asian") +
  xlab("% Hispanic") +
  ylab("% Asian")
```

![](img/hispanic-asian-region-1.png)

``` r
county.demo %>%
  ggplot() +
  aes(x = US.Region, y = median_age) +
  geom_violin() +
  geom_point() +
  ggtitle("Median age by region") +
  ylab("Age (yrs)")
```

![](img/age-1.png)

Economic indicators
-------------------

``` r
county.demo %>%
  arrange(US.Region, Site.code, State, City, County) %>%
  select(US.Region, Site.code, City, State, County, total_population,
         per_capita_income, median_rent) %>%
  knitr::kable()
```

| US.Region | Site.code | City            | State | County               |  total\_population|  per\_capita\_income|  median\_rent|
|:----------|:----------|:----------------|:------|:---------------------|------------------:|--------------------:|-------------:|
| East      | BU        | Boston          | MA    | Suffolk              |             735701|                32835|          1135|
| East      | CHOP      | Camden          | NJ    | Camden               |             513512|                30592|           835|
| East      | CHOP      | Woodbury        | NJ    | Gloucester           |             289098|                32600|           893|
| East      | CHOP      | Doylestown      | PA    | Bucks                |             625977|                37466|           964|
| East      | CHOP      | Media           | PA    | Delaware             |             559771|                33179|           826|
| East      | CHOP      | Norristown      | PA    | Montgomery           |             804621|                41472|           976|
| East      | CHOP      | Philadelphia    | PA    | Philadelphia         |            1536704|                22279|           721|
| East      | CHOP      | West Chester    | PA    | Chester              |             503075|                42210|          1004|
| East      | COR       | Ithaca          | NY    | Tompkins             |             102270|                27418|           857|
| East      | CUNYSI    | Staten Island   | NY    | Richmond             |             470223|                31823|          1017|
| East      | GTN       | Washington      | DC    | District Of columbia |             619371|                45290|          1154|
| East      | GTN       | Bethesda        | MD    | Montgomery           |             989474|                49038|          1423|
| East      | GTN       | Arlington       | VA    | Arlington            |             214861|                62018|          1659|
| East      | NYU       | New York        | NY    | New York             |            1605272|                62498|          1342|
| East      | PRIN      | Princeton       | NJ    | Mercer               |             368094|                37465|           959|
| East      | PSU       | University Park | PA    | Centre               |             154460|                25545|           795|
| East      | RUTG      | Newark          | NJ    | Essex                |             785853|                32181|           917|
| East      | VCU       | Chesterfield    | VA    | Chesterfield         |             320430|                32572|           918|
| East      | VCU       | Richmond        | VA    | Richmond             |             207878|                27184|           719|
| Midwest   | IU        | Bloomington     | IN    | Monroe               |             139634|                23032|           679|
| Midwest   | MSU       | East Lansing    | MI    | Clinton              |              14017|                21492|           492|
| Midwest   | MSU       | East Lansing    | MI    | Ingham               |             281531|                24754|           664|
| Midwest   | OSU       | Columbus        | OH    | Franklin             |            1181824|                28283|           658|
| Midwest   | PITT      | Pittsburgh      | PA    | Allegheny            |            1226933|                31593|           603|
| Midwest   | PUR       | W. Lafayette    | IN    | Tippecanoe           |             175628|                23691|           650|
| South     | EMRY      | Atlanta         | GA    | Fulton               |             948554|                36757|           802|
| South     | HOU       | Houston         | TX    | Harris               |            4182285|                27899|           720|
| South     | TUL       | New Orleans     | LA    | Orleans              |             357013|                26500|           765|
| South     | UMIA      | Miami           | FL    | Miami-Dade           |            2549075|                23174|           949|
| South     | UT        | Austin          | TX    | Travis               |            1063248|                33206|           832|
| South     | VBLT      | Franklin        | TN    | Williamson           |             188935|                41292|           936|
| South     | VBLT      | Nashville       | TN    | Davidson             |             638395|                28467|           691|
| South     | VCU       | Richmond        | VA    | Henrico              |             311314|                33115|           858|
| South     | WM        | Williamsburg    | VA    | James City           |              68171|                39133|          1048|
| West      | CSF       | Fullerton       | CA    | Orange               |            3051771|                34057|          1413|
| West      | CSL       | Long Beach      | CA    | Los Angeles          |            9893481|                27749|          1110|
| West      | STAN      | Palo Alto       | CA    | San Mateo            |             729543|                45732|          1509|
| West      | STAN      | Palo Alto       | CA    | Santa Clara          |            1812208|                41513|          1473|
| West      | UCD       | Davis           | CA    | Yolo                 |             202288|                27730|           991|
| West      | UCM       | Merced          | CA    | Merced               |             258707|                18177|           725|
| West      | UCR       | Riverside       | CA    | Riverside            |            2228528|                23591|          1015|
| West      | UCSC      | Santa Cruz      | CA    | Santa Cruz           |             264808|                32295|          1282|
| West      | UO        | Eugene          | OR    | Lane                 |             353382|                24224|           720|

### Summary across counties

This plots the median (min & max) of the per capita income and the median (min & max) of median rent.

``` r
county.demo %>%
  arrange(US.Region, Site.code, State, City, County) %>%
  select(US.Region, Site.code, City, State, County, total_population,
         per_capita_income, median_rent) %>%
  group_by(US.Region) %>%
  summarize(med_per_cap_inc = median(per_capita_income),
            min_per_cap_inc = min(per_capita_income),
            max_per_cap_inc = max(per_capita_income),
            med_med_rent = median(median_rent),
            min_med_rent = min(median_rent),
            max_med_rent = max(median_rent)) %>%
  knitr::kable()
```

|  med\_per\_cap\_inc|  min\_per\_cap\_inc|  max\_per\_cap\_inc|  med\_med\_rent|  min\_med\_rent|  max\_med\_rent|
|-------------------:|-------------------:|-------------------:|---------------:|---------------:|---------------:|
|               32181|               18177|               62498|             917|             492|            1659|

``` r
county.demo %>%
  ggplot() +
  aes(x = per_capita_income, y = median_rent,
      color = US.Region,
      size = total_population) +
  geom_point() +
  ggtitle("Median rent by per capita income")
```

![](img/income-rent-region-1.png)

Further exploration of the ACS
------------------------------

The `acs` package manual can be found here: <https://cran.r-project.org/web/packages/acs/acs.pdf>. A useful guide to the ACS can be found here: <https://www.census.gov/content/dam/Census/library/publications/2008/acs/ACSGeneralHandbook.pdf>. And, an especially useful guide by the `acs` package author can be found here: <http://dusp.mit.edu/sites/dusp.mit.edu/files/attachments/publications/working_with_acs_R_v_2.0.pdf>

### Generate geography for sites

As a first attempt, create vectors of numeric state FIPS and county FIPS codes.

``` r
state.fips <- as.numeric(county.demo$state.fips.character)
county.fips <- as.numeric(substr(county.demo$county.fips.character,3,5))
play.geo <- geo.make(state = state.fips, county = county.fips)
```

This works, but after some further exploration, I think it may be better to generate site-specific geographies.

``` r
Make.county.geo <- function(i, df) {
  geo.make(state = as.numeric(df$state.fips.character[i]),
              county =
             as.numeric(substr(county.demo$county.fips.character[i],4, 6)))
}

cty <- 1
# Generate name for county-level geography
geo.name <- paste0(county.demo$Site.code[cty], "_", county.demo$county.name[cty], "_", county.demo$State[cty])

# Create geography and assign to generated name
assign(geo.name, Make.county.geo(cty, county.demo))
```

### Education data

``` r
ed.attain <- acs.lookup(table.name="Educational Attainment for the Population 25 Years and Over", endyear=2015)

# Variables 1:25 seem to contain the relevant info
play.ed <- acs.fetch(geography = play.geo, endyear = 2015, variable = ed.attain[1:25],
                     col.names = c("Total",
                                   "None",
                                   "<K",
                                   "K",
                                   "1st",
                                   "2nd",
                                   "3rd",
                                   "4th",
                                   "5th",
                                   "6th",
                                   "7th",
                                   "8th",
                                   "9th",
                                   "10th",
                                   "11th",
                                   "12th",
                                   "HS",
                                   "GED",
                                   "Coll <1yr",
                                   "Coll >1yr",
                                   "AA",
                                   "BA",
                                   "MA",
                                   "Prof",
                                   "Ph.D"))

# Let's collapse for row/county = 1

(lt.hs <- sum(play.ed[1,2:16]))
```

    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                 
    ## Suffolk County, Massachusetts 80333 +/- 2261.53156069067

``` r
(hs.grad <- sum(play.ed[1,17:18]))
```

    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                  
    ## Suffolk County, Massachusetts 120730 +/- 2379.20406859101

``` r
(some.coll <- sum(play.ed[1,19:21]))
```

    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                 
    ## Suffolk County, Massachusetts 97189 +/- 2252.18138701127

``` r
(BA <- sum(play.ed[1,22]))
```

    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               BA             
    ## Suffolk County, Massachusetts 118717 +/- 2039

``` r
(MA.plus <- sum(play.ed[1,23:25]))
```

    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                 
    ## Suffolk County, Massachusetts 94435 +/- 1963.42201271148

``` r
# Table B15003
# ed.table.B15003 <- acs.fetch(geography = play.geo, endyear = 2015, table.number = "B15003")
# 
# ed.table.B15003
```

``` r
# Columns 2:16 are grades < HS diploma
lapply(1:dim(play.ed)[1], function(i) c(play.ed[i,1], sum(play.ed[i,2:16])))
```

    ## [[1]]
    ## [[1]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               Total         
    ## Suffolk County, Massachusetts 511404 +/- 109
    ## 
    ## [[1]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                 
    ## Suffolk County, Massachusetts 80333 +/- 2261.53156069067
    ## 
    ## 
    ## [[2]]
    ## [[2]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                   Total         
    ## Philadelphia County, Pennsylvania 1024009 +/- 91
    ## 
    ## [[2]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                   aggregate                  
    ## Philadelphia County, Pennsylvania 184130 +/- 3456.01895249433
    ## 
    ## 
    ## [[3]]
    ## [[3]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               Total        
    ## Delaware County, Pennsylvania 376325 +/- 51
    ## 
    ## [[3]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                 
    ## Delaware County, Pennsylvania 29328 +/- 1231.89812890515
    ## 
    ## 
    ## [[4]]
    ## [[4]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                 Total        
    ## Montgomery County, Pennsylvania 568085 +/- 62
    ## 
    ## [[4]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                 aggregate                 
    ## Montgomery County, Pennsylvania 35497 +/- 1238.02382852674
    ## 
    ## 
    ## [[5]]
    ## [[5]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                              Total        
    ## Chester County, Pennsylvania 342356 +/- 85
    ## 
    ## [[5]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                              aggregate                 
    ## Chester County, Pennsylvania 24911 +/- 1171.04525958649
    ## 
    ## 
    ## [[6]]
    ## [[6]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            Total        
    ## Bucks County, Pennsylvania 440969 +/- 50
    ## 
    ## [[6]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            aggregate                 
    ## Bucks County, Pennsylvania 28849 +/- 1164.76049040135
    ## 
    ## 
    ## [[7]]
    ## [[7]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total        
    ## Camden County, New Jersey 346315 +/- 83
    ## 
    ## [[7]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                
    ## Camden County, New Jersey 41815 +/- 1448.3494053577
    ## 
    ## 
    ## [[8]]
    ## [[8]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               Total        
    ## Gloucester County, New Jersey 196038 +/- 60
    ## 
    ## [[8]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                 
    ## Gloucester County, New Jersey 16340 +/- 863.357399921956
    ## 
    ## 
    ## [[9]]
    ## [[9]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total       
    ## Tompkins County, New York 59323 +/- 87
    ## 
    ## [[9]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                
    ## Tompkins County, New York 3419 +/- 440.226078282512
    ## 
    ## 
    ## [[10]]
    ## [[10]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total        
    ## Orange County, California 2077783 +/- 0
    ## 
    ## [[10]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                  
    ## Orange County, California 326861 +/- 4698.71918718282
    ## 
    ## 
    ## [[11]]
    ## [[11]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                Total        
    ## Los Angeles County, California 6653174 +/- 0
    ## 
    ## [[11]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                aggregate                   
    ## Los Angeles County, California 1511510 +/- 8942.17635701735
    ## 
    ## 
    ## [[12]]
    ## [[12]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total        
    ## Richmond County, New York 322287 +/- 68
    ## 
    ## [[12]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                 
    ## Richmond County, New York 36421 +/- 1454.50060158118
    ## 
    ## 
    ## [[13]]
    ## [[13]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                        Total         
    ## Fulton County, Georgia 650445 +/- 138
    ## 
    ## [[13]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                        aggregate                
    ## Fulton County, Georgia 58903 +/- 2294.1126824984
    ## 
    ## 
    ## [[14]]
    ## [[14]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                            Total        
    ## District of Columbia, District of Columbia 453952 +/- 79
    ## 
    ## [[14]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                            aggregate               
    ## District of Columbia, District of Columbia 48430 +/- 1609.396781406
    ## 
    ## 
    ## [[15]]
    ## [[15]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            Total         
    ## Arlington County, Virginia 168459 +/- 177
    ## 
    ## [[15]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            aggregate                
    ## Arlington County, Virginia 10987 +/- 1125.8685536065
    ## 
    ## 
    ## [[16]]
    ## [[16]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                             Total         
    ## Montgomery County, Maryland 698595 +/- 127
    ## 
    ## [[16]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                             aggregate                 
    ## Montgomery County, Maryland 61632 +/- 2042.70433494424
    ## 
    ## 
    ## [[17]]
    ## [[17]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                      Total          
    ## Harris County, Texas 2734398 +/- 197
    ## 
    ## [[17]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                      aggregate                  
    ## Harris County, Texas 558167 +/- 6887.09510606613
    ## 
    ## 
    ## [[18]]
    ## [[18]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                        Total        
    ## Monroe County, Indiana 79416 +/- 101
    ## 
    ## [[18]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                        aggregate                
    ## Monroe County, Indiana 6071 +/- 555.819215213004
    ## 
    ## 
    ## [[19]]
    ## [[19]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                         Total        
    ## Ingham County, Michigan 169257 +/- 92
    ## 
    ## [[19]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                         aggregate                 
    ## Ingham County, Michigan 13883 +/- 796.596510160571
    ## 
    ## 
    ## [[20]]
    ## [[20]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total       
    ## Crawford County, Michigan 10349 +/- 41
    ## 
    ## [[20]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                
    ## Crawford County, Michigan 1296 +/- 152.348285188905
    ## 
    ## 
    ## [[21]]
    ## [[21]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total          
    ## New York County, New York 1229036 +/- 183
    ## 
    ## [[21]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                  
    ## New York County, New York 164399 +/- 3783.59286921836
    ## 
    ## 
    ## [[22]]
    ## [[22]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                       Total         
    ## Franklin County, Ohio 797167 +/- 172
    ## 
    ## [[22]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                       aggregate                 
    ## Franklin County, Ohio 79751 +/- 2152.93659915939
    ## 
    ## 
    ## [[23]]
    ## [[23]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                Total        
    ## Allegheny County, Pennsylvania 877398 +/- 60
    ## 
    ## [[23]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                aggregate                
    ## Allegheny County, Pennsylvania 56666 +/- 1427.9789914421
    ## 
    ## 
    ## [[24]]
    ## [[24]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total        
    ## Mercer County, New Jersey 247262 +/- 54
    ## 
    ## [[24]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                 
    ## Mercer County, New Jersey 31060 +/- 1331.89076128638
    ## 
    ## 
    ## [[25]]
    ## [[25]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                             Total        
    ## Centre County, Pennsylvania 91495 +/- 141
    ## 
    ## [[25]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                             aggregate                
    ## Centre County, Pennsylvania 6242 +/- 535.508169872319
    ## 
    ## 
    ## [[26]]
    ## [[26]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            Total       
    ## Tippecanoe County, Indiana 99327 +/- 47
    ## 
    ## [[26]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            aggregate                
    ## Tippecanoe County, Indiana 9654 +/- 765.762365228274
    ## 
    ## 
    ## [[27]]
    ## [[27]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                          Total         
    ## Essex County, New Jersey 524610 +/- 123
    ## 
    ## [[27]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                          aggregate                 
    ## Essex County, New Jersey 82920 +/- 2120.25187183033
    ## 
    ## 
    ## [[28]]
    ## [[28]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                Total        
    ## Santa Clara County, California 1268629 +/- 0
    ## 
    ## [[28]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                                aggregate                  
    ## Santa Clara County, California 165229 +/- 3063.53211179514
    ## 
    ## 
    ## [[29]]
    ## [[29]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                              Total        
    ## San Mateo County, California 530221 +/- 71
    ## 
    ## [[29]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                              aggregate                 
    ## San Mateo County, California 61888 +/- 2142.73680138276
    ## 
    ## 
    ## [[30]]
    ## [[30]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total        
    ## Orleans Parish, Louisiana 258654 +/- 73
    ## 
    ## [[30]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                 
    ## Orleans Parish, Louisiana 38392 +/- 1227.80576639793
    ## 
    ## 
    ## [[31]]
    ## [[31]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                         Total         
    ## Yolo County, California 120693 +/- 152
    ## 
    ## [[31]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                         aggregate                 
    ## Yolo County, California 17508 +/- 1085.82641338291
    ## 
    ## 
    ## [[32]]
    ## [[32]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           Total         
    ## Merced County, California 152405 +/- 148
    ## 
    ## [[32]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                           aggregate                 
    ## Merced County, California 48959 +/- 1805.96345477975
    ## 
    ## 
    ## [[33]]
    ## [[33]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                              Total        
    ## Riverside County, California 1441999 +/- 0
    ## 
    ## [[33]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                              aggregate                  
    ## Riverside County, California 287146 +/- 4548.82776108307
    ## 
    ## 
    ## [[34]]
    ## [[34]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               Total         
    ## Santa Cruz County, California 173902 +/- 188
    ## 
    ## [[34]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                 
    ## Santa Cruz County, California 25036 +/- 1436.63913353354
    ## 
    ## 
    ## [[35]]
    ## [[35]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            Total          
    ## Miami-Dade County, Florida 1838746 +/- 138
    ## 
    ## [[35]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            aggregate                  
    ## Miami-Dade County, Florida 366110 +/- 5441.92080059973
    ## 
    ## 
    ## [[36]]
    ## [[36]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                     Total         
    ## Lane County, Oregon 241134 +/- 112
    ## 
    ## [[36]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                     aggregate                 
    ## Lane County, Oregon 21442 +/- 1137.21106220437
    ## 
    ## 
    ## [[37]]
    ## [[37]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                      Total        
    ## Travis County, Texas 742369 +/- 43
    ## 
    ## [[37]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                      aggregate                 
    ## Travis County, Texas 90321 +/- 2707.21425084902
    ## 
    ## 
    ## [[38]]
    ## [[38]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            Total        
    ## Davidson County, Tennessee 446174 +/- 72
    ## 
    ## [[38]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                            aggregate                 
    ## Davidson County, Tennessee 56739 +/- 1998.95822867813
    ## 
    ## 
    ## [[39]]
    ## [[39]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                              Total         
    ## Williamson County, Tennessee 128761 +/- 140
    ## 
    ## [[39]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                              aggregate                
    ## Williamson County, Tennessee 5996 +/- 633.792552812038
    ## 
    ## 
    ## [[40]]
    ## [[40]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                          Total        
    ## Henrico County, Virginia 217423 +/- 89
    ## 
    ## [[40]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                          aggregate                 
    ## Henrico County, Virginia 20311 +/- 1167.50760168831
    ## 
    ## 
    ## [[41]]
    ## [[41]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               Total         
    ## Chesterfield County, Virginia 216740 +/- 104
    ## 
    ## [[41]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                               aggregate                 
    ## Chesterfield County, Virginia 19587 +/- 1027.59184504355
    ## 
    ## 
    ## [[42]]
    ## [[42]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                         Total        
    ## Richmond city, Virginia 143240 +/- 64
    ## 
    ## [[42]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                         aggregate                 
    ## Richmond city, Virginia 24087 +/- 1232.49989858012
    ## 
    ## 
    ## [[43]]
    ## [[43]][[1]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                             Total        
    ## James City County, Virginia 50954 +/- 233
    ## 
    ## [[43]][[2]]
    ## ACS DATA: 
    ##  2011 -- 2015 ;
    ##   Estimates w/90% confidence intervals;
    ##   for different intervals, see confint()
    ##                             aggregate                
    ## James City County, Virginia 3163 +/- 509.220973645038

Next steps
----------

1.  ~~We should confirm that our target sites collect data from the counties listed, and that the county-wide demographics are plausible~~.
2.  ~~We should also see if there are *other* counties target sites collect from and consider asking them to estimate the proportion of their recruiting that comes from county A vs. county B~~. It would be fun to have a Shiny app to collect this.
3.  We should explore the `acs` package to grab additional demographic data, especially the indicators used in the draft grant proposal. The `choroplethr` package used in the above had demographic variables similar, but not identical to the ones we have used in the proposal.

Resources
---------

### R Session

This document was prepared in RStudio 1.0.136. Session information follows.

``` r
sessionInfo()
```

    ## R version 3.4.0 (2017-04-21)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS Sierra 10.12.4
    ## 
    ## Matrix products: default
    ## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] choroplethrMaps_1.0.1 choroplethr_3.6.1     acs_2.0              
    ## [4] XML_3.98-1.7          plyr_1.8.4            stringr_1.2.0        
    ## [7] dplyr_0.5.0           ggplot2_2.2.1        
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_0.12.10        lattice_0.20-35     png_0.1-7          
    ##  [4] assertthat_0.2.0    rprojroot_1.2       digest_0.6.12      
    ##  [7] R6_2.2.0            backports_1.0.5     acepack_1.4.1      
    ## [10] evaluate_0.10       highr_0.6           httr_1.2.1         
    ## [13] RgoogleMaps_1.4.1   lazyeval_0.2.0      uuid_0.1-2         
    ## [16] data.table_1.10.4   geosphere_1.5-5     rpart_4.1-11       
    ## [19] Matrix_1.2-9        checkmate_1.8.2     rmarkdown_1.5      
    ## [22] labeling_0.3        proto_1.0.0         splines_3.4.0      
    ## [25] rgdal_1.2-7         udunits2_0.13       foreign_0.8-67     
    ## [28] htmlwidgets_0.8     RCurl_1.95-4.8      munsell_0.4.3      
    ## [31] compiler_3.4.0      tigris_0.5          base64enc_0.1-3    
    ## [34] rgeos_0.3-23        htmltools_0.3.6     nnet_7.3-12        
    ## [37] tibble_1.3.0        gridExtra_2.2.1     htmlTable_1.9      
    ## [40] Hmisc_4.0-3         sf_0.4-1            bitops_1.0-6       
    ## [43] rappdirs_0.3.1      grid_3.4.0          gtable_0.2.0       
    ## [46] DBI_0.6-1           WDI_2.4             pacman_0.4.5       
    ## [49] magrittr_1.5        units_0.4-4         scales_0.4.1       
    ## [52] stringi_1.1.5       mapproj_1.2-4       reshape2_1.4.2     
    ## [55] sp_1.2-4            latticeExtra_0.6-28 Formula_1.2-1      
    ## [58] rjson_0.2.15        RColorBrewer_1.1-2  tools_3.4.0        
    ## [61] ggmap_2.6.1         maps_3.1.1          jpeg_0.1-8         
    ## [64] survival_2.41-3     yaml_2.1.14         colorspace_1.3-2   
    ## [67] cluster_2.0.6       maptools_0.9-2      knitr_1.15.20
