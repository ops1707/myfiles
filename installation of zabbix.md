# Update all packeges before starting install zabbix
    > yum update  
# Install repositories of Zabbix 
    > rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
    > yum clean all
# Start installation Zabbix
    > yum install -y zabbix-server-pgsql zabbix-web-pgsql-scl zabbix-nginx-conf-scl zabbix-agent
# Then install database I prefer postgresql
    >  yum install -y postgresql-server postgresql
    > postgresql-setup initdb
# Start and enable Postgresql
    > systemctl start postgresql
    > systemctl enable postgresql
# Create user and database in Postgresql
    > sudo -u postgres createuser --pwprompt zabbix
    > sudo -u postgres createdb -O zabbix zabbix
# Import basic Zabbix data to database Postgresql , Make sure import was successfully
    > zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | psql -U zabbix -d zabbix
#  Configure Zabbix Server
    > vi /etc/zabbix/zabbix_server.conf
      DBHost=localhost
      DBName=zabbix
      DBUser=zabbix
      DBPassword=your_password  # Use your password which installed for user zabbix
# Configure Nginx for web-interface Zabbix
    > yum install -y epel-release
    > yum install -y nginx
    > systemctl start nginx
    > systemctl enable nginx
# Edit or create zabbix.conf file   
    > vi /etc/nginx/conf.d/zabbix.conf
      server {
          listen       80;
          server_name  _;

          location / {
              root   /usr/share/zabbix;
              index  index.php;
              try_files $uri $uri/ /index.php?$args;
          }

          location ~ \.php$ {
              root           /usr/share/zabbix;
              fastcgi_pass unix:/run/php-fpm/zabbix.sock;
              fastcgi_index  index.php;
              fastcgi_param  SCRIPT_FILENAME  /usr/share/zabbix$fastcgi_script_name;
              include        fastcgi_params;
           }
       }

# Restart nginx
    > systemctl restart nginx
# Configure PHP 7.2 for Zabbix
    > yum install -y epel-release
    > yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
    > yum install -y yum-utils
    > yum-config-manager --enable remi-php72
    > yum install -y php php-fpm php-pgsql php-mbstring php-gd
# Edit conf file zabbix.conf PHP
    > chown -R nginx:nginx /etc/zabbix/web
    > vi /etc/php-fpm.d/zabbix.conf
        [zabbix]
        user = nginx
        group = nginx
        listen = /run/php-fpm/zabbix.sock
        listen.owner = nginx
        listen.group = nginx
        listen.mode = 0660
        pm = dynamic
        pm.max_children = 5
        pm.start_servers = 2
        pm.min_spare_servers = 1
        pm.max_spare_servers = 3
        php_value[date.timezone] = Asia/Tashkent  # Set suitable timezone
# Run and enable PHP-FPM: 
    > systemctl start php-fpm
    > systemctl enable php-fpm
# Restart zabbix-server and zabbix-agent
    > systemctl start zabbix-server zabbix-agent
    > systemctl enable zabbix-server zabbix-agent
# Configure Firewall and allow ports to connect to web-interface 
    > firewall-cmd --permanent --add-port=8080/tcp
    > firewall-cmd --permanent --add-port=10051/tcp
    > firewall-cmd --reload

    
