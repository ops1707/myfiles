# 1. Общий вызов

    journalctl
Показывает все системные логи с начала загрузки. Используй клавиши PgUp/PgDn или Shift+G/g для навигации.

# 2. Последние сообщения

    journalctl -r
Показывает логи в обратном порядке (сначала последние).

# 3. Логи за текущую загрузку

    journalctl -b
Полезно для анализа проблем после ребута.

# 4. Фильтрация по времени

    journalctl --since "2025-06-09 14:00" --until "2025-06-09 14:30"
Можно также писать --since "1 hour ago" или --since yesterday.

# 5. Логи ядра

    journalctl -k
Только сообщения от ядра Linux (например, Out of memory).

# 6. Фильтрация по юниту systemd

    journalctl -u nginx.service
Покажет логи только от nginx.

# 7. Фильтрация по процессу

    journalctl _PID=1234
Показывает логи конкретного PID.
 
# 8. Поиск текста в логах

    journalctl | grep "error"
Можно использовать -r или ограничение по времени совместно.

# 9. Постоянный просмотр (как tail -f)

    journalctl -f
Для отслеживания логов в реальном времени.

# 10. Логи от конкретного пользователя

    journalctl _UID=1000

# Полезная команда для мониторинга ошибок OOM:

    journalctl -k | grep -i -E 'killed process|out of memory'
# 11. Фильтрация логов по сервису

Журналы сервисов systemd можно смотреть через -u <имя_сервиса>.service:
▶ Примеры:

# Логи nginx
     journalctl -u nginx.service

# Логи MongoDB (обычно unit называется так)
    journalctl -u mongod.service

# Логи Docker
    journalctl -u docker.service

# Дополнительные флаги:

# Только за сегодня
    journalctl -u nginx.service --since today

# За последние 2 часа
    journalctl -u nginx.service --since "2 hours ago"

# В реальном времени (аналог tail -f)
    journalctl -u nginx.service -f

# 12. Экспорт логов в файл
▶ Простой экспорт в текст:

    journalctl -u nginx.service > nginx-logs.txt

▶ Экспорт с временными рамками:

    journalctl -u mongod.service --since "2025-06-09 13:00" --until "2025-06-09 14:30" > mongo-logs.txt

# 13. Экспорт логов в бинарном формате (для переноса на другую машину)

    journalctl --since "2025-06-09" --until "2025-06-10" --output=export > logs.bin

На другой машине:

    journalctl --file=logs.bin

# 14. Экспорт JSON-совместимого формата (для анализа парсерами)

    journalctl -u docker.service -o json-pretty > docker-logs.json

