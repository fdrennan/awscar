library(awscar)
library(jsonlite)

instructions = fromJSON("instructions.txt")
setwd(instructions$model_name)
system("/usr/bin/Rscript model.R")
