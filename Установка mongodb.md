# Удалите существующую запись репозитория MongoDB для noble
    sudo rm /etc/apt/sources.list.d/mongodb-org-6.0.list
# Добавьте репозиторий для jammy:
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
# Обновите список пакетов:
    sudo apt update 
# Установить MongoDB:
    sudo apt install -y mongodb-org
# Запустите и включите MongoDB:
    sudo systemctl start mongod
    sudo systemctl enable mongod
