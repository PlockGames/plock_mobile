# Pixel Runner

Un jeu simple de type "Runner" créé pour la plateforme PLOCK. Le joueur doit sauter par-dessus des obstacles qui défilent.

![Pixel Runner](https://via.placeholder.com/300x200/4287f5/ffffff?text=Pixel+Runner)

## Description du jeu

Pixel Runner est un jeu d'arcade simple où :
- Un personnage (représenté par un rectangle bleu) doit sauter par-dessus des obstacles (rectangles orange)
- Le sol est représenté par un rectangle vert
- Le joueur marque des points à chaque obstacle évité
- Le jeu se termine lorsque le joueur entre en collision avec un obstacle

## Structure technique

Le jeu utilise le moteur de jeu de PLOCK basé sur Flame/Forge2D et est construit avec les composants suivants :

### Objets principaux
1. **Player** : Un rectangle avec un composant physique permettant de sauter
2. **Obstacle** : Des rectangles qui se déplacent de droite à gauche
3. **Floor** : Le sol sur lequel le joueur se déplace
4. **ObstacleGenerator** : Un générateur qui crée des obstacles à intervalles aléatoires
5. **Score** : Un texte qui affiche le score actuel
6. **GameOver** : Un texte qui s'affiche lorsque le jeu se termine

### Événements et interactions
- Taper sur l'écran fait sauter le personnage
- Collisions détectées entre le joueur et les obstacles
- Score incrémenté à chaque obstacle évité
- Obstacles générés aléatoirement

## Comment ajouter le jeu à la base de données

Pour que le jeu apparaisse dans la page d'accueil comme s'il avait été créé par un utilisateur, nous avons préparé un script d'initialisation. Voici comment l'utiliser :

### Prérequis
- Base de données PostgreSQL initialisée avec le schéma PLOCK
- Utilisateurs et tags déjà créés (exécuter `npm run prisma:seed` si nécessaire)

### Étapes pour ajouter le jeu

1. Accédez au répertoire du backend :
   ```bash
   cd plock_backend
   ```

2. Exécutez le script d'ajout du jeu :
   ```bash
   npm run add:pixel-runner
   ```

3. Le script effectuera automatiquement les actions suivantes :
   - Sélection d'un utilisateur aléatoire comme créateur
   - Ajout du jeu avec les tags "Arcade" et "Action"
   - Création de commentaires fictifs par différents utilisateurs
   - Ajout de likes au jeu pour le rendre populaire

4. Vérifiez que le jeu apparaît dans la page d'accueil de l'application

## Comment jouer

1. Lancez l'application PLOCK
2. Naviguez vers la page d'accueil
3. Trouvez "Pixel Runner" parmi les jeux créés par la communauté
4. Tapez sur l'écran pour faire sauter le personnage et éviter les obstacles
5. Essayez d'obtenir le meilleur score !

## Structure des fichiers

- `game_data.json` : Contient toutes les données du jeu (objets, scènes, composants)
- `README.md` : Documentation du jeu (ce fichier)

## Personnalisation

Vous pouvez modifier le jeu en éditant le fichier `game_data.json`. Les modifications possibles incluent :
- Changement des couleurs
- Ajustement de la gravité et de la puissance de saut
- Modification de la fréquence des obstacles
- Ajout de nouveaux éléments

Pour des modifications plus avancées, vous devrez comprendre la structure de l'éditeur de jeu PLOCK et ses différents composants.
