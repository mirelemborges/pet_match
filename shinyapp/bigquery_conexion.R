#install.packages("dbplyr")

require(dplyr)
require(tidyr)
require(DBI)
require(bigrquery)

# big query connection
con <- dbConnect(
  bigrquery::bigquery(),
  project = "pet-match-378611",
  dataset = "pet_match"
)

## list tables
dbListTables(con)

## Get data from Big Query to local
db <- tbl(con, 'cleaned_adoption_list_table') %>% 
  collect()
