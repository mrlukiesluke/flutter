import 'package:flutter/material.dart';

class LinkItem extends StatelessWidget {
  final String profileImageUrl;
  final String name;
  final String company;
  final String description;
  final String contentImageUrl;

  const LinkItem({
    super.key,
    required this.profileImageUrl,
    required this.name,
    required this.company,
    required this.description,
    required this.contentImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage('assets/images/id_male.jpg'),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    company,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/images/id_male.jpg', fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.thumb_up_alt_outlined),
              ),
              const SizedBox(width: 4),
              const Text("Like"),
              const SizedBox(width: 24),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.comment_outlined),
              ),
              const SizedBox(width: 4),
              const Text("Comment"),
            ],
          ),
        ],
      ),
    );
  }
}
