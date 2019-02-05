#####################################################################
# The following example is taken from the Deep Learning with R book #
# and adapted to our specific use cas                               #
#####################################################################

library(keras)
library(cloudml)

conv_base <- application_vgg16(
  weights = "imagenet",
  include_top = FALSE,
  input_shape = c(150, 150, 3)
)

fewda_model <- keras_model_sequential() %>%
  conv_base %>%
  layer_flatten() %>%
  layer_dense(units = 256, activation = "relu") %>%
  layer_dense(units = 1, activation = "sigmoid")

freeze_weights(conv_base)

# It is assumed the files are located in a bucket 
# on Google Cloud Storage.
# If the files are kept locally, please change the base_dir variable
base_dir <- "gs://hot-dog"
train_dir <- file.path(base_dir, "train")
validation_dir <- file.path(base_dir, "validation")

train_datagen = image_data_generator(
  rescale = 1/255,
  rotation_range = 40,
  width_shift_range = 0.2,
  height_shift_range = 0.2,
  shear_range = 0.2,
  zoom_range = 0.2,
  horizontal_flip = TRUE,
  fill_mode = "nearest"
)

train_generator <- flow_images_from_directory(
  gs_data_dir_local(train_dir), # see ?gs_data_dir_local for more info
  train_datagen,
  target_size = c(150, 150),
  batch_size = 20,
  class_mode = "binary"
)

test_datagen <- image_data_generator(rescale = 1/255)
validation_generator <- flow_images_from_directory(
  gs_data_dir_local(validation_dir),
  test_datagen,
  target_size = c(150, 150),
  batch_size = 20,
  class_mode = "binary"
)

fewda_model %>% compile(
  loss = "binary_crossentropy",
  optimizer = optimizer_rmsprop(lr = 2e-5),
  metrics = c("accuracy")
)

history <- fewda_model %>% fit_generator(
  train_generator,
  steps_per_epoch = 100,
  epochs = 5,
  validation_data = validation_generator,
  validation_steps = 50
)

# You can save the model weights to cloud storage and download them for later use
# save_model_hdf5(fewda_model, "fewda_model.h5")
# gs_copy("fewda_model.h5", "gs://hot-dog/fewda_model.h5")
# or you can export the saved model and deploy it later
export_savedmodel(fewda_model, "savedmodel")