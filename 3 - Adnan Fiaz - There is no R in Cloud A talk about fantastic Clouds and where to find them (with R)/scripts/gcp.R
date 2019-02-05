# Authentication is done through global variable GCE_AUTH_FILE
# This should point to the json file that you get when creating a service account
library(googleCloudStorageR)

# create bucket
gcs_create_bucket("hot-dog", "hot-dog")

# transfer train/validation folders
setwd("data")
files <- list.files("train", full.names=TRUE, recursive=TRUE)
for(f in files){
  gcs_upload(f, "hot-dog", name=f)
}
files <- list.files("validation", full.names=TRUE, recursive=TRUE)
for(f in files){
  gcs_upload(f, "hot-dog", name=f)
}

# create VM with RStudio
library(googleComputeEngineR)
vm <- gce_vm(template = "rstudio", 
             name = "rstudio-server", username = "thisisnot", 
             password = "notmypassword")

# Train TensorFlow model
library(cloudml)
# If installing for the first time gcloud must be setup
#gcloud_install()
#gcloud_init()
# setting working directory to scripts to ensure only scripts get uploaded
setwd("../scripts")
cloudml_train("fewda_vgg16.R", master_type = "standard_gpu", collect=FALSE)

# Deploy the exported model
# Make sure the model was exported correctly and the run dir is set appropriately
cloudml_deploy(latest_run()$run_dir, name="hotdog")
img <- keras::image_load("dog.jpg", target_size = c(150, 150))
cloudml_predict(list(img), "hotdog")

