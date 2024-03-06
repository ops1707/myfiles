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
# Now try to configure my.cnf file of mysql
    > vi /etc/my.cnf
     datadir=/var/lib/mysql
     socket=/var/lib/mysql/mysql.sock
     user=mysql
     key_buffer_size = 16M
     max_allowed_packet = 16M
     thread_stack = 192K
     thread_cache_size = 8
     # Disabling symbolic-links is recommended to prevent assorted security risks
     symbolic-links=0

     log-error=/var/log/mysqld.log
     pid-file=/var/run/mysqld/mysqld.pid
     character-set-server=utf8mb4
     collation-server=utf8mb4_unicode_ci
     init-connect='SET NAMES utf8mb4'
     bind-address = 0.0.0.0

