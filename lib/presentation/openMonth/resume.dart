import 'package:controle_carteiras/data/formatText.dart';
import 'package:controle_carteiras/presentation/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Resume extends StatefulWidget {
  final double initialValue;
  final double finalValue;
  final double backupAmount;

  const Resume(
      {super.key,
      required this.initialValue,
      required this.finalValue,
      required this.backupAmount});

  @override
  State<StatefulWidget> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  double removeFromHighRisk = 0;
  int removePercentage = 50;
  double reinvestValue = 0;
  int reinvestPercentage = 25;
  double sendToBackup = 0;
  int sendToBackupPercentage = 25;
  double profit = 0;
  int backupPercentage = 0;

  @override
  build(BuildContext context) {
    profit = widget.finalValue - widget.initialValue;
    _calcReinvestAndProfit(
        initialValue: widget.initialValue,
        finalValue: widget.finalValue,
        backupAmount: widget.backupAmount);

    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _resumeContainer(
                  title: "Valor a ser reinvestido",
                  value: reinvestValue,
                  subText: reinvestValue > 0
                      ? Text(
                          '$reinvestPercentage% do retorno',
                          style: const TextStyle(fontSize: 12),
                        )
                      : const Text('-'),
                  color: Colors.lightBlueAccent.withOpacity(0.2)),
              _resumeContainer(
                  title: "Lucro",
                  value: removeFromHighRisk,
                  subText: removeFromHighRisk > 0
                      ? Text(
                          '$removePercentage% do retorno',
                          style: const TextStyle(fontSize: 12),
                        )
                      : const Text('-'),
                  color: Colors.lightBlueAccent.withOpacity(0.2)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _resumeContainer(
                  title: "Dif reserva",
                  value: sendToBackup,
                  subText: sendToBackup > 0
                      ? Text(
                          '$sendToBackupPercentage% do lucro',
                          style: const TextStyle(fontSize: 12),
                        )
                      : const Text('-'),
                  color: Colors.lightBlueAccent.withOpacity(0.2)),
              _resumeContainer(
                  title: "Saldo reserva",
                  value: widget.backupAmount,
                  subText: Text(
                    '$backupPercentage% do total',
                    style: const TextStyle(fontSize: 12),
                  ),
                  color: backupPercentage >= 50
                      ? Colors.lightBlueAccent.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2)),
            ],
          ),
        ],
      ),
    );
  }

  _resumeContainer(
      {required String title,
      required double value,
      required Text subText,
      required Color color}) {
    Widget sizedBox = const SizedBox(height: 6);
    return SizedBox(
      width: 170,
      child: BeautifulContainer(
        color: Colors.lightBlueAccent.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(4),
          color: color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 4, top: 4),
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              sizedBox,
              Text(
                '${FormatText().setValueTextCommas(value)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizedBox,
              subText,
            ],
          ),
        ),
      ),
    );
  }

  _calcReinvestAndProfit(
      {required double finalValue,
      required double initialValue,
      required double backupAmount}) {
    double dif = initialValue - backupAmount;
    double percentage = 100 - (dif / initialValue * 100);

    if (initialValue != 0 && backupAmount != 0) {
      backupPercentage = percentage.toInt();
    }

    if (profit > 0) {
      if (percentage >= 50) {
        reinvestValue = profit * 0.50;
        reinvestPercentage = 50;
        removeFromHighRisk = profit * 0.25;
        removePercentage = 25;
        sendToBackup = profit * 0.25;
        sendToBackupPercentage = 25;
      } else {
        reinvestValue = profit * 0.35;
        reinvestPercentage = 35;
        removeFromHighRisk = profit * 0.25;
        removePercentage = 25;
        sendToBackup = profit * 0.4;
        sendToBackupPercentage = 40;
      }
    } else {
      reinvestValue = 0;
      reinvestPercentage = 0;
      removeFromHighRisk = 0;
      removePercentage = 0;
      sendToBackup = profit;
    }
  }

}
