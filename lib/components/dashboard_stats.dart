import 'package:flutter/material.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.query_stats, color: Color(0xFF0D355E), size: 18),
              SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Civic Pulse Realtime',
                  style: TextStyle(
                    color: Color(0xFF0A3159),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(Icons.circle, color: Color(0xFFCC1623), size: 7),
              SizedBox(width: 4),
              Text(
                'Live 24 Jam',
                style: TextStyle(
                  color: Color(0xFF4C525D),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          Row(
            children: const [
              Expanded(
                child: _StatCard(
                  title: 'Klaim Dicek',
                  value: '14.280',
                  note: '↗ +312 hr ini',
                  valueColor: Color(0xFF092F57),
                  noteColor: Color(0xFF07838A),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  title: 'Hoaks Dicegah',
                  value: '8.912',
                  note: '△ 62.4% total',
                  valueColor: Color(0xFFD31821),
                  noteColor: Color(0xFFD31821),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _StatCard(
                  title: 'Akurasi AI',
                  value: '94.8%',
                  note: '⚙ 4 model LLM',
                  valueColor: Color(0xFF092F57),
                  noteColor: Color(0xFF07838A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.note,
    required this.valueColor,
    required this.noteColor,
  });

  final String title;
  final String value;
  final String note;
  final Color valueColor;
  final Color noteColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.fromLTRB(9, 7, 5, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF464C56),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 21,
              height: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: TextStyle(
              color: noteColor,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
