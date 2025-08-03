import 'package:flutter/material.dart';
import '../shared/bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final balance = '1,250,000';
    final userName = "Dwi Prasetyo";

    return Scaffold(
      bottomNavigationBar: const BottomNav(),
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('images/avatar.png'),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  "Selamat Datang,",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Saldo Sekarang",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        Text(
                          "Rp $balance",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 8),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Color(0xFF1B233A)),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Sales History
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              children: [
                Row(
                  children: [
                    const Text(
                      "History",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.search, color: Colors.grey[600]),
                  ],
                ),
                const SizedBox(height: 18),
                _TransactionItem(
                  title: "Makan Siang",
                  subtitle: "Warung Sederhana • 2 days ago",
                  avatars: ['images/avatar.png', 'images/avatar.png'],
                  progress: 0.78,
                  progressColor: Colors.green,
                ),
                _TransactionItem(
                  title: "Belanja Bulanan",
                  subtitle: "Supermarket • 5 days ago",
                  avatars: ['images/avatar.png', 'images/avatar.png'],
                  progress: 0.20,
                  progressColor: Colors.lightBlue,
                ),
                _TransactionItem(
                  title: "Proyek Aplikasi",
                  subtitle: "Freelance • 1 week ago",
                  avatars: ['images/avatar.png', 'images/avatar.png'],
                  progress: 0.89,
                  progressColor: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> avatars;
  final double progress;
  final Color progressColor;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.avatars,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1B233A),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              ...avatars.map(
                (a) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundImage: AssetImage(a),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  color: progressColor,
                  backgroundColor: Colors.grey[200],
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${(progress * 100).round()}%",
                style: TextStyle(
                  color: progressColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
