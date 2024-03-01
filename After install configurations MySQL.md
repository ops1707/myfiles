# after installing MySQL server we will enter the default database via default user "root"
    > mysql -u root -p 
# we need password , at the end of installing mysql gives temprorary password. You can show by command
    > grep 'temporary password' /var/log/mysqld.log
# You may change password 
    > ALTER USER 'username'@'hostname' IDENTIFIED BY 'new_password';    
#  As soon you enter you have to create new user and password also drop old one(default)
    > CREATE USER 'new_username'@'hostname' IDENTIFIED BY 'password';
# We will give privilege to new_user     
    > GRANT ALL PRIVILEGES ON *.* TO 'new_username'@'hostname' WITH GRANT OPTION;
# and delete old user(root)
    > DROP USER 'old_user'@'hostname';
# Updating privileges 
    > FLUSH PRIVILEGES;
# Now mysql ready to create database (in this situation my database -> "dbase")
    > create database dbase;
# Create user for database (here my user is testuser ) 
    > create user 'testuser'@'localhost' identified by 'password';
    > grant all on dbase *.* to 'testuser' identified by 'password';
# Exit and reenter via testuser to create new table into new database
    > mysql -u testuser -p
# after entering immediately switch to new database for using 
    > USE dbase
# Creating new table here this is "staffs" 
    > CREATE TABLE users 
     (
      id INT AUTO_INCREMENT PRIMARY KEY,
      username VARCHAR(50) NOT NULL,
      occupation VARCHAR(100) NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
     );     
# Displaying table 
    > SHOW COLUMNS FROM staffs;
# Add data into table 
    > INSERT INTO stuffs ( username, occupation) VALUES
     ('James', 'accauntant'),
     ('robert','target manager');
# To check data by row
    > SELECT username, occupation FROM staffs;
    



    
