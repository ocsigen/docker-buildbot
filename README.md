
This project contains configuration files for the slaves of the
[Ocsigen's Jenkins](https://buildbot.ocsigen.org/).


## Les jobs de Jenkins

Les jobs se contentent d'exécuter le script '/builds/bin/build' (copié
depuis le fichier 'bin/build' de ce projet). Ce script crée un
conteneur 'docker' (basé sur une debian stable) et y exécute le script
'docker/bin/build.sh'.

Le conteneur contient dans le répertoire '/usr/src/workspace' les
sources du projet à compiler ; le script 'build.sh' exécute
principalement le script '.jenkins.sh' qui se trouve à la racine du
projet.

Le job peut être paramétré en ajoutant à la racine du projet un
fichier '.env.sh' pouvant définir entre autres :

 - OPAMSWITCH : le switch opam à utiliser

 - JENKINS_BUILD_DOC : le nom du projet (ou vide si l'on ne veux pas
                                         compiler la documentation)

 - JENKINS_COMMIT_DOC : si non-vide, 'commit/push' la doc dans le
                        dépôt 'ocsigen.org-data'.

 - JENKINS_KEEP_CONTAINER : si non-vide, n'efface pas le 'conteneur docker'
   			    à la fin de la compilation.



## Conteneur

Le conteneur utilisé pour 'builder' les 'jobs' de Jenkins s'appelle
'ocsigen:debian_stable'. Les données nécessaire à sa création sont
regroupées dans le répertoire 'docker' de ce dépôt git. Le conteneur
est construit automatiquement à chaque 'commit' dans le dépôt github
par les jobs Jenkins
[Docker-buildbot-s1](https://ci.inria.fr/ocsigen/job/Docker-buildbot-s1)
et
[Docker-buildbot-s2](https://ci.inria.fr/ocsigen/job/Docker-buildbot-s2).
Ces jobs exécutent le script 'bin/update_docker.jenkins' de ce dépôt.



## Cache

Les répertoires '/builds/cache/git' et '/builds/cache/opam-repository'
des machines esclaces contiennent respectivement un mirroir git de
tous les projets 'ocsigen' et un mirroir du 'opam-repository'
principal.

Ils sont mis-à-jour par le script 'bin/update_cache.jenkins' qui est
exécuté au moins une fois par jour par les jobs
[Cache-updater-s1](https://ci.inria.fr/ocsigen/job/Cache-updater-s1)
et
[Cache-updater-s2](https://ci.inria.fr/ocsigen/job/Cache-updater-s2).


## Petit hack sans dout inutile.

Pour ne pas qu'un job Jenkins "classique" s'exécute en même tant que
la mise-à-jour du Docker, les jovs 'Cache-updater' et 'Docker-builbot'
se synchronise pour occuper les deux 'executors' de l'esclave...