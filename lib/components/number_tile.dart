import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_state_provider.dart';

class NumberTile extends StatelessWidget {
  final int number;

  const NumberTile({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    final playerForNumber = gameState.numberToPlayerMap[number] ?? 1;
    final tileColor = gameState.getPlayerColor(playerForNumber);
    final sequenceNumber = gameState.numberToSequenceMap[number] ?? 0;
    final isCurrentPlayerTile = playerForNumber == gameState.currentPlayer;
    final isNextInSequence =
        sequenceNumber ==
        (gameState.currentExpectedNumbers[playerForNumber] ?? 1);

    return InkWell(
      onTap: () {
        gameState.tapNumber(number);
      },
      child: Container(
        decoration: BoxDecoration(
          color: tileColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border:
              isCurrentPlayerTile && isNextInSequence
                  ? Border.all(color: Colors.yellow, width: 2)
                  : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                sequenceNumber.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color:
                      tileColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: tileColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
