import 'package:flutter/material.dart';

import '../../../../../../app/theme/app_colors.dart';
import '../../../../../../app/theme/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import 'dispatch_details_dialog.dart';
import 'dispatch_header.dart';
import 'dispatch_stats_grid.dart';
import 'dispatch_table_card.dart';
import 'new_dispatch_dialog.dart';

class ItemDispatchScreen extends StatefulWidget {
  const ItemDispatchScreen({super.key});

  @override
  State<ItemDispatchScreen> createState() => _ItemDispatchScreenState();
}

class _ItemDispatchScreenState extends State<ItemDispatchScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _dispatchData = [
    {
      'id': 'DSP001',
      'itemName': 'Student Certificates',
      'description': 'Batch of 25 completion certificates',
      'quantity': 25,
      'recipientName': 'ABC Institute',
      'recipientAddress': '123 Education Lane, Mumbai',
      'recipientPhone': '+91 98765 43210',
      'courierService': 'Blue Dart',
      'trackingNumber': 'BD123456789',
      'dispatchDate': 'Jan 24, 2024',
      'expectedDelivery': 'Jan 26, 2024',
      'status': 'active',
      'dispatchedBy': 'Admin Staff',
    },
    {
      'id': 'DSP002',
      'itemName': 'Exam Papers',
      'description': 'Mid-term exam question papers',
      'quantity': 150,
      'recipientName': 'Regional Office',
      'recipientAddress': '456 Main Road, Delhi',
      'recipientPhone': '+91 98765 43211',
      'courierService': 'DTDC',
      'trackingNumber': 'DTDC987654321',
      'dispatchDate': 'Jan 23, 2024',
      'expectedDelivery': 'Jan 25, 2024',
      'status': 'completed',
      'dispatchedBy': 'Exam Coordinator',
    },
    {
      'id': 'DSP003',
      'itemName': 'Lab Equipment',
      'description': 'Microscope and lab supplies',
      'quantity': 5,
      'recipientName': 'Science Department',
      'recipientAddress': 'Branch Campus, Pune',
      'recipientPhone': '+91 98765 43212',
      'courierService': 'FedEx',
      'trackingNumber': 'FX567891234',
      'dispatchDate': 'Jan 24, 2024',
      'expectedDelivery': 'Jan 27, 2024',
      'status': 'active',
      'dispatchedBy': 'Lab Manager',
    },
    {
      'id': 'DSP004',
      'itemName': 'Books & Journals',
      'description': 'Reference books for library',
      'quantity': 50,
      'recipientName': 'Central Library',
      'recipientAddress': 'University Campus, Chennai',
      'recipientPhone': '+91 98765 43213',
      'courierService': 'India Post',
      'trackingNumber': 'IP123789456',
      'dispatchDate': 'Jan 22, 2024',
      'expectedDelivery': 'Jan 28, 2024',
      'status': 'pending',
      'dispatchedBy': 'Librarian',
    },
    {
      'id': 'DSP005',
      'itemName': 'Sports Equipment',
      'description': 'Cricket bats and footballs',
      'quantity': 20,
      'recipientName': 'Sports Complex',
      'recipientAddress': 'Sports Wing, Bangalore',
      'recipientPhone': '+91 98765 43214',
      'courierService': 'Delhivery',
      'trackingNumber': 'DL456123789',
      'dispatchDate': 'Jan 24, 2024',
      'expectedDelivery': 'Jan 26, 2024',
      'status': 'pending',
      'dispatchedBy': 'Sports Coordinator',
    },
  ];

  void _handleNewDispatch() {
    showDialog(
      context: context,
      builder: (context) => NewDispatchDialog(
        onSubmit: (newItem) {
          setState(() {
            _dispatchData.insert(0, newItem);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item dispatched successfully.'),
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
      builder: (context) => DispatchDetailsDialog(
        item: item,
        onTrack: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tracking shipment ${item['trackingNumber']} with ${item['courierService']}...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _handleTrack(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking ${item['trackingNumber']} (${item['courierService']})...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleMarkDelivered(Map<String, dynamic> item) {
    setState(() {
      item['status'] = 'completed';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['itemName']} marked as delivered.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleDelete(Map<String, dynamic> item) {
    setState(() {
      _dispatchData.removeWhere((d) => d['id'] == item['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dispatch ${item['id']} cancelled.'),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    final filteredItems = _dispatchData.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (item['itemName'] as String).toLowerCase();
      final recipient = (item['recipientName'] as String).toLowerCase();
      final tracking = (item['trackingNumber'] as String).toLowerCase();
      final id = (item['id'] as String).toLowerCase();
      return name.contains(q) || recipient.contains(q) || tracking.contains(q) || id.contains(q);
    }).toList();

    final totalDispatched = _dispatchData.length;
    final inTransit = _dispatchData.where((d) => d['status'] == 'active').length;
    final delivered = _dispatchData.where((d) => d['status'] == 'completed').length;
    final pendingPickup = _dispatchData.where((d) => d['status'] == 'pending').length;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          DispatchHeader(onNewDispatch: _handleNewDispatch),
          AppSpacing.vXl,

          // Stats Grid
          DispatchStatsGrid(
            totalDispatched: totalDispatched,
            inTransit: inTransit,
            delivered: delivered,
            pendingPickup: pendingPickup,
          ),
          AppSpacing.vXl,

          // Data Table Card
          DispatchTableCard(
            items: filteredItems,
            searchQuery: _searchQuery,
            onSearchChanged: (val) => setState(() => _searchQuery = val.trim()),
            onView: _handleView,
            onTrack: _handleTrack,
            onMarkDelivered: _handleMarkDelivered,
            onDelete: _handleDelete,
          ),
        ],
      ),
    );
  }
}
