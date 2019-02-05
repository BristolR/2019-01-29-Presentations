# Authentication is done through the global variables
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
# which are the access keys you can get after creating an user
library(aws.s3)
# get list of buckets
bucketlist()
# create a bucket
put_bucket("hot-dog")

# transfer files
setwd("data")
files <- list.files("train", full.names=TRUE, recursive=TRUE)
for(f in files){
  put_object(f, bucket="hot-dog", object=f)
}

files <- list.files("validation", full.names=TRUE, recursive=TRUE)
for(f in files){
  result <- put_object(f, bucket="hot-dog", object=f)
}

# The following example is taken from 
# https://github.com/cloudyr/aws.ec2/
# but it does not work, I'm not sure where the error lies either
# for more information contact the package authors
library(aws.ec2)
image <- "ami-061a59e27c8da0b93"
describe_images(image)

subnets <- describe_subnets()
ips <- describe_ips()
ips[[1L]] <- allocate_ip("vpc")

my_keypair <- create_keypair("r-ec2-example")
pem_file <- tempfile(fileext = ".pem")
cat(my_keypair[[1]], file = pem_file)


i <- run_instances(image = image, 
                   type = "t2.micro")
instance_ip <- get_instance_public_ip(i)

stop_instances(i[[1L]])
