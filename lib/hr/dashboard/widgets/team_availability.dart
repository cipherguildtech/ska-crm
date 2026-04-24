import 'package:flutter/material.dart';
import '../team_availability/teams.dart';

const Color primary = Color(0xFF1BA39C);

class TeamAvailability extends StatelessWidget {
  final List teams;

  const TeamAvailability({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Team Availability",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeamDetailsPage(),
                  ),
                );
              },
              child: const Text(
                "See all",
                style: TextStyle(color: primary),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Column(
          children: teams.map((team) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline),
                  const SizedBox(width: 10),
                  Text(team['name']),
                  const Spacer(),
                  Text("${team['tasks']} Tasks"),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}