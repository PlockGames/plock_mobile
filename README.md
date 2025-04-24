# Plock (Mobile)

<center><img src="img/logo.webp" alt="drawing" width="300"/></center>

Plock est un réseau social ludique basé sur des mini-jeux créés par la communauté. Inspiré de TikTok, chaque "post" est un jeu que l'on swipe pour passer au suivant. L'application permet de **jouer**, **aimer**, **commenter**, **partager** les jeux, mais aussi d’en **créer** via un éditeur no-code intégré.

## 🚀 Fonctionnalités principales

- 🎮 Jouer à une multitude de mini-jeux communautaires
- ✨ Swipe entre les jeux à la TikTok
- ❤️ Système de likes & commentaires
- 🛠️ Éditeur de jeux no-code intégré
- 🔍 Algorithme de recommandation & recherche par tags
- 👤 Profils utilisateurs, authentification Google
- ☁️ Sauvegarde et chargement de jeux via API

---

## 📦 Prérequis

- [Flutter SDK (≥ 3.3.0)](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/) avec plugins Flutter/Dart
- Compte Google pour les tests d’authentification

---

## ⚙️ Installation

1. Clone le dépôt :
   ```bash
   git clone <url-du-repo>
   cd plock_mobile
   ```
2. Installe les dépendances :
    ```bash
    flutter pub get
    ```
3. Lancer sur un émulateur ou appareil :
    ```bash
    flutter run
    ```

## 🧪 Tests

Plock intègre des tests unitaires et des tests d’intégration via Patrol.
- Lancer les tests unitaires :
    ```bash
    flutter test
    ````
- Lancer les tests d'intégration :
    ```bash
    flutter test integration_test
    ```

## 📁 Structure du projet

| Dossier / Fichier        | Description                                              |
|-------------------------|----------------------------------------------------------|
| `lib/`                  | Code source principal (UI, logique, services)            |
| `assets/`               | Images, SVGs, scripts Blockly, etc.                      |
| `doc/`                  | Toute la documentation du projet                         |
| `test/`                 | Scénarios de test d’intégration                          |
| `.env`                  | Variables d’environnement (non versionné)                |
| `pubspec.yaml`          | Dépendances & configuration Flutter                      |
| `README.md`             | Documentation du projet                                  |

## 🧱 Technologies

- Flutter – Développement mobile multiplateforme

- Flame – Moteur de jeu 2D léger pour Flutter

- Blockly – Éditeur de logique no-code (flutter_blockly_plus)

- Google Sign-In, Flutter Secure Storage

- Forge2D – Moteur physique

- Patrol – Tests UI modernes pour Flutter

## 📚 Documentation complémentaire

- [📄 PBS & WBS - Description fonctionnelle complète](doc/PBS%20et%20WBS.pdf)
- [📄 Workflow - Gitflow, convention de nommage, outil Jira](doc/Workflow.pdf)
- [📄 Elements non testés - Liste complète et chemin vers fichiers](doc/Elément-non-testes.docx.pdf)

Et autres accessible dans le dossier `doc/` à la racine du projet.
Vous trouverez également toutes doc relatives à la gestion de données et faisabilités légales dans `doc/t-law/`

## 👥 Auteurs & Contributions

Projet développé dans le cadre d’un projet étudiant. Contributions bienvenues !

Contributeurices:

- [Alex](https://github.com/Pebloop)
- [Jalil](https://github.com/JalilJaajoui)
- [Maeva](https://github.com/starkoreba)
- [Masao](https://github.com/MasaoEpitech)
- [Maxime](https://github.com/devslawer)
- [Julien](https://github.com/ArmandJ2025)
- [Valentin](https://github.com/Vfiche)
- [Mustapha](https://github.com/soymustamahti)

Nous remercions aussi [Automne](https://github.com/AutomneB) qui ne fait plus parti du projet à ce jour.

Contact : [tiktokgames.plock@gmail.com]()
