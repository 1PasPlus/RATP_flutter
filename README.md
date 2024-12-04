# Dashboard des Perturbations Flutter RATP

Ce projet est une application Flutter interactive et moderne permettant de suivre les perturbations des transports en commun de la RATP en temps réel. Le dashboard offre une vue d’ensemble des lignes de métro, RER, bus, tramway et autres services, avec des informations claires et actualisées pour aider les utilisateurs à planifier leurs déplacements.

## Fonctionnalités

- **Affichage en temps réel :** Recevez les dernières informations sur les perturbations en cours.
- **affichage des messages de perturbations :** sous forme de tableau déroulant.
- **Interface adaptative :** Compatible avec les appareils mobiles, tablettes et desktops.

## Prérequis

Pour exécuter ce projet localement, vous aurez besoin des éléments suivants :

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.0 ou supérieure)
- Un éditeur de code (recommandé : [Visual Studio Code](https://code.visualstudio.com/) avec les extensions Flutter/Dart installées)
- Accès à l’API RATP pour les données des perturbations (clé API requise)

## Installation

1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/votre-utilisateur/ratp-perturbations-dashboard.git
   ```
2. Accédez au répertoire du projet :
   ```bash
   cd ratp-perturbations-dashboard
   ```
3. Installez les dépendances :
   ```bash
   flutter pub get
   ```
4. Configurez votre clé API RATP dans le fichier de configuration approprié.

## Lancer l'application

1. Connectez un appareil ou démarrez un simulateur/emulateur.
2. Exécutez l'application :
   ```bash
   flutter run
   ```

## Structure du projet

- **lib/** : Contient le code source principal.
  - **models/** : Modèles de données pour représenter les perturbations.
  - **screens/** : Différents écrans de l’application.
  - **widgets/** : Composants réutilisables de l’interface utilisateur.
  - **services/** : Gestion des appels API et de la logique d’accès aux données.
- **assets/** : Contient les images, icônes et fichiers statiques.
- **test/** : Tests unitaires et d’intégration.

## Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Forkez le dépôt.
2. Créez une branche pour votre fonctionnalité/correction :
   ```bash
   git checkout -b ma-nouvelle-fonctionnalite
   ```
3. Effectuez vos modifications.
4. Soumettez une pull request avec une description claire de vos changements.

## Licence

Ce projet est sous licence [MIT](LICENSE). Vous êtes libre de l’utiliser, de le modifier et de le redistribuer tout en respectant les termes de la licence.

## Auteur

Développé par Victor Asencio, Arthur Mehats, Maxence Brunet.

---

Merci d’avoir choisi le Dashboard des Perturbations RATP Flutter ! Nous espérons qu’il vous sera utile pour naviguer dans les transports parisiens avec plus de facilité.
