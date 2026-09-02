import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import 'visitor_checkout_dialog.dart';
import 'visitor_details_dialog.dart';
import 'visitors_header.dart';
import 'visitors_stats_grid.dart';
import 'visitors_table_card.dart';

class VisitorsInformationScreen extends StatefulWidget {
  const VisitorsInformationScreen({super.key});

  @override
  State<VisitorsInformationScreen> createState() => _VisitorsInformationScreenState();
}

class _VisitorsInformationScreenState extends State<VisitorsInformationScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _visitorsData = [
    {
      'id': 'V001',
      'name': 'Rajesh Kumar',
      'phone': '+91 98765 43210',
      'email': 'rajesh.k@email.com',
      'purpose': 'Admission Enquiry',
      'personToMeet': 'Principal',
      'department': 'Administration',
      'checkIn': '09:30 AM',
      'checkOut': '10:45 AM',
      'status': 'completed',
      'idType': 'Aadhar Card',
      'idNumber': 'XXXX-XXXX-1234',
      'enquiryReason': 'Looking for admission in Class 10 for son',
      'location': 'Mumbai, Maharashtra',
      'followUpDate': 'Jan 28, 2024',
    },
    {
      'id': 'V002',
      'name': 'Priya Sharma',
      'phone': '+91 98765 43211',
      'email': 'priya.s@email.com',
      'purpose': 'Fee Related',
      'personToMeet': 'Accounts Dept',
      'department': 'Accounts',
      'checkIn': '10:00 AM',
      'checkOut': null,
      'status': 'active',
      'idType': 'PAN Card',
      'idNumber': 'ABCDE1234F',
      'enquiryReason': 'Fee discount enquiry for scholarship',
      'location': 'Pune, Maharashtra',
      'followUpDate': 'Jan 26, 2024',
    },
    {
      'id': 'V003',
      'name': 'Amit Patel',
      'phone': '+91 98765 43212',
      'email': 'amit.p@email.com',
      'purpose': 'Meeting',
      'personToMeet': 'Admin Officer',
      'department': 'Administration',
      'checkIn': '11:15 AM',
      'checkOut': null,
      'status': 'active',
      'idType': 'Driving License',
      'idNumber': 'DL-XXXX-1234',
      'enquiryReason': 'Discussion about school infrastructure project',
      'location': 'Delhi',
      'followUpDate': null,
    },
    {
      'id': 'V004',
      'name': 'Sunita Verma',
      'phone': '+91 98765 43213',
      'email': 'sunita.v@email.com',
      'purpose': 'Complaint',
      'personToMeet': 'Counselor',
      'department': 'Academics',
      'checkIn': '09:00 AM',
      'checkOut': '09:45 AM',
      'status': 'completed',
      'idType': 'Voter ID',
      'idNumber': 'ABC1234567',
      'enquiryReason': 'Complaint regarding student behavior issue',
      'location': 'Thane, Maharashtra',
      'followUpDate': 'Jan 30, 2024',
    },
    {
      'id': 'V005',
      'name': 'Vikram Singh',
      'phone': '+91 98765 43214',
      'email': 'vikram.s@email.com',
      'purpose': 'Delivery',
      'personToMeet': 'Other Staff',
      'department': 'Administration',
      'checkIn': '12:00 PM',
      'checkOut': '12:15 PM',
      'status': 'completed',
      'idType': 'Aadhar Card',
      'idNumber': 'XXXX-XXXX-5678',
      'enquiryReason': 'Stationery delivery for office',
      'location': 'Navi Mumbai',
      'followUpDate': null,
    },
    {
      'id': 'V006',
      'name': 'Meera Joshi',
      'phone': '+91 98765 43215',
      'email': 'meera.j@email.com',
      'purpose': 'Interview',
      'personToMeet': 'HR Department',
      'department': 'Human Resources',
      'checkIn': '02:00 PM',
      'checkOut': null,
      'status': 'pending',
      'idType': 'Passport',
      'idNumber': 'J1234567',
      'enquiryReason': 'Teacher position interview',
      'location': 'Bangalore, Karnataka',
      'followUpDate': 'Jan 25, 2024',
    },
  ];

  void _handleView(Map<String, dynamic> visitor) {
    showDialog(
      context: context,
      builder: (context) => VisitorDetailsDialog(
        visitor: visitor,
        onPrintPass: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Printing Visitor Pass for ${visitor['name']}...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _handleCheckout(Map<String, dynamic> visitor) {
    showDialog(
      context: context,
      builder: (context) => VisitorCheckoutDialog(
        visitor: visitor,
        onConfirm: () {
          setState(() {
            visitor['status'] = 'completed';
            visitor['checkOut'] = 'Now';
          });
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${visitor['name']} has been checked out.'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _handlePrint(Map<String, dynamic> visitor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Printing Visitor Pass for ${visitor['name']}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDelete(Map<String, dynamic> visitor) {
    setState(() {
      _visitorsData.removeWhere((v) => v['id'] == visitor['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Visitor ${visitor['name']} deleted.'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    final filteredVisitors = _visitorsData.where((v) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (v['name'] as String).toLowerCase();
      final phone = (v['phone'] as String).toLowerCase();
      final purpose = (v['purpose'] as String).toLowerCase();
      final id = (v['id'] as String).toLowerCase();
      return name.contains(q) || phone.contains(q) || purpose.contains(q) || id.contains(q);
    }).toList();

    final activeVisitors = _visitorsData.where((v) => v['status'] == 'active').length;
    final completedToday = _visitorsData.where((v) => v['status'] == 'completed').length;
    final totalToday = _visitorsData.length;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const VisitorsHeader(),
          AppSpacing.vXl,

          // Stats Grid
          VisitorsStatsGrid(
            totalToday: totalToday,
            activeVisitors: activeVisitors,
            completedToday: completedToday,
          ),
          AppSpacing.vXl,

          // Data Table Card
          VisitorsTableCard(
            visitors: filteredVisitors,
            searchQuery: _searchQuery,
            onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
            onView: _handleView,
            onCheckout: _handleCheckout,
            onPrint: _handlePrint,
            onDelete: _handleDelete,
          ),
        ],
      ),
    );
  }
}
