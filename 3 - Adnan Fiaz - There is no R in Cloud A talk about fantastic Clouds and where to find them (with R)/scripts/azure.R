library(AzureRMR)
library(AzureStor)

# If this the first time you need to authenticate with password
# See https://blog.revolutionanalytics.com/2018/11/azurermr-azure-resource-manager.html
# on how to get credentials
az <- create_azure_login("insert tenant id", 
                         app="insert app id", 
                         password="insert password")
# If already authenticated you can use get_azure_login
az <- get_azure_login("insert tenant id")
# for the subscription id you will have to go to portal.azure.com and
# search for Subscriptions
sub <- az$get_subscription("enter subscription id")
# You will also have to make sure there is already a resource group
rg <- sub$get_resource_group("hotdog")

# create the storage account
rg$create_storage_account("hotdogstorage")
stor <- rg$get_storage_account("hotdogstorage")

file_endp <- stor$get_file_endpoint()
#fshare <- create_file_share(file_endp, "hot-dog")
fshare <- file_share(file_endp, name="hot-dog")
  
create_azure_dir(fshare, "train")
create_azure_dir(fshare, "train/hotdog")
multiupload_azure_file(fshare, src="data/train/hotdog/*.*", dest="train/hotdog")
create_azure_dir(fshare, "train/nothot")
multiupload_azure_file(fshare, src="data/train/nothot/*.*", dest="train/nothot")

create_azure_dir(fshare, "validation")
create_azure_dir(fshare, "validation/hotdog")
multiupload_azure_file(fshare, src="data/validation/hotdog/*.*", dest="validation/hotdog")
create_azure_dir(fshare, "validation/nothot")
multiupload_azure_file(fshare, src="data/validation/nothot/*.*", dest="validation/nothot")


# create vm's
library(AzureVM)
myVM <- rg$create_vm("mylinuxvm3", os="Ubuntu",
                           username="adnan",
                           passkey="BristolR2019",
                           userauth_type="password")

myVM$run_script('sudo rstudio-server start')
# NB: the above does start the RStudio Server but unfortunately the port
# remains blocked and requires manual intervention from within Azure Portal
# This will hopefully be fixed in later versions of the package

