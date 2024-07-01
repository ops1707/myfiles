# Installiation Docker on Ubuntu 

# First of all remove old installed version of docker from your pc
     > sudo apt-get remove docker docker-engine docker.io containerd runc
# After install certificate curl gnupg lsb-release and update packages
     > sudo apt-get install ca-certificates curl gnupg lsb-release
     > sudo apt-get update     
# Create folder for keys and install keys          
     > sudo mkdir -p /etc/apt/keyrings
     > curl -fsSL https://get.docker.com -o get-docker.sh
# Check script does ot work ?
     > sudo DRY_RUN=1 sh ./get-docker.sh
# Adding user for docker then add this user to docker group
     > sudo useradd -m -s /bin/bash admin
     > sudo usermod -aG docker admin
# this command demonstrates running docker containers 
     > sudo docker ps 
     > sudo docker ps -a
# Creating container "hello-world" 
     > sudo docker run Hello-world 
# If you want set timer for container 
     > sudo docker run <container_name> 
     
     
