# 1. Анализ сервисов через journalctl и systemctl
📌 Посмотреть статус сервиса:

    systemctl status mongod
    systemctl status docker

📌 Логи по конкретному сервису:

    journalctl -u mongod
    journalctl -u docker

📌 Ограничить по времени:

    journalctl -u mongod --since "1 hour ago"
    journalctl -u mongod --since "2025-06-09 14:00" --until "2025-06-09 14:30"

📌 Последние 100 строк:

    journalctl -u mongod -n 100

# 2. Анализ системных процессов
📌 Посмотреть процессы, отсортированные по памяти:

    ps aux --sort=-%mem | head -n 15

📌 То же самое по CPU:

    ps aux --sort=-%cpu | head -n 15

📌 Альтернатива — top или htop:

    top
    htop    # (если установлен)

# 📊 3. Выявление проблемных сервисов
🔥 Найти сервисы, которые падали:

    systemctl --failed

📌 Проверить, перезапускался ли сервис (например, mongod):

    journalctl -u mongod | grep -i 'start\|stop\|killed\|failed'

# 🧠 4. Дополнительные команды
📌 Список всех активных сервисов:

    systemctl list-units --type=service

📌 Логи ядра (например, для OOM или hardware ошибок):

    journalctl -k
