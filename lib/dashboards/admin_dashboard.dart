import 'package:flutter/material.dart';
import 'package:office_workforce_app/leave/leave_list_screen.dart';
import 'package:office_workforce_app/tasks/task_add_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/login_screen.dart';
import '../attendance/attendance_list_screen.dart';
import '../auth/auth_controller.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

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

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AttendanceListScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Admin Dashboard',
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
              _systemOverviewSection(),
              const SizedBox(height: 20),
              const Text(
                'System Management',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 12),
              _adminActionsGrid(context), // Pass context here!
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
          colors: [Color(0xFFEC4899), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEC4899).withOpacity(0.3),
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
              Icons.admin_panel_settings_outlined,
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
                  'Welcome, Administrator',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Full system control at your fingertips',
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

  Widget _systemOverviewSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statCard(
                icon: Icons.people_outline,
                title: 'Users',
                value: '156',
                subtitle: 'Total Active',
                color: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                icon: Icons.business_outlined,
                title: 'Departments',
                value: '12',
                subtitle: 'Active',
                color: const Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _statCard(
                icon: Icons.assignment_outlined,
                title: 'Tasks',
                value: '234',
                subtitle: 'In Progress',
                color: const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _statCard(
                icon: Icons.speed,
                title: 'Uptime',
                value: '99.9%',
                subtitle: 'This Month',
                color: const Color(0xFF8B5CF6),
              ),
            ),
          ],
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

  Widget _adminActionsGrid(BuildContext context) { // <-- Pass context here
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.15,
      children: [
        _actionCard(
          icon: Icons.group_outlined,
          title: 'Manage Users',
          subtitle: 'Add, edit, remove',
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          ),
          onTap: () {},
        ),
        _actionCard(
          icon: Icons.how_to_reg_outlined,
          title: 'All Attendance',
          subtitle: 'Monitor records',
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          onTap: () => _navigateToAttendance(context), // ✅ Works now
        ),

 _actionCard(
  icon: Icons.how_to_reg_outlined,
  title: 'All Leave',
  subtitle: 'Leave records',
  gradient: const LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  ),
  onTap: () async {
    final role = await AuthController.instance.getRole();
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveListScreen(role: role),
      ),
    );
  },
),


        _actionCard(
          icon: Icons.assignment_outlined,
          title: 'All Tasks',
          subtitle: 'View & manage',
          gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          ),
          onTap: () {Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const TaskAddScreen()),
);
},
        ),
        _actionCard(
          icon: Icons.analytics_outlined,
          title: 'Reports',
          subtitle: 'Generate insights',
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          ),
          onTap: () {},
        ),
        _actionCard(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'System config',
          gradient: const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
          ),
          onTap: () {},
        ),
        _actionCard(
          icon: Icons.security_outlined,
          title: 'Permissions',
          subtitle: 'Access control',
          gradient: const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
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
