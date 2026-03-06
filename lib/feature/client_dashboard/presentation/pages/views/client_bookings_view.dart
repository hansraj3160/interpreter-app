import 'package:flutter/material.dart';

class ClientBookingsView extends StatelessWidget {
  const ClientBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'My Bookings',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [

            /// Tabs
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: TabBar(
    indicatorColor: Theme.of(context).colorScheme.primary,
    indicatorWeight: 3,
    labelColor: Theme.of(context).colorScheme.primary,
    unselectedLabelColor: Colors.grey,
    labelStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    tabs: const [
      Tab(text: "Upcoming"),
      Tab(text: "Past"),
    ],
  ),
),

            /// Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  _buildBookingsList(context, isUpcoming: true),
                  _buildBookingsList(context, isUpcoming: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, {required bool isUpcoming}) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: isUpcoming ? 2 : 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spanish Interpreter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  /// Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? Colors.orange.shade50
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isUpcoming ? 'Pending' : 'Completed',
                      style: TextStyle(
                        color: isUpcoming
                            ? Colors.orange.shade700
                            : Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 14),

              /// Date
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text(
                    isUpcoming
                        ? 'Oct 25, 2026 • 10:00 AM'
                        : 'Oct 10, 2026 • 02:00 PM',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Interpreter
              Row(
                children: [
                  Icon(Icons.person_outline,
                      size: 16, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text(
                    'Interpreter: Sarah Johnson',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              if (isUpcoming) ...[
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade200),

                /// Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 40),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('View Details'),
                    ),
                  ],
                )
              ]
            ],
          ),
        );
      },
    );
  }
}