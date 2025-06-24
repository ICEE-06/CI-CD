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


## Changer le mot de passe du user "root"

- **Se connecter dans le bash du conteneur**:
```
docker exec -it {id_conteneur} bash
```

- **console rails**
```
gitlab-rails console
```

- **Création du nouveau mdp**:
```
user = User.find_by_username('root')
user.password = 'NouveauMotDePasseFort'
user.password_confirmation = 'NouveauMotDePasseFort'
eser.save!
```

## Installation du Runner

### Ajouter ces lignes dans le docker-compose

```
    networks:
      - gitlab-network

  
  gitlab-runner:
    image: gitlab/gitlab-runner:alpine3.18-v17.11.3
    container_name: gitlab-runner
    restart: always
    volumes:
      - '${GITLAB_RUNNER_HOME}/config:/etc/gitlab-runner'
      - '/var/run/docker.sock:/var/run/docker.sock'
    netwoerks:
      - gitlab-network

networks:
  gitlab-network:
    driver: bridge
```

### Variables d'environnements
Avant de lancer les conteneurs, il faut créer les répertoires locaux avec les commandes:

```
export GITLAB_HOME=$HOME/gitlab
export GITLAB_RUNNER_HOME=$HOME/gitlab-runner

mkdir -p $GITLAB_HOME/config $GITLAB_HOME/logs $GITLAB_HOME/data
mkdir -p $GITLAB_RUNNER_HOME/config

```

Maintenant on lance les conteneurs avec la commande `docker-compose up -d`

### Enregistrer le Runner

```
docker exec -it gitlab-runner gitlab-runner register
```