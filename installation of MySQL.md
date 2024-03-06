# First of all make sure you don't have any packages of mysql
    > sudo yum remove mysql mysql-server mysql-libs
    > sudo rm -rf /var/lib/mysql/
    > sudo rm /etc/my.cnf
# Add mysql repos
    > yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
# Install mysql-server
    > yum install mysql-community-server --nogpgcheck
# Running mysql service  
    > sudo systemctl start mysqld
    > sudo systemctl enable mysqld
# Make sure mysql was installed correctly 
    > sudo systemctl status mysqld
    
