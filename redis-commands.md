# БАЗОВЫЕ (проверка, отладка)
    PING
    AUTH Password
    INFO
    INFO replication
    INFO server
    CLIENT LIST
    CLIENT KILL <ip:port>
# РОЛЬ НОДЫ (МАСТЕР / SLAVE)
    INFO replication
    ROLE
# РЕПЛИКАЦИЯ
    REPLICAOF <master_ip> 6379
    REPLICAOF NO ONE        # сделать ноду мастером
    INFO replication
# SENTINEL (ОСНОВНОЕ)
    SENTINEL masters
    SENTINEL slaves mymaster
    SENTINEL sentinels mymaster
    SENTINEL get-master-addr-by-name mymaster
    SENTINEL ckquorum mymaster
    SENTINEL failover mymaster
    SENTINEL RESET mymaster
# КОНФИГИ И ТАЙМАУТЫ
    CONFIG GET *
    CONFIG GET timeout
    CONFIG GET tcp-keepalive
    CONFIG GET maxclients
    CONFIG SET timeout 0
# КЛЮЧИ / ДАННЫЕ
    KEYS *
    SCAN 0
    DBSIZE
    TTL key
    DEL key
    EXPIRE key 60
# ПАМЯТЬ
    INFO memory
    MEMORY STATS
    MEMORY USAGE key
    FLUSHDB
    FLUSHALL
# ПЕРСИСТЕНТНОСТЬ
    INFO persistence
    SAVE
    BGSAVE
# ACL (Redis ≥6) 
    ACL LIST
    ACL USERS
    ACL GETUSER default
    ACL SETUSER app on >password ~* +@all
# БЕЗОПАСНОСТЬ
    CONFIG GET requirepass
    CONFIG SET requirepass Password   # НЕ для Sentinel
# ОПАСНЫЕ (ТОЛЬКО ОСОЗНАННО)
    SHUTDOWN
    FLUSHALL
    CONFIG SET dir /
# МОНИТОРИНГ / ОТЛАДКА
    MONITOR
    SLOWLOG GET
    LATENCY DOCTOR
# Посмотреть IP, откуда идут подключения
    redis-cli -p 26379 -a Passw0rd! CLIENT LIST \
     | awk -F'addr=' '{print $2}' \
     | awk '{print $1}' \
     | cut -d: -f1 \
     | sort | uniq -c | sort -nr | head
# Посчитать клиентов по типу
  # Обычные клиенты
    redis-cli -p 26379 -a Password CLIENT LIST TYPE normal | wc -l

  # Sentinel клиенты
    redis-cli -p 26379 -a Password CLIENT LIST TYPE sentinel | wc -l
