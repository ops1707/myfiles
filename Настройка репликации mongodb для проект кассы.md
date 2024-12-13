# Настройка репликации mongodb для проект кассы
# За основу образа mongodb было взято версия mongodb enterprise 4.4.19 
  
# Настроечный файл для запуска mongodb:

    # mongod.conf

    # for documentation of all options, see:
    #   http://docs.mongodb.org/manual/reference/configuration-options/

    # Where and how to store data.
    storage:
      dbPath: /data/db
      journal:
    enabled : true
    #  engine: 
    #  mmapv1:
    #  wiredTiger:

    # where to write logging data.
    systemLog:
      destination: file
      logAppend: true
      path: /var/log/mongodb/mongod.log

    # network interfaces
    net:
      port: 27017
      bindIp: 127.0.0.1
    #kassagw
    #,kassaprod01,kassprod02,kassagw
      tls:
        mode: disabled

    # how the process runs
    processManagement:
      timeZoneInfo: /usr/share/zoneinfo

    #security:
    #authorization: "enabled"

    #operationProfiling:

    #replication:
    #  replSetName: "cashierReplication"

    #sharding:
    ## Enterprise-Only Options:
    #auditLog:
    #snmp:

    sudo docker run -d --name mongo -v /home/uadm/mongo.conf:/etc/mongo.conf -v /home/uadm/key.txt:/etc/key.txt -p      27017:27017 –e MONGODB_INITDB_ROOT_USERNAME=User -e MONGODB_INITDB_ROOT_PASSWORD=Password --add-host kassaprod01:ip_address --add-host kassaprod02:ip_address --add-host kassagw:ip_address mongo:4.4.19 mongod --config /etc/mongo.conf







#Общая настройка для всех узлов mongodb. Ниже описаны последовательность действий ДЛЯ КАЖДОГО узла базы данных.Настройка состоит из нескольких этапов:
#•	Инициализация чистой базы данных
#•	Создание пользователей базы данных 
#•	Настройка репликации

# Инициализация чистой базы данных
# Конфигурационный файл выглядит таким образом
    storage:
      dbPath: /data/db
      journal:
        enabled: true
    systemLog:
      destination: file
      logAppend: true
      path: /var/log/mongodb/mongod.log
    net:
    port: 27017
    bindIp: 0.0.0.0
    tls:
      mode: disabled
    processManagement:
      timeZoneInfo: /usr/share/zoneinfo
    security:
    authorization: "disabled"

# Запускаем контейнер командой:
    sudo docker run -d --name mongo \
    -v /home/uadm/mongoconf/mongo.conf:/etc/mongo.conf \
    -v /home/uadm/mongoconf/key.txt:/etc/key.txt \
    -v /home/uadm/data/data:/data \
    -p 27017:27017 \
    --add-host kassaprod01:ip_address \
    --add-host kassaprod02:ip_address \
    --add-host kassaapp01:ip_address \
    10.10.12.99:5000/mongo:4.4.19 \
    mongod --config /etc/mongo.conf

# После открываем контейнер командой: 
    sudo docker exec -it mongo bash


# Создание пользователей базы данных
# Подключаемся к базе данных:
    mongo

# И создаем пользователей:
    db.createUser(
    {
    user: "omnipotent",
    pwd: "123456",
    roles: [ { role: "root", db: "admin" } ]
    }
    )

    use admin;
    db.createUser(
    {
    user: "omniAdmin",
    pwd: "123456",
    roles: [ { role: "root", db: "admin" } ]
    }
    )

# После выходим с базы данных и с контейнера и корретируем mongo.conf файл чтобы последующие запуски базы данных были авторизованными:
    storage:
      dbPath: /data/db
      journal:
        enabled: true
    systemLog:
      destination: file
      logAppend: true
      path: /var/log/mongodb/mongod.log
    net:
      port: 27017
      bindIp: 0.0.0.0
      tls:
        mode: disabled
    processManagement:
      timeZoneInfo: /usr/share/zoneinfo
    security:
      authorization: "enabled" # было disabled

# После корректировки перезапускаем контейнер:
    docker container restart mongo


# Настройка репликации
# Для того чтобы настроить репликацию для базы данных нужно создать файл с ключем для обмена данными между узлами базы данных. Для этого выполняем следующие операции:
    openssl rand -base64 756 > key.txt
    chmod 600 key.txt

