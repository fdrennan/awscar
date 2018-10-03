library(awscar)

instructions = fromJSON("instructions.txt")

get_it(instructions$model_name)
