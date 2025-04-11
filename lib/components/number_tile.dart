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

    final screenSize = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        gameState.tapNumber(number);
      },
      child: Container(
        decoration: BoxDecoration(
          color: tileColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(screenSize.width * 0.02),
          border:
              isCurrentPlayerTile && isNextInSequence
                  ? Border.all(
                    color: Colors.yellow,
                    width: screenSize.width * 0.005,
                  )
                  : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: screenSize.width * 0.01,
              offset: Offset(0, screenSize.width * 0.005),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                sequenceNumber.toString(),
                style: TextStyle(
                  fontSize: screenSize.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color:
                      tileColor.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                ),
              ),
            ),
            Positioned(
              top: screenSize.width * 0.005,
              right: screenSize.width * 0.005,
              child: Container(
                width: screenSize.width * 0.03,
                height: screenSize.width * 0.03,
                decoration: BoxDecoration(
                  color: tileColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: screenSize.width * 0.002,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