# После корректируем mongo.conf файл
    storage:
      dbPath: /data/db
      journal:
        enabled: true
    systemLog:
      destination: file
      logAppend: true
      path: /var/log/mongodb/mongod.log
    net:
      port: 27017
      bindIp: 0.0.0.0
      tls:
        mode: disabled
    processManagement:
      timeZoneInfo: /usr/share/zoneinfo
    security:
      keyFile: /etc/key.txt               # добавили
      authorization: "enabled"
    replication:                          # добавили
      replSetName: "cashierReplication"   # добавили

# После корректировки перезапускаем контейнер:
    docker container restart mongo

# Эти операции нужно выполнить для КАЖДОГО УЗЛА базы данных!!!








# Настройка репликации между узлами
# НА Мастер узле запускаем команду:
    rs.initiate(
       {
          _id: "cashierReplication",
          version: 1,
          members: [
             { _id: 0, host : "kassaprod01:27017" },
             { _id: 1, host : "kassaprod02:27017" },
             { _id: 2, host : "kassaapp01:27017" }
          ]
       }
    )







# Постановка задачи
# Требуется настроить TLS/SSL репликацию между тремя узлами базы данных mongoDB. Для реализации репликации был выбран метод репликации PSS (Primary, Secondary, Secondary). А также требуется настроить приоритет репликации, для облегчения выбора Primary узла и предсказуемости репликации. Между узлами и для пользовательских соединений требуется настроить TLS/SSL соединения.
# Имеется три сервера со следующими хостами:
    •	kassaprod01 – Primary узел – ip_address – приоритет репликации - 3
    •	kassaprod02 – Secondary узел – ip_address - приоритет репликации - 2
    •	kassaapp01 – Secondary узел – ip_address - приоритет репликации - 1
# Настройки для каждого узла репликации:
# Инициализация пустой базы
# Создаем файл для инициализации чистой базы данных (mongo.conf):
    mongod.conf

# for documentation of all options, see:
    http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
    storage:
      dbPath: /data/db
      journal:
        enabled: true
    #  engine:
    #  mmapv1:
    #  wiredTiger:

    # where to write logging data.
    systemLog:
      destination: file
      logAppend: true
      path: /var/log/mongodb/mongod.log

    # network interfaces
    net:
      port: 27017
      bindIpAll: true
    #   ssl:
    #     mode: preferSSL
    #     PEMKeyFile: /etc/ssl/kassaprod01.pem
    #     CAFile: /etc/ssl/mongoCA.crt
    #     clusterFile: /etc/ssl/kassaprod01.pem
    #     PEMKeyPassword: Passw0rd!
    #     clusterPassword: Passw0rd!

    # how the process runs
    processManagement:
      timeZoneInfo: /usr/share/zoneinfo

    security:
      authorization: "disabled"
    #   clusterAuthMode: x509

    #operationProfiling:

    # replication:
    #   replSetName: "cashierReplication"

    #sharding:

    ## Enterprise-Only Options:

    #auditLog:

    #snmp:

# После запускаем контейнер со следующей командой:
    sudo docker run -d --name mongo \
    -h kassaapp01 \
    -v /home/uadm/mongoconf/mongo.conf:/etc/mongo.conf \
    -v /home/uadm/mongoconf/key.txt:/etc/key.txt \
    -v /home/uadm/data/data:/data \
    -v /home/uadm/mongoconf/ssl2:/etc/ssl \
    -p 27017:27017 \
    --add-host kassaprod01:ip_address \
    --add-host kassaprod02:ip_address \
    --add-host kassaapp01:ip_address \
    mongo:4.4.19 mongod --config /etc/mongo.conf

# Прим. Для каждого узла нужно соответственное название хоста указать
# После запуска контейнера. Открываем контейнер:
    sudo docker exec -it mongo bash
d
# Далее вызываем mongo-shell:
    mongo

# Создание пользователей Базы Данных
# Создаем пользователя для коллекции test c правами root :
    db.createUser(
    {
    user: "User",
    pwd: "Password",
    roles: [ { role: "root", db: "admin" } ]
    }
    )

# После создаем пользователя для коллекции admin c правами root :
    use admin;
    db.createUser(
    {
    user: "User",
    pwd: "Password",
    roles: [ { role: "root", db: "admin" } ]
    }
    )

# Генерация SSL сертификата для TLS/SSL соединений
# Ссылка на оригинальный источник
# На Primary узле выполняем следующие действия. Для начала генерируем private ключ командой:
    openssl genrsa -out mongoCA.key -aes256 8192
