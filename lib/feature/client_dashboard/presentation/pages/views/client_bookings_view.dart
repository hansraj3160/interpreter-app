import 'package:flutter/material.dart';

class ClientBookingsView extends StatelessWidget {
  const ClientBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('My Bookings'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
            indicatorColor: Colors.white,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookingsList(context, isUpcoming: true),
            _buildBookingsList(context, isUpcoming: false),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, {required bool isUpcoming}) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: isUpcoming ? 2 : 5, // Dummy data count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Spanish Interpreter',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isUpcoming ? Colors.orange.shade100 : Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isUpcoming ? 'Pending' : 'Completed',
                        style: TextStyle(
                          color: isUpcoming ? Colors.orange.shade800 : Colors.green.shade800,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(isUpcoming ? 'Oct 25, 2026 - 10:00 AM' : 'Oct 10, 2026 - 02:00 PM', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Interpreter: Sarah Johnson', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                if (isUpcoming) ...[
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () {}, child: const Text('Cancel')),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: () {}, child: const Text('View Details')),
                    ],
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}