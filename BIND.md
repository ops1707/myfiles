# installation and configuration of BIND name server
  # First of update and upgrade system 
    >sudo apt update && sudo apt upgrade -y
  # Than begin installation 
    >sudo apt/yum install bind 
  # Install and run chrony before starting named/bind service fo synchronization with ntp server 
    >yum install chrony
    >timedatectl set-timezone Asia/Tashkent
    >systemctl enable chronyd --now
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
   # Install utilities name server BIND
        > yum install bind-utils
   # Check BIND request does it work
        > nslookup kun.uz 192.168.1.100
   # It was origin configurations , now we will create our dns-zone. First of all should make directory
        > mkdir /etc/named/master-zones
   # After we should create .zone configuration file 
        > vi /etc/named/master-zones/sj.uz.local.zone
   # write into this file next configurations 
         $ttl 3600
         $ORIGIN  sj.uz.
         sj.uz.               IN              SOA  (
         ns.sj.uz.
         abuse.sj.uz.
                                2024041201
                                10800
                                1200
                                604800
                                3600   )

         @                               IN              NS              ns.sj.uz.
         @                               IN              NS              ns2.sj.uz.
         ns                              IN              NS              bicasso.sj.uz.

         @                               IN              A                192.168.1.100
         ns                              IN              A                192.168.1.50
         ns2                             IN              A                192.168.1.100
         bicasso                         IN              A                192.168.1.50
   # after that we will add several strings to /etc/named.conf 
         zone "sj.uz" {
                 type master;
                 file "/etc/named/master-zones/sj.uz.local.zone";
         };
   # Checking dns zone 
        > named-checkzone sj.uz /etc/named/master-zones/sj.uz.local.zone
   # At the end restart service 
        > systemctl restart named
        



   
