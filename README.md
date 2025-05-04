## Homelab
Проект описывает мою домашнюю лабораторию построенную по принципу IaC. На текущий момент лаборатория состоит из [выделенного ПК](docs/hardware-proxmox.md) с GPU на котором развернут Proxmox и серверов на Cloud.ru.
Данный проект зависит от моих коллекций Ansible:
- https://github.com/daowolf2000/ansible-collection-linux
- https://github.com/daowolf2000/ansible-collection-proxmox


## Структура проекта

```
homelab/                
├── docs/               # Документация и заметки по проектам
├── hosts/              # Описание хостов (Ansible)
│   ├── group_vars/     # Переменные для групп хостов
│   ├── host_vars/      # Переменные хостов
│   ├── inventory.ini   # Постоянный inventory 
│   └── proxmox.yml     # Динамический inventory для хостов размещенных на Proxmov
├── plays/              # Каталог для плейбуков Ansible
│   └── provision.yml
├── terraform/          # Каталог для хранения настроек Terraform
│   ├── base/           # Описание базовой инфраструктуры homelab
│   ├── modules/        # Модули Terraform
│   └── < projN >/      # Каталоги для проектов
├── ansible.cfg
├── .envrc              # Переменные окружения
├── README.md
└── requirements.yml
```
Примечания:
1. Все чувствительные данные передаются через переменные окружения и хранятся в `.envrc` (требования к содержимому см. в [.envrc.sample](./.envrc.sample)), который автоматически активируется с помощью `direnv`.
1. Для каждого набора ресурсов (проекта) создается отдельная папка в Terraform (`< projN >`) и отдельный пул в Proxmox (с именем равным `< projN >`).
1. В основном используются контейнеры LXC на базе Debian.
1. Контейнерам, которым нужен доступ к GPU, необходимо присвоить тег `gpu`

