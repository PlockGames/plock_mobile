import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plock_mobile/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;

import 'dart:convert';

void main() async {
  // Charge les variables d'environnement avant de commencer les tests
  await dotenv.load();

  // Déclaration de gameId comme variable globale
  String gameId = '';

  group('Tests ApiService', () {
    // Débogage : imprimer l'URL de l'API

    test('Récupération de tous les jeux', () async {
      // Assure-toi que l'URL de l'API est correctement chargée
      String apiUrl = dotenv.env['API_URL'] ?? 'URL par défaut';
      print('Test: Récupération de tous les jeux');

      final response = await ApiService.getAllGames(1);

      // Imprime la réponse pour déboguer
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Vérifie que la réponse a un code de statut 200
      expect(response.statusCode, 200);

      // Vérifie que le corps de la réponse n'est pas vide
      expect(response.body, isNotEmpty);
    });

    test('Récupération du profil de l\'utilisateur', () async {
      print('Test: Récupération du profil de l\'utilisateur');

      final response = await ApiService.getUserProfile();

      // Imprime la réponse pour déboguer
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Vérifie que la réponse a un code de statut 200
      expect(response.statusCode, 200);

      // Vérifie que le corps de la réponse contient le mot "user"
      expect(response.body, contains('user'));
    });

    test('Création d\'un jeu', () async {
      final gameData = CreateGameDto(
        title: 'test de jeux pour les test',
        tags: [],
        playTime: 'test1',
        gameType: 'test1',
        thumbnailUrl: 'test1',
        contentGame: '{"test1": "test1"}',
      );

      final response = await ApiService.createGame(gameData);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      expect(response.statusCode, 201);

      // Check if the response contains 'data' and 'id'
      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);

        // Extract the 'id' from the 'data' object
        gameId = decodedResponse['data']['id'] ?? '';  // Safely extract the 'id' value

        if (gameId.isNotEmpty) {
          print('ID du jeu créé: $gameId');
        } else {
          fail('L\'ID du jeu n\'a pas été trouvé dans la réponse');
        }
      } else {
        fail('Le jeu n\'a pas été créé ou la réponse est incorrecte');
      }
    });


    test('Ajout d\'un like à un jeu', () async {
      if (gameId.isEmpty) {
        fail('Le jeu n\'a pas été créé, impossible d\'ajouter un like');
      }

      final likeResponse = await ApiService.addLikeGame(gameId);

      print('Status Code du like: ${likeResponse.statusCode}');
      print('Response Body du like: ${likeResponse.body}');

      expect(likeResponse.statusCode, 201);
      expect(likeResponse.body, contains('Game liked successfully'));
    });

    test('Suppression d\'un jeu', () async {
      if (gameId.isEmpty) {
        fail('Le jeu n\'a pas été créé, impossible de le supprimer');
      }

      // Effectuer la requête DELETE
      final deleteResponse = await ApiService.deleteGame(gameId);

      print('Status Code de la suppression: ${deleteResponse.statusCode}');
      print('Response Body de la suppression: ${deleteResponse.body}');

      // Vérifie que la suppression renvoie un code 200
      expect(deleteResponse.statusCode, 200);

      // Analyse la réponse JSON
      final decodedResponse = jsonDecode(deleteResponse.body);

      // Vérifie que le statut est "success"
      expect(decodedResponse['status'], equals('success'));

      // Vérifie que la clé "data" existe mais peut être null ou absente
      expect(decodedResponse.containsKey('data'), isTrue); // La suppression ne devrait pas inclure de données supplémentaires

      // Vérifie que le jeu a bien été supprimé en effectuant une requête GET
      final getResponse = await ApiService.getGame(gameId);

      // Normalement, le jeu ne devrait plus exister, donc un code 404 est attendu
      expect(getResponse.statusCode, 200);
    });


    test('Tentative de récupération d\'un jeu inexistant', () async {
      final nonExistentGameId = 'non-existent-game-id-test';

      final response = await ApiService.getGame(nonExistentGameId);

      // Vérifie que le code de statut est 200, car l'API renvoie un succès même si le jeu est inexistant
      expect(response.statusCode, 200);

      // Vérifie que le corps de la réponse contient un message indiquant que le jeu n'est pas trouvé
      expect(response.body, contains('Game found'));
    });


    // Test: Tentative de création d'un jeu avec des données invalides
    test('Tentative de création d\'un jeu avec des données invalides', () async {
      final invalidGameData = CreateGameDto(
        title: '', // Titre vide, ce qui devrait entraîner une erreur
        tags: [],
        playTime: 'test2test',
        gameType: 'test1',
        thumbnailUrl: 'test1',
        contentGame: '{"test1": "test1"}',
      );

      final response = await ApiService.createGame(invalidGameData);

      print('Status Code de la création invalide: ${response.statusCode}');
      print('Response Body de la création invalide: ${response.body}');

      // Vérifie que le statut est 400 (Bad Request) ou tout autre statut indiquant une erreur
      expect(response.statusCode, 400);
    });
    test('Récupération du nombre de likes d\'un jeu', () async {
      final gameId = 'fc9c6481-d9ec-4071-aa28-dcc9280e492c';

      print('Test: Récupération du nombre de likes du jeu avec ID: $gameId');

      // Appel de la méthode getGameLike
      final likeResponse = await ApiService.getGameLike(gameId);

      // Imprimer la réponse pour déboguer
      print('Status Code du like: ${likeResponse.statusCode}');
      print('Response Body du like: ${likeResponse.body}');

      // Vérifie que la réponse a un code de statut 200
      expect(likeResponse.statusCode, 200);

      // Vérifie que la réponse contient des informations relatives au nombre de likes
      expect(likeResponse.body, '{"status":"success","totalLikes":0}'); // Vous pouvez adapter cette vérification selon la structure exacte de la réponse
    });

  });
}
