# First save this file
if(FALSE) {
  system(paste0("rm -rf ",model_name, "_send"))
  create_instructions(model_name)
  send_instructions(model_name)
  zip_it(model_name)
  send_it(model_name)
}

