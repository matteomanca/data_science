## Original script by Ujjwal Karn: (https://github.com/ujjwalkarn/DataSciencePython/blob/master/Twitter-Data-Analysis/json2tweets.R)


library(jsonlite)
options(encoding = "UTF-8")

# read in individual JSON lines
json_file <- "test.json"

# turn it into a proper array by separating each object with a "," and
# wrapping that up in an array with "[]"'s.

dat <- fromJSON(sprintf("[%s]", paste(readLines(json_file), collapse=",")))

dim(dat)
## [1] 3959   18

tweets<-dat$text
tweets

head(dat$geoLocation$latitude)
