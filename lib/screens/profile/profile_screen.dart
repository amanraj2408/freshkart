import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../orders/order_history_screen.dart';

/// User profile and settings dashboard with address management, order shortcuts, and support.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  void _showHelpSupportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.headset_mic_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('FreshKart 24/7 Support',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Need help with your 10-minute grocery order?'),
            SizedBox(height: 12),
            Text('📞 Toll Free: 1800-FRESH-KART',
                style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 6),
            Text('📧 Email: support@freshkart.in',
                style: TextStyle(fontWeight: FontWeight.w700)),
            SizedBox(height: 12),
            Text('Our customer happiness team responds within 2 minutes!'),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showAttributionDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'FreshKart',
      applicationVersion: 'v1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.eco_rounded, color: Colors.white),
      ),
      children: const [
        Text(
          'FreshKart is a modern, high-performance grocery delivery application built using Flutter. '
          'Inspired by rapid quick-commerce UI concepts with custom green-and-cream branding, '
          'full null-safety, Provider state management, and reliable offline fallbacks.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        SizedBox(height: 10),
        Text(
          'Open-source reference attribution: sujal880/Blinkit-UI. Re-architected and completely redesigned for FreshKart.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProv, _) {
          final user = authProv.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primaryContainer,
                        child: Text(
                          user != null && user.name.isNotEmpty
                              ? user.name.substring(0, 1).toUpperCase()
                              : 'G',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Guest User',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.phone ?? 'Not signed in',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.email ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Quick stats row
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickStat('Fresh Club', 'Active',
                          Icons.verified_rounded, AppColors.primary),
                      _buildDivider(),
                      _buildQuickStat('Coupons', '3 Available',
                          Icons.local_offer_rounded, AppColors.accentAmber),
                      _buildDivider(),
                      _buildQuickStat('Speed', '10 Mins', Icons.bolt_rounded,
                          AppColors.primaryLight),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Menu items
                _buildMenuSection(
                  title: 'MY ACTIVITY',
                  items: [
                    _MenuItem(
                      icon: Icons.receipt_long_rounded,
                      title: 'Order History',
                      subtitle: 'Track active & previous deliveries',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const OrderHistoryScreen()),
                        );
                      },
                    ),
                    _MenuItem(
                      icon: Icons.location_on_rounded,
                      title: 'Delivery Addresses',
                      subtitle: authProv.activeDeliveryAddress,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Address can be managed directly from the Home screen location bar.'),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildMenuSection(
                  title: 'SETTINGS & SUPPORT',
                  items: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: AppColors.primary, size: 20),
                      ),
                      title: const Text(
                        'Delivery Notifications',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      subtitle: const Text(
                        'Updates when your order is out for delivery',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                      ),
                      trailing: Switch(
                        value: _notificationsEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() => _notificationsEnabled = val);
                        },
                      ),
                    ),
                    _MenuItem(
                      icon: Icons.headset_mic_rounded,
                      title: '24/7 Customer Care',
                      subtitle: 'Live support for quick order help',
                      onTap: _showHelpSupportDialog,
                    ),
                    _MenuItem(
                      icon: Icons.info_outline_rounded,
                      title: 'About FreshKart',
                      subtitle: 'App version, licenses & attributions',
                      onTap: _showAttributionDialog,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Sign Out or Sign In
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (authProv.isAuthenticated) {
                        authProv.logout();
                      }
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    icon: Icon(
                      authProv.isAuthenticated
                          ? Icons.logout_rounded
                          : Icons.login_rounded,
                      color: authProv.isAuthenticated
                          ? AppColors.error
                          : AppColors.primary,
                    ),
                    label: Text(
                      authProv.isAuthenticated ? 'Sign Out' : 'Sign In',
                      style: TextStyle(
                        color: authProv.isAuthenticated
                            ? AppColors.error
                            : AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: authProv.isAuthenticated
                            ? AppColors.error
                            : AppColors.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStat(String title, String val, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          val,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 28,
      width: 1,
      color: AppColors.borderLight,
    );
  }

  Widget _buildMenuSection(
      {required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
