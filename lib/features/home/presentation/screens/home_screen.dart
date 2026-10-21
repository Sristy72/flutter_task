import 'package:flutter/material.dart';
import 'package:flutter_task/features/home/presentation/widgets/prayer_header.dart';
import '../../../../core/theme/app_colours.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color background = Color(0xFF0D1611);
  static const Color cardColor = Color(0xFF14231A);
  static const Color lime = Color(0xFFB4ED3D);
  static const Color muted = Color(0xFF7D8797);
  static const Color borderColor = Color(0xFF242D28);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          children: [
           PrayerHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  _prayerTrackingCard(),
                  const SizedBox(height: 24),
                  _goalCards(),
                  const SizedBox(height: 24),
                  _reflectionCard(),
                  const SizedBox(height: 24),
                  _abundanceVerseCard(),
                  const SizedBox(height: 38),
                  _shortcutCards(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Prayer times header


  // Prayer tracking
  Widget _prayerTrackingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have you prayed Dhuhr?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '2/5 prayers tracked today',
                  style: TextStyle(color: Color(0xFFA1A7A7), fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFF20372A)),
            ),
            child: const Icon(Icons.question_mark, color: lime, size: 27),
          ),
        ],
      ),
    );
  }

  // Daily goal and streak
  Widget _goalCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _goalCard(
            title: 'Daily Goal',
            icon: Icons.access_time,
            iconColor: const Color(0xFF5A897B),
            number: '0',
            suffix: '/5',
            message: 'Track a prayer to unlock goals',
            messageColor: lime,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _goalCard(
            title: 'Current Streak',
            icon: Icons.local_fire_department,
            iconColor: const Color(0xFFFFD54F),
            number: '0',
            suffix: ' days',
            message: 'Log today to begin streak',
            messageColor: const Color(0xFFFFD54F),
          ),
        ),
      ],
    );
  }

  Widget _goalCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String number,
    required String suffix,
    required String message,
    required Color messageColor,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 270),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(icon, color: iconColor, size: 29),
            ],
          ),
          const SizedBox(height: 32),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  suffix,
                  style: const TextStyle(color: muted, fontSize: 23),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: messageColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // AI Reflection
  Widget _reflectionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: lime, size: 25),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'AI REFLECTION',
                  style: TextStyle(
                    color: lime,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFA4D64A),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Assalamu alaikum! Welcome to your space for spiritual growth. Every big journey begins with a small step. Log your first prayer today to start building a beautiful, consistent habit',
            style: TextStyle(
              color: muted,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // Abundance verse
  Widget _abundanceVerseCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        color: const Color(0xFF14211C),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book, color: lime, size: 27),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'ABUNDANCE VERSE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  'Sahih al-Bukhari, 6412',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Start your daily verse by input them in reflections.',
            style: TextStyle(
              color: muted,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  // Qibla, Hijri, Zakat and Times shortcuts
  Widget _shortcutCards() {
    return Row(
      children: [
        Expanded(
          child: _shortcut(icon: Icons.explore, title: 'Qibla', color: lime),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _shortcut(
            icon: Icons.nightlight_round,
            title: 'Hijri',
            color: const Color(0xFF8C92FF),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _shortcut(
            icon: Icons.attach_money,
            title: 'Zakat',
            color: const Color(0xFFFFCA28),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _shortcut(
            icon: Icons.calendar_month,
            title: 'Times',
            color: const Color(0xFFFF62B0),
          ),
        ),
      ],
    );
  }

  Widget _shortcut({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 125),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 17),
      decoration: BoxDecoration(
        color: const Color(0xFF111B16),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: const Color(0xFF202B25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 53,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2821),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, color: color, size: 27),
          ),
          const SizedBox(height: 13),
          Text(
            title,
            style: const TextStyle(color: Color(0xFF9BA3AE), fontSize: 14),
          ),
        ],
      ),
    );
  }
}



