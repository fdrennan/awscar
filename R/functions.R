#' @export zip_it
zip_it <- function(model_name) {
  zip_dir = paste0(model_name, "_send")
  zip(zip_dir, c("model.R", "test.csv", "train.csv", "instructions.txt"))
  file.copy(paste0(model_name, "_send.zip"), paste0(zip_dir, "/", model_name, ".zip"))
  file.remove(paste0(model_name, "_send.zip"))
}


# aws s3 cp /tmp/foo/ s3://awscar/
#' @export send_it
send_it <- function(model_name) {
  model_location = paste0(model_name, "_send/", model_name, ".zip")
  bash_query = paste0("aws s3 cp ", model_location, " s3://awscar/", paste0(model_name, ".zip"))
  system(bash_query)
}

#' @export get_it
get_it <- function(model_name) {
  model_zip = paste0(model_name, ".zip")
  system(paste0("mkdir ",model_name))
  bash_query = paste0("aws s3 cp ", " s3://awscar/", model_zip," ", model_name, "/", model_zip)
  system(bash_query)
  unzip(paste0(model_name, "/", model_name, ".zip"), exdir = model_name)
}

#' @export test_file
test_file <- function(receive = TRUE) {
  if(!receive) {
    system("touch testfile")
    bash_query = paste0("aws s3 cp testfile s3://awscar/testfile")
    system(bash_query)
  } else {
    bash_query = paste0("aws s3 cp s3://awscar/testfile testfile")
    system(bash_query)
  }

}

#' @export create_instructions
create_instructions <- function(model_name = NULL) {
  dir.create(paste0(model_name, "_send"))
  meta_data = tibble(model_name = model_name)
  meta_data = toJSON(meta_data, pretty = TRUE) %>% as.character()
  write.table(meta_data,
              paste0(model_name, "_send/", "instructions.txt"),
              row.names = FALSE,
              col.names = FALSE,
              quote = FALSE)
}

#' @export send_instructions
send_instructions <- function(model_name) {

  file_path = paste0(model_name, "_send/instructions.txt")

  bash_query = paste0('aws s3 cp ',file_path,' s3://awscar/instructions.txt')
  system(bash_query)

}

