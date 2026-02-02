import 'package:flutter/material.dart';
import 'package:office_workforce_app/leave/apply_leave_screen.dart';
import 'package:office_workforce_app/tasks/task_list_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_screen.dart';
import '../attendance/employee_attendance_screen.dart';
import '../attendance/attendance_list_screen.dart';
import '../auth/auth_controller.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Future<void> _navigateToAttendance(BuildContext context) async {
    final role = await AuthController.instance.getRole();

    if (!context.mounted) return;

    if (role == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EmployeeAttendanceScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AttendanceListScreen(role: role)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Employee Dashboard',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.logout_outlined, color: Color(0xFF6B7280)),
              tooltip: 'Logout',
              onPressed: () => _logout(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _welcomeCard(),
              const SizedBox(height: 20),
              _quickStatsSection(),
              const SizedBox(height: 20),
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              _quickActionsGrid(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcomeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Have a productive day ahead',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickStatsSection() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.check_circle_outline,
            title: 'Tasks',
            value: '12',
            subtitle: 'Completed',
            color: const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.schedule_outlined,
            title: 'Hours',
            value: '38.5',
            subtitle: 'This Week',
            color: const Color(0xFF3B82F6),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _quickActionsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.15,
      children: [
        _actionCard(
          icon: Icons.fingerprint,
          title: 'Attendance',
          subtitle: 'Mark your presence',
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          onTap: () => _navigateToAttendance(context),
        ),
        _actionCard(
          icon: Icons.assignment_outlined,
          title: 'My Tasks',
          subtitle: 'View assignments',
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          ),
          onTap: () {Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const TaskListScreen()),
);
},
        ),
       _actionCard(
  icon: Icons.beach_access_outlined,
  title: 'Apply Leave',
  subtitle: 'Request time off',
  gradient: const LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ApplyLeaveScreen(),
      ),
    );
  },
),

        _actionCard(
          icon: Icons.trending_up,
          title: 'Performance',
          subtitle: 'Track progress',
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          ),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
