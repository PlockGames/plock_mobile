import 'package:flutter/material.dart';

class Comment {
  final String id;
  final String content;
  final DateTime createdAt;
  final String userId;
  final String gameId;
  final CommentUser user;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.gameId,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'] ?? '',
      gameId: json['gameId'] ?? '',
      user: CommentUser.fromJson(json['user'] ?? {}),
    );
  }
}

class CommentUser {
  final String id;
  final String username;
  final String email;
  final String? profilePic;

  CommentUser({
    required this.id,
    required this.username,
    required this.email,
    this.profilePic,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'] ?? '',
      username: json['username'] ?? 'Unknown User',
      email: json['email'] ?? '',
      profilePic: json[
          'pofilePic'], // Note: typo in API response field name 'pofilePic'
    );
  }
}
