Шаг 1: Остановите Docker
  Остановите Docker и удалите все запущенные контейнеры:

    sudo systemctl stop docker

Шаг 2: Удалите пакеты Docker
  Удалите все пакеты, связанные с Docker:
  
    sudo apt-get purge -y docker-engine docker docker.io containerd runc docker-ce docker-ce-cli

  Удалите дополнительные зависимости:

    sudo apt-get autoremove -y --purge

  Убедитесь, что удалены все пакеты, связанные с Docker:

    dpkg -l | grep -i docker

  Если вы видите что-либо связанное с Docker, удалите их вручную:

    sudo apt-get remove -y <package_name>

  Шаг 3: Удалите данные Docker

  Удалите все данные, созданные Docker:

 Удалите данные, конфигурации и образы:

    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    sudo rm -rf /etc/docker

 Удалите сокеты Docker:

    sudo rm -rf /run/docker.sock
    sudo rm -rf /run/docker

Удалите временные файлы:

    sudo rm -rf /var/run/docker

Шаг 4: Удалите системные файлы Docker
Удалите все конфигурации systemd:

    sudo rm -rf /etc/systemd/system/docker.service.d
    sudo rm -rf /lib/systemd/system/docker.service
    sudo rm -rf /lib/systemd/system/docker.socket

Перезагрузите systemd:
 
    sudo systemctl daemon-reload

Удалите другие файлы и директории, связанные с Docker:

    sudo rm -rf /usr/bin/docker
    sudo rm -rf /usr/bin/docker-compose
    sudo rm -rf /usr/local/bin/docker
    sudo rm -rf /usr/local/bin/docker-compose

Шаг 5: Очистите конфигурации сети Docker
Docker создает собственные сети, которые нужно удалить:
Удалите сети Docker:

    sudo ip link delete br-<network-id>

Для удаления всех сетей, связанных с Docker:

docker network prune

Проверьте текущие сети:

    ip a | grep docker

    Убедитесь, что Docker-сети больше не существуют.

Шаг 6: Удалите прокси-настройки (если применимо)

Если вы настраивали прокси для Docker, удалите соответствующие файлы:

    Удалите конфигурацию прокси:

sudo rm -rf /etc/systemd/system/docker.service.d/http-proxy.conf

Перезагрузите systemd:

    sudo systemctl daemon-reload

Шаг 7: Удалите ключи и репозитории Docker
 Удалите ключи GPG Docker:

    sudo rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
    sudo rm -rf /etc/apt/keyrings/docker.gpg

Удалите репозиторий Docker из /etc/apt/sources.list:

    sudo rm -rf /etc/apt/sources.list.d/docker.list

Обновите список пакетов:

    sudo apt-get update

Шаг 8: Проверка удаления
Убедитесь, что Docker полностью удален:
Проверьте статус Docker:

    systemctl status docker

Если Docker успешно удален, вы должны увидеть сообщение вроде:

    Unit docker.service could not be found.

Проверьте установленные пакеты:

    dpkg -l | grep -i docker

Ничего связанного с Docker не должно отображаться.
Проверьте директории:

    ls -l /var/lib/docker

Директория не должна существовать.
