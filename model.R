devtools::install_github("gregce/ipify")
install.packages("caret", dependencies = TRUE)
install.packages("caTools", dependencies = TRUE)

# ssh -i "Shiny.pem" ubuntu@ec2-18-222-226-213.us-east-2.compute.amazonaws.com

library(caret)
library(caTools)
library(ipify)

# Meta data
model_name = "caret_100"
localhost  = "73.95.65.153"
current_ip = get_ip()
setting_up_to_send = FALSE

if(setting_up_to_send) {
  create_instructions(model_name)
  send_instructions(model_name)
  zip_it(model_name)
  send_it(model_name)
}


# Do some pre-processing
sampleSplit = sample.split(iris, .7)
train = iris[sampleSplit,]
test = iris[-sampleSplit,]

# Create the model formula
modelForm = formula(Species ~ .)
model     = "cforest"

# Code to run server side.
if(current_ip != localhost) {
  get_it(model_name)
  control <- trainControl(method="repeatedcv", number=2, repeats=1)
  fit <- train(modelForm , data=train, method=model, trControl = control)
  pred = predict(fit,  test)

}





