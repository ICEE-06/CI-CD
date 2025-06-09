## Créer un répertoire pour les volumes

- **Créer le répertoire**
```
sudo mkdir -p /srv/gitlab
```

- Configurer une nouvelle variable d'environnement **$ gitlab_home** qui définit le chemin d'accès au répertoire créé: (pour la session actuelle seulement)
```
export GITLAB_HOME=/srv/gitlab
```

## Docker Compose
```
services:
  gitlab:
    image: gitlab/gitlab-ee:<version>-ee.0
    container_name: gitlab
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.example.com:8929'
        gitlab_rails['gitlab_shell_ssh_port'] = 2424
    ports:
      - '8929:8929'
      - '443:443'
      - '2424:22'
    volumes:
      - '$GITLAB_HOME/config:/etc/gitlab'
      - '$GITLAB_HOME/logs:/var/log/gitlab'
      - '$GITLAB_HOME/data:/var/opt/gitlab'
    shm_size: '256m'
```