import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController cNoController;
  final void Function(String) searchChassis;

  SearchWidget({
    required this.cNoController,
    required this.searchChassis,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight / 2),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Container(
            margin: EdgeInsets.only(left: 4),
            height: (MediaQuery.of(context).size.height / 20),
            width: (MediaQuery.of(context).size.width -
                (MediaQuery.of(context).size.width / 10)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                controller: cNoController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
                onChanged: (value) {
                  searchChassis(value);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
