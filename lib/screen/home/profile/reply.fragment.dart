import 'package:flutter/material.dart';

class ReplyFragment extends StatelessWidget {
  const ReplyFragment({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("REPLY"),
            ],
          ),
        ),
      );
}
