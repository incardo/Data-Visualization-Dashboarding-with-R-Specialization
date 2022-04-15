#### Pivots and Joins

library(tidyverse)

#you can create column names in tibbles that have spaces, if you surround the column names with backticks

`High Scores`<-c(4,5,6)
`Low Scores`<-c(1,2,3)

dat<-tibble(`High Scores`,`Low Scores`)
dat$`High Scores`

ggplot(dat,aes(x=`High Scores`,y=`Low Scores`))+geom_point()

#### Pivoting

# We've talked about having data in long versus wide format, and typically the tidyverse prefers using "long" data. To switch between long and wide, you want to use pivot functions

# Example of "wide" data

units<-c("a","b","c")
time1<-c(1,2,3)
time2<-c(4,5,6)
time3<-c(7,8,9)

dat<-tibble(units,time1,time2,time3)
dat
# dat is a wide data set. There is one case per row, but there are three observations per row, not one as tidy data would prefer. We want one row for each observation.

# How do we get from wide to long? pivot_longer

dat_long<-pivot_longer(
  data=dat, # identify the data
  cols=c(time1,time2,time3), # select the columns we want to stretch
  names_to="time", # name a new column that will be home to the pivoted column titles (this will have time1,time2, and time3 in it),
  values_to="score" # name a new column that will be home to the pivoted row values. This will be the sequences of numbers
  
)

dat_long

# If for some reason you wanted to pivot wider again (perhaps for printing a table), use pivot_wider, which is just the opposite

pivot_wider(
  dat_long,
  names_from=time,
  values_from=score
)

#### Joining multiple data sets together.

# We've see joins in the past, but they are important for major projects. Worth reviewing here.



# Let's imagine we have data on these four cities in one spreadsheet, which when we import it looks like this:

cities<-c("New York","London","Canberra","Nairobi")
Var1<-c(runif(4,0,1))

dat_part1<-tibble(cities,Var1)

dat_part1

# We find another spreadsheet with data on cities, and it looks like this:

cities<-c("New York","London","Canberra","Jakarta")
Var2<-c(runif(4,0,1))

dat_part2<-tibble(cities,Var2)
dat_part2
# Joins work based on key values in your data. A key value is an identifier for an observation. Let's assume for now that have unique keys for every observation in your data.

# There is a column with the same title in both datasets, "cities". That is the key.

# We have several basic options for how to merge these datasets together

# Left Join: keep all of the rows the FIRST table in the function, matching data in the SECOND table as possible

left_join(dat_part1,dat_part2,by="cities")

# Here, there is missing data for Nairobi, because there is no Nairobi key value in the second table

# Right Join: keep all of the rows in the SECOND table in the function, matching data in the FIRST table as possible

right_join(dat_part1,dat_part2,by="cities")

# Here, we have Jakarta instead of Nairobi, the flip of the the left_join

# Inner Join: keep only those rows where the key value is in BOTH tables

inner_join(dat_part1,dat_part2,by="cities")

# Full join: keep ALL of the rows in the two tables.

full_join(dat_part1,dat_part2,by="cities")

# Joining data is complex and can be tricky, but for now I am going to assuming you have relatively simple data. For more details, you'll want to read Chapter 13 of R for Data Science.




