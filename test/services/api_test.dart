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
    print("---------------");
    print(dotenv.env['API_URL']);
    print("---------------");

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
        title: 'test15',
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

      // Effectuer la requête de suppression
      final deleteResponse = await ApiService.deleteGame(gameId);

      print('Status Code de la suppression: ${deleteResponse.statusCode}');
      print('Response Body de la suppression: ${deleteResponse.body}');

      // Vérifiez que la suppression a bien eu lieu (code de statut 200)
      expect(deleteResponse.statusCode, 200);

      // Vérifiez que la réponse ne contient pas de message sur le like
      expect(deleteResponse.body, isNot(contains('Game liked')));

      // Vérifiez que la réponse contient un message indiquant la suppression du jeu
      expect(deleteResponse.body, contains('success'));
      expect(deleteResponse.body, contains('Message example')); // Adapté selon le message renvoyé
      expect(deleteResponse.body, contains('id'));
      expect(deleteResponse.body, contains('title'));

      // Vérifiez que le jeu a bien été supprimé en effectuant une requête GET
      final getResponse = await ApiService.getGame(gameId);

      // Si le jeu a été supprimé, vous devriez obtenir une réponse 404
      expect(getResponse.statusCode, 404);
    });



  });
}
