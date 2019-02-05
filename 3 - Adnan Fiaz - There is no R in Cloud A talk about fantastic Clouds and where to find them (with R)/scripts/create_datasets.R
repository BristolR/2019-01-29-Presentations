original_dataset_dir <- "all/train"

base_dir <- "data"
dir.create(base_dir)

train_dir <- file.path(base_dir, "train")
dir.create(train_dir)
validation_dir <- file.path(base_dir, "validation")
dir.create(validation_dir)
test_dir <- file.path(base_dir, "test")
dir.create(test_dir)

train_ugly_dir <- file.path(train_dir, "ugly")
dir.create(train_ugly_dir)
train_dogs_dir <- file.path(train_dir, "dogs")
dir.create(train_dogs_dir)

validation_ugly_dir <- file.path(validation_dir, "ugly")
dir.create(validation_ugly_dir)
validation_dogs_dir <- file.path(validation_dir, "dogs")
dir.create(validation_dogs_dir)

test_ugly_dir <- file.path(test_dir, "ugly")
dir.create(test_ugly_dir)
test_dogs_dir <- file.path(test_dir, "dogs")
dir.create(test_dogs_dir)

target_dir <- file.path(base_dir, "target")
fnames <- list.files(target_dir)
fnames_train <- fnames[1:100]
result <- file.copy(file.path(target_dir, fnames_train),
         file.path(train_ugly_dir))
fnames_val <- fnames[101:length(fnames)]
result <- file.copy(file.path(target_dir, fnames_val),
          file.path(validation_ugly_dir))
#fnames <- paste0("cat.", 1501:2000, ".jpg")
#file.copy(file.path(target_dir, fnames),
#          file.path(test_ugly_dir))

fnames <- paste0("dog.", 1:1000, ".jpg")
result <- file.copy(file.path(original_dataset_dir, fnames),
          file.path(train_dogs_dir))
fnames <- paste0("dog.", 1001:1500, ".jpg")
result <- file.copy(file.path(original_dataset_dir, fnames),
          file.path(validation_dogs_dir))
fnames <- paste0("dog.", 1501:2000, ".jpg")
result <- file.copy(file.path(original_dataset_dir, fnames),
          file.path(test_dogs_dir))