# Команда попросит ввести пароль безопасности. Вводим Passw0rd! . В результате получится файл под названием mongoCA.key. 
# Следующем этим же ключем генерируем CA сертификат для дальнейшей выдачи сертификатов узлов базы данных. Выполняем следующую команду:
    openssl req -x509 -new -extensions v3_ca -key mongoCA.key -days 365 -out mongoCA.crt

# Можно заметить что СА сертификат валидный в течении 365 дней после даты генерации.
# Далее начинаем генерировать сертификаты для трех узлов базы данных. Имеется bash скрипт для авто генерации этих сертификатов следующим кодом:
    #!/bin/bash
    if [ "$1" = "" ]; then
    echo 'Please enter your hostname (CN):'
    exit 1
    fi
    HOST_NAME="$1"
    SUBJECT="/C=UZ/ST=Tashkent/L=Tashkent/O=IY/OU=IT/CN=$HOST_NAME"
    openssl req -new -nodes -newkey rsa:4096 -subj "$SUBJECT" -keyout $HOST_NAME.key -out $HOST_NAME.csr
    openssl x509 -CA mongoCA.crt -CAkey mongoCA.key -CAcreateserial -req -days 365 -in $HOST_NAME.csr -out $HOST_NAME.crt
    rm $HOST_NAME.csr
    cat $HOST_NAME.key $HOST_NAME.crt > $HOST_NAME.pem
    rm $HOST_NAME.key
    rm $HOST_NAME.crt

# Сохранянем скрипт в файл под именем cert.sh . Перед запуском выполняем команду:
    chmod +x cert.sh
# После выполняем скрип следующим образом:
    ./cert.sh kassaprod01

# Это команду нужно выполнить для всех трех хостов узла. В конечном итоге получается следующие файлы:
 

# Перемещаем пару сертификатов на соответствующие хосты:
# - mongoCA.crt и kassaprod01
# - mongoCA.crt и kassaprod02
# - mongoCA.crt и kassaapp01

# Конфигурация MongoDB репликации с помощью X.509 Сертификатов
# Корректируем конфигурационный файл mongo.conf следующим образом и включаем аутентификацию пользователей:
    # mongod.conf
# for documentation of all options, see:
     http://docs.mongodb.org/manual/reference/configuration-options/

# Where and how to store data.
    storage:
      dbPath: /data/db
      journal:
        enabled: true
    #  engine:
    #  mmapv1:
    #  wiredTiger:

    # where to write logging data.
    systemLog:
      destination: file
      logAppend: true
      path: /var/log/mongodb/mongod.log

    # network interfaces
    net:
      port: 27017
      bindIpAll: true
      ssl:
        mode: preferSSL
        PEMKeyFile: /etc/ssl/kassaprod01.pem
        CAFile: /etc/ssl/mongoCA.crt
        clusterFile: /etc/ssl/kassaprod01.pem
        PEMKeyPassword: Password
        clusterPassword: Password

    # how the process runs
    processManagement:
      timeZoneInfo: /usr/share/zoneinfo

    security:
      authorization: "enabled"
      clusterAuthMode: x509

    #operationProfiling:

    replication:
      replSetName: "cashierReplication"

    #sharding:

    ## Enterprise-Only Options:

    #auditLog:

    #snmp:


# Перезапускаем контейнер mongo
    docker container restart mongo

# После успешной перезагрузки открываем контейнер и продолжаем настройку репликации:
    docker exec –it mongo bash

# Запускаем mongo-shell на Primary узле. Так как на данный момент настроено аутентификация с помощью сертификатов, команда для подключение к mongo меняется и выглядит следующем образом:
    mongo --ssl --host kassaprod01 --sslCAFile /etc/ssl/mongoCA.crt --sslPEMKeyFile /etc/ssl/kassaprod01.pem

# После проходим аутентификацию пользователя командой:
    db.auth('user','Password')

# Если аутентификация прошла успешно, команда вернет число 1, иначе 0. Далее выполняем команду для инициализации репликации:
    rs.initiate(
       {
          _id: "cashierReplication",
          version: 1,
          members: [
             { _id: 0, host : "kassaprod01:27017" },
             { _id: 1, host : "kassaprod02:27017" },
             { _id: 2, host : "kassaapp01:27017" }
          ]
       }
    )

# После инициализации выполняем следующие команды для настройки приоритизации репликации:
    cfg = rs.conf()
    cfg.members[0].priority = 3
    cfg.members[1].priority = 2
    cfg.members[2].priority = 1
    rs.reconfig(cfg)

# Для проверки репликации с secondary узлами выполняем команду:
    rs. printSecondaryReplicationInfo()

 


