
## Les jobs de Jenkins

Les jobs se contentent d'exécuter le script '/builds/bin/build'. Ce
script crée un conteneur 'docker' (basé sur une debian stable) et
y exécute le script '/builds/ocsigen/build.sh'.

Le conteneur contient dans le répertoire '/usr/src/workspace' les
sources du projet à compiler ; le script 'build.sh' exécute
principalement le script '.jenkins.sh' qui se trouve à la racine du
projet.

Le job peut être paramétré en ajoutant à la racine du projet un
fichier '.env.sh' pouvant définir entre autres :

 - OPAMSWITCH : le switch opam  utiliser

 - JENKINS_BUILD_DOC : le nom du projet (ou vide si l'on ne veux pas
                                         compiler la documentation)

 - JENKINS_COMMIT_DOC : si non-vide, 'commit/push' la doc dans le
                        dépôt 'ocsigen.org-data'.

 - JENKINS_KEEP_CONTAINER : si non-vide, n'efface pas le 'conteneur docker'
   			    à la fin de la compilation.



## Conteneur

Le conteneur utilisé pour 'builder' les 'jobs' de Jenkins s'appelle
'ocsigen:debian_stable'. Les données nécessaire à sa création sont
regroupées dans le répertoire '/builds/ocsigen'.

Après avoir mises-à-jour ces données, le conteneur doit être
reconstruit en exécutant le script '/builds/bin/update_docker' (sur
ocsigen-s2). Puis les modifications doivent propagées sur 'ocsigen-s1'
en exécutant le script '/builds/bin/update_docker' (sur ocsigen-s1).

Pendant la reconstruction du conteneur il est conseillé de désactiver
l'esclave 'ocsigen-s2' dans l'interface de 'Jenkins'. De même, pendant
la propagation, il est conseillé de désactiver les deux esclaves.



## Cache

Les répertoires '/builds/cache/git' et '/builds/cache/opam-repository'
contiennent respectivement un mirroir git de tous les projets 'ocsigen'
et un mirroir du 'opam-repository' principal.

Ils sont mis-à-jour par le script '/builds/bin/update_cache'. Il est
exécuté une fois par jour par 'cron'.

