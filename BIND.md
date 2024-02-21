# installation and configuration of BIND name server
  # First of update and upgrade system 
    >sudo apt update && sudo apt upgrade -y
  # Than begin installation 
    >sudo apt/yum install bind 
  # Install and run chrony before starting named/bind service fo synchronization with ntp server 
    >yum install chrony
    >timedatectl set-timezone Asia/Tashkent
    >syatemctl enable chronyd --now
  # we should write suitable configuration to named.conf file 
    >vi /etc/named.conf
      options {
        listen-on port 53 { 127.0.0.1; 192.168.1.100; };
        listen-on-v6 port 53 { none; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        recursing-file  "/var/named/data/named.recursing";
        secroots-file   "/var/named/data/named.secroots";
        allow-query     { localhost; 192.168.1.0/24; };
        forward first ;
        forwarders      { 10.200.205.10; 8.8.8.8; };
        recursion yes;

        dnssec-enable yes;
        dnssec-validation yes;

        /* Path to ISC DLV key */
        bindkeys-file "/etc/named.root.key";

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
       };
        logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
        };

        zone "." IN {
                type hint;
                file "named.ca";
