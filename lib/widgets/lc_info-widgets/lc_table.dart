import 'package:flutter/material.dart';

class LcTable extends StatelessWidget {
  const LcTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black),
              borderRadius: BorderRadius.circular(5.0)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              const Text(
                "LC Name",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit_note)),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              children: [
                _buildHeaderCell('Amount'),
                _buildHeaderCell('Profit/Loss'),
                _buildHeaderCell('Supplier'),
                _buildHeaderCell('Port'),
                _buildHeaderCell('IRC'),
                _buildHeaderCell('Bank'),
              ],
            ),
            const TableRow(
              children: [
                SizedBox(height: 6.0),
                SizedBox(height: 6.0),
                SizedBox(height: 6.0),
                SizedBox(height: 6.0),
                SizedBox(height: 6.0),
                SizedBox(height: 6.0),
              ],
            ),
            TableRow(
              children: [
                _buildCell('1000'),
                _buildCell('200'),
                _buildCell('ABC Corp'),
                _buildCell('Chattogram'),
                _buildCell('12345'),
                _buildCell('XYZ Bank'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildHeaderCell(String text) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8.0),
    margin: const EdgeInsets.symmetric(horizontal: 1.0),
    color: Colors.grey[400],
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}

Widget _buildCell(String text) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 1.0),
    padding: const EdgeInsets.all(8.0),
    color: Colors.grey[200],
    child: Text(text),
  );
}
