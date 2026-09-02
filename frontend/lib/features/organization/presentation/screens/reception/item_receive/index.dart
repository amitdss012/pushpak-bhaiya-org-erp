import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import 'new_receive_dialog.dart';
import 'receive_details_dialog.dart';
import 'receive_header.dart';
import 'receive_stats_grid.dart';
import 'receive_table_card.dart';

class ItemReceiveScreen extends StatefulWidget {
  const ItemReceiveScreen({super.key});

  @override
  State<ItemReceiveScreen> createState() => _ItemReceiveScreenState();
}

class _ItemReceiveScreenState extends State<ItemReceiveScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _receivedData = [
    {
      'id': 'RCV001',
      'itemName': 'Office Stationery',
      'description': 'Pens, notebooks, and files',
      'quantity': 100,
      'senderName': 'ABC Suppliers',
      'senderAddress': 'Industrial Area, Delhi',
      'senderPhone': '+91 98765 43210',
      'courierService': 'Blue Dart',
      'trackingNumber': 'BD987654321',
      'receivedDate': 'Jan 24, 2024 11:30 AM',
      'receivedBy': 'Reception Staff',
      'department': 'Administration',
      'condition': 'good',
      'status': 'completed',
    },
    {
      'id': 'RCV002',
      'itemName': 'Computer Accessories',
      'description': 'Keyboards, mice, and USB cables',
      'quantity': 25,
      'senderName': 'Tech Solutions Pvt Ltd',
      'senderAddress': 'Electronics Hub, Mumbai',
      'senderPhone': '+91 98765 43211',
      'courierService': 'FedEx',
      'trackingNumber': 'FX123456789',
      'receivedDate': 'Jan 24, 2024 02:00 PM',
      'receivedBy': 'IT Staff',
      'department': 'IT Department',
      'condition': 'good',
      'status': 'completed',
    },
    {
      'id': 'RCV003',
      'itemName': 'Lab Chemicals',
      'description': 'Chemistry lab reagents and chemicals',
      'quantity': 15,
      'senderName': 'Scientific Supplies Co',
      'senderAddress': 'Chemical Zone, Chennai',
      'senderPhone': '+91 98765 43212',
      'courierService': 'DTDC',
      'trackingNumber': 'DTDC456789123',
      'receivedDate': 'Jan 24, 2024 09:45 AM',
      'receivedBy': 'Lab Assistant',
      'department': 'Science Department',
      'condition': 'partial',
      'status': 'active',
    },
    {
      'id': 'RCV004',
      'itemName': 'Sports Equipment',
      'description': 'Basketball and volleyball sets',
      'quantity': 10,
      'senderName': 'Sports World',
      'senderAddress': 'Sports Complex, Bangalore',
      'senderPhone': '+91 98765 43213',
      'courierService': 'Delhivery',
      'trackingNumber': 'DL789123456',
      'receivedDate': 'Jan 24, 2024 04:30 PM',
      'receivedBy': 'Sports Coordinator',
      'department': 'Sports',
      'condition': 'damaged',
      'status': 'active',
    },
    {
      'id': 'RCV005',
      'itemName': 'Library Books',
      'description': 'Reference books and journals',
      'quantity': 75,
      'senderName': 'Publishers Hub',
      'senderAddress': 'Book Street, Kolkata',
      'senderPhone': '+91 98765 43214',
      'courierService': 'India Post',
      'trackingNumber': 'IP321654987',
      'receivedDate': 'Jan 23, 2024 10:00 AM',
      'receivedBy': 'Librarian',
      'department': 'Library',
      'condition': 'good',
      'status': 'completed',
    },
    {
      'id': 'RCV006',
      'itemName': 'Art Supplies',
      'description': 'Paints, brushes, and canvases',
      'quantity': 50,
      'senderName': 'Creative Arts Store',
      'senderAddress': 'Art District, Jaipur',
      'senderPhone': '+91 98765 43215',
      'courierService': 'Blue Dart',
      'trackingNumber': 'BD654321987',
      'receivedDate': 'Jan 24, 2024 12:15 PM',
      'receivedBy': 'Art Teacher',
      'department': 'Arts Department',
      'condition': 'good',
      'status': 'pending',
    },
  ];

  void _handleLogNewItem() {
    showDialog(
      context: context,
      builder: (context) => NewReceiveDialog(
        onSubmit: (newItem) {
          setState(() {
            _receivedData.insert(0, newItem);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Received item recorded successfully.'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _handleView(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => ReceiveDetailsDialog(
        item: item,
        onPrintReceipt: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Printing Receipt for ${item['id']}...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _handlePrint(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Printing acknowledgment for ${item['id']}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleForward(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Item forwarded to ${item['department']}.'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDelete(Map<String, dynamic> item) {
    setState(() {
      _receivedData.removeWhere((d) => d['id'] == item['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Record ${item['id']} deleted.'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    final filteredItems = _receivedData.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (item['itemName'] as String).toLowerCase();
      final sender = (item['senderName'] as String).toLowerCase();
      final tracking = (item['trackingNumber'] as String).toLowerCase();
      final id = (item['id'] as String).toLowerCase();
      return name.contains(q) || sender.contains(q) || tracking.contains(q) || id.contains(q);
    }).toList();

    final totalReceived = _receivedData.length;
    final goodCondition = _receivedData.where((d) => d['condition'] == 'good').length;
    final damaged = _receivedData.where((d) => d['condition'] == 'damaged').length;
    final pendingVerification = _receivedData.where((d) => d['status'] == 'pending').length;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          ReceiveHeader(onLogItem: _handleLogNewItem),
          AppSpacing.vXl,

          // Stats Grid
          ReceiveStatsGrid(
            totalReceived: totalReceived,
            goodCondition: goodCondition,
            damaged: damaged,
            pendingVerification: pendingVerification,
          ),
          AppSpacing.vXl,

          // Data Table Card
          ReceiveTableCard(
            items: filteredItems,
            searchQuery: _searchQuery,
            onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
            onView: _handleView,
            onPrint: _handlePrint,
            onForward: _handleForward,
            onDelete: _handleDelete,
          ),
        ],
      ),
    );
  }
}
