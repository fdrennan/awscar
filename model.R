# devtools::install_github("gregce/ipify")
# install.packages("caret", dependencies = TRUE)
# install.packages("caTools", dependencies = TRUE)
# install.packages("evtree", dependencies = TRUE)
# install.packages("twilio")

# ssh -i "Shiny.pem" ubuntu@ec2-18-222-226-213.us-east-2.compute.amazonaws.com

library(tidyverse)
library(tibble)
library(jsonlite)
library(caret)
library(caTools)
library(ipify)
library(awscar)
library(twilio)

# Meta data
model_name = "irissuccessful"
localhost  = "50.236.138.35"
current_ip = get_ip()
home       = current_ip == localhost
receive    = FALSE

if(!home) {
  # First you need to set up your accound SID and token as environmental variables
  Sys.setenv(TWILIO_SID = "AC30a981ac2a62872cfae61cab6d6425cb")
  Sys.setenv(TWILIO_TOKEN = "13e0c879af0aff8b0f4fad93cf3c7209")
  
  # Then we're just going to store the numbers in some variables
  my_phone_number <- "2549318313"
  twilios_phone_number <- "12548314407"
  
  # Now we can send away!
  tw_send_message(from = twilios_phone_number, 
                  to = my_phone_number, 
                  body = model_name)
  
}


if(home) {
  # Do some pre-processing
  sampleSplit = sample.split(iris, .7)
  train = iris[sampleSplit,]
  test = iris[-sampleSplit,]
  write_csv(train, 'train.csv')
  write_csv(test, 'test.csv')
  

}

# Create the model formula
modelForm = formula(Species ~ .)
model     = "evtree"

# Code to run server side.
if(!home) {
  get_it(model_name)
  train = read_csv('train.csv')
  test  = read_csv('test.csv')
  control <- trainControl(method="repeatedcv", number=2, repeats=1)
  fit <- train(modelForm , data=train, method=model, trControl = control)
  # pred = predict(fit,  test)
  saveRDS(fit, paste0(model_name,"_model.rda"))
  system(paste0("aws s3 cp ", model_name, "_model.rda", " s3://awscar/",model_name, "_model.rda"))
  
  if(!home) {
    # Now we can send away!
    tw_send_message(from = twilios_phone_number, 
                    to = my_phone_number, 
                    body = paste0(model_name, " has been sent back!"))
  }
  
}

if(receive) {
  system(paste0("aws s3 cp ", " s3://awscar/",model_name, "_model.rda ", model_name, "_model.rda"))
}







