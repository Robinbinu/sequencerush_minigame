import 'dart:math';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  int numberOfPlayers = 1;
  int currentPlayer = 1;
  List<int> numbers = []; // All numbers combined for display
  Map<int, int> currentExpectedNumbers =
      {}; // Next expected number for each player
  Map<int, int> playerScores = {};
  bool isGameOver = false;
  int gameTimeInSeconds = 60;
  int remainingTime = 60;

  // Maps to track which player each number belongs to and its sequence value
  Map<int, int> numberToPlayerMap = {};
  Map<int, int> numberToSequenceMap = {};

  // Colors for each player
  final List<Color> playerColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
  ];

  Color getPlayerColor(int playerId) {
    return playerColors[(playerId - 1) % playerColors.length];
  }

  void setNumberOfPlayers(int count) {
    numberOfPlayers = count;
    resetPlayerScores();
    notifyListeners();
  }

  void resetPlayerScores() {
    playerScores = {};
    currentExpectedNumbers = {};
    for (int i = 1; i <= numberOfPlayers; i++) {
      playerScores[i] = 0;
      currentExpectedNumbers[i] = 1; // Start with 1 for each player
    }
  }

  void startGame() {
    // Reset state
    numbers = [];
    numberToPlayerMap = {};
    numberToSequenceMap = {};

    // Generate numbers for each player (1-25 each)
    int displayValue = 1;
    for (int playerId = 1; playerId <= numberOfPlayers; playerId++) {
      for (int sequenceNumber = 1; sequenceNumber <= 25; sequenceNumber++) {
        numbers.add(displayValue);
        numberToPlayerMap[displayValue] = playerId;
        numberToSequenceMap[displayValue] = sequenceNumber;
        displayValue++;
      }
    }

    // Shuffle all numbers for random placement
    numbers.shuffle(Random());

    // Reset player state
    currentPlayer = 1;
    isGameOver = false;
    remainingTime = gameTimeInSeconds;
    resetPlayerScores();
    notifyListeners();
  }

  bool tapNumber(int number) {
    // Check which player this number belongs to
    int playerForNumber = numberToPlayerMap[number] ?? 1;

    // Check if it's the current player's turn and if this is their number
    if (playerForNumber == currentPlayer) {
      // Get the sequence number (1-25)
      int sequenceNumber = numberToSequenceMap[number] ?? 0;

      // Check if this is the next expected number for this player
      if (sequenceNumber == currentExpectedNumbers[currentPlayer]) {
        // Correct tap
        playerScores[currentPlayer] = (playerScores[currentPlayer] ?? 0) + 1;
        currentExpectedNumbers[currentPlayer] =
            (currentExpectedNumbers[currentPlayer] ?? 0) + 1;

        // Check if this player has completed their sequence
        if (currentExpectedNumbers[currentPlayer]! > 25) {
          // Check if all players have completed their sequences
          bool allComplete = true;
          for (int i = 1; i <= numberOfPlayers; i++) {
            if ((currentExpectedNumbers[i] ?? 0) <= 25) {
              allComplete = false;
              break;
            }
          }

          if (allComplete) {
            isGameOver = true;
          } else {
            // Move to next player who hasn't finished
            moveToNextAvailablePlayer();
          }
        } else {
          // Switch to next player if in multiplayer mode
          if (numberOfPlayers > 1) {
            moveToNextAvailablePlayer();
          }
        }

        notifyListeners();
        return true;
      } else {
        // Wrong sequence number
        isGameOver = true;
        notifyListeners();
        return false;
      }
    } else {
      // Wrong player's number
      isGameOver = true;
      notifyListeners();
      return false;
    }
  }

  void moveToNextAvailablePlayer() {
    if (numberOfPlayers <= 1) return;

    int originalPlayer = currentPlayer;
    do {
      currentPlayer = currentPlayer < numberOfPlayers ? currentPlayer + 1 : 1;
      // If we've checked all players and come back to the original, break to avoid infinite loop
      if (currentPlayer == originalPlayer) break;
    } while ((currentExpectedNumbers[currentPlayer] ?? 0) > 25);
  }

  void tick() {
    if (remainingTime > 0) {
      remainingTime--;
      if (remainingTime == 0) {
        isGameOver = true;
      }
      notifyListeners();
    }
  }

  int? getWinner() {
    if (!isGameOver) return null;

    int maxScore = 0;
    int? winnerId;

    playerScores.forEach((playerId, score) {
      if (score > maxScore) {
        maxScore = score;
        winnerId = playerId;
      }
    });

    return winnerId;
  }
}
