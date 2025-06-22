import 'package:flutter/material.dart';
import 'package:reusekit/core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final supabase = Supabase.instance.client;
  bool loading = true;
  List graduationEvents = [];
  Map<String, dynamic> statistics = {
    'totalStudents': 0,
    'totalInvitations': 0,
    'upcomingEvents': 0,
    'confirmedAttendees': 0,
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    loading = true;
    setState(() {});
    try {
      // Load graduation events
      final eventsResponse = await supabase
          .from('graduation_events')
          .select()
          .order('graduation_date', ascending: true)
          .limit(5);
      graduationEvents = eventsResponse;

      // Get statistics
      List students = await supabase.from('students').select();
      List invitations = await supabase.from('graduation_invitations').select();
      List upcomingEvents = await supabase
          .from('graduation_events')
          .select()
          .gte('graduation_date', DateTime.now().toIso8601String());
      List confirmedAttendees = await supabase
          .from('graduation_invitations')
          .select()
          .eq('invitation_status', 'confirmed');

      statistics = {
        'totalStudents': students.length,
        'totalInvitations': invitations.length,
        'upcomingEvents': upcomingEvents.length,
        'confirmedAttendees': confirmedAttendees.length,
      };
    } catch (e) {
      se("Failed to load data");
    }

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.school,
                    size: 36.0,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    "Graduation Dashboard",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              // Statistics Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 1.6,
                children: [
                  _buildStatCard(
                    "Total Students",
                    statistics['totalStudents'].toString(),
                    Icons.people,
                    const [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),
                  _buildStatCard(
                    "Total Invitations",
                    statistics['totalInvitations'].toString(),
                    Icons.mail,
                    const [Color(0xFF11998E), Color(0xFF38EF7D)],
                  ),
                  _buildStatCard(
                    "Upcoming Events",
                    statistics['upcomingEvents'].toString(),
                    Icons.event,
                    const [Color(0xFFF7971E), Color(0xFFFFD200)],
                  ),
                  _buildStatCard(
                    "Confirmed Attendees",
                    statistics['confirmedAttendees'].toString(),
                    Icons.check_circle,
                    const [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upcoming Graduation Events",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                  ),
                  QButton(
                    label: "View All",
                    onPressed: () {},
                    color: Colors.deepPurple,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Upcoming Events List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: graduationEvents.length,
                itemBuilder: (context, index) {
                  final event = graduationEvents[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['event_name'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple[700],
                                ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18.0, color: Colors.grey),
                              const SizedBox(width: 8.0),
                              Text(
                                DateTime.parse(event['graduation_date'])
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 24.0),
                              const Icon(Icons.schedule, size: 18.0, color: Colors.grey),
                              const SizedBox(width: 8.0),
                              Text(
                                event['graduation_time'],
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 18.0, color: Colors.grey),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  event['venue'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Capacity: ${event['current_registrations']}/${event['total_capacity']}",
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(event['event_status']).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  event['event_status'].toUpperCase(),
                                  style: TextStyle(
                                    color: _getStatusColor(event['event_status']),
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, List<Color> gradientColors) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.4),
            offset: const Offset(0, 8),
            blurRadius: 12,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 36.0,
            color: Colors.white,
          ),
          const SizedBox(height: 12.0),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6.0),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planning':
        return Colors.blue;
      case 'open':
        return Colors.green;
      case 'closed':
        return Colors.red;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
