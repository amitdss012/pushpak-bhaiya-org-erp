import 'package:flutter/material.dart';

import '../models/nav_item_model.dart';

/// Complete data-driven menu configuration for the multi-branch SaaS platform.
class SidebarMenuConfig {
  SidebarMenuConfig._();

  static const List<NavItem> menuItems = [
    NavItem(
      title: 'Reception',
      icon: Icons.support_agent_rounded,
      subItems: [
        NavSubItem(
          title: 'Visit Enquiry',
          path: '/reception/enquiry',
          icon: Icons.contact_support_outlined,
        ),
        NavSubItem(
          title: 'Visitors Information',
          path: '/reception/visitors',
          icon: Icons.people_outline_rounded,
        ),
        NavSubItem(
          title: 'Item Dispatch',
          path: '/reception/dispatch',
          icon: Icons.outbox_rounded,
        ),
        NavSubItem(
          title: 'Item Receive',
          path: '/reception/receive',
          icon: Icons.move_to_inbox_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'Branch Management',
      icon: Icons.corporate_fare_rounded,
      badge: '8 Active',
      subItems: [
        NavSubItem(
          title: 'Create Branch',
          path: '/branch/create',
          icon: Icons.add_business_rounded,
        ),
        NavSubItem(
          title: 'View Branch',
          path: '/branch/view',
          icon: Icons.domain_rounded,
        ),
        NavSubItem(
          title: 'Wallet Recharge',
          path: '/branch/wallet',
          icon: Icons.account_balance_wallet_outlined,
        ),
        NavSubItem(
          title: 'Branch Transactions',
          path: '/branch/transactions',
          icon: Icons.receipt_long_rounded,
        ),
        NavSubItem(
          title: 'Notice Board',
          path: '/branch/notice-board',
          icon: Icons.campaign_outlined,
        ),
        NavSubItem(
          title: 'Website Settings',
          path: '/branch/website-settings',
          icon: Icons.language_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'Enquiry Management',
      icon: Icons.contact_mail_outlined,
      subItems: [
        NavSubItem(
          title: 'Branch Enquiry',
          path: '/enquiry/branch',
          icon: Icons.storefront_outlined,
        ),
        NavSubItem(
          title: 'Online Branch Enquiry',
          path: '/enquiry/online-branch',
          icon: Icons.public_rounded,
        ),
        NavSubItem(
          title: 'Online Student Enquiry',
          path: '/enquiry/online-student',
          icon: Icons.person_search_outlined,
        ),
      ],
    ),
    NavItem(
      title: 'Course Management',
      icon: Icons.menu_book_rounded,
      subItems: [
        NavSubItem(
          title: 'Create Course',
          path: '/course/create',
          icon: Icons.post_add_rounded,
        ),
        NavSubItem(
          title: 'View Course',
          path: '/course/view',
          icon: Icons.library_books_outlined,
        ),
        NavSubItem(
          title: 'Create Batch',
          path: '/course/batch/create',
          icon: Icons.group_add_outlined,
        ),
        NavSubItem(
          title: 'Batch Timing',
          path: '/course/batch/timing',
          icon: Icons.schedule_rounded,
        ),
        NavSubItem(
          title: 'Assign Course to Batch',
          path: '/course/batch/assign',
          icon: Icons.assignment_turned_in_outlined,
        ),
      ],
    ),
    NavItem(
      title: 'Student Management',
      icon: Icons.school_rounded,
      badge: '6.4k',
      subItems: [
        NavSubItem(
          title: 'Admission Form',
          path: '/student/admission-form',
          icon: Icons.how_to_reg_rounded,
        ),
        NavSubItem(
          title: 'View Students',
          path: '/student/view',
          icon: Icons.badge_outlined,
        ),
        NavSubItem(
          title: 'Online Admission List',
          path: '/student/online-admissions',
          icon: Icons.fact_check_outlined,
        ),
      ],
    ),
    NavItem(
      title: 'Fee Management',
      icon: Icons.payments_rounded,
      subItems: [
        NavSubItem(
          title: 'Fee Types',
          path: '/fee/types',
          icon: Icons.category_outlined,
        ),
        NavSubItem(
          title: 'Fee Groups',
          path: '/fee/groups',
          icon: Icons.folder_shared_outlined,
        ),
        NavSubItem(
          title: 'Fee Allocation',
          path: '/fee/allocation',
          icon: Icons.assignment_ind_outlined,
        ),
        NavSubItem(
          title: 'Fee Collection',
          path: '/fee/collection',
          icon: Icons.point_of_sale_rounded,
        ),
        NavSubItem(
          title: 'Due Fee Collection',
          path: '/fee/due-collection',
          icon: Icons.pending_actions_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'Exam & Marks',
      icon: Icons.assignment_rounded,
      subItems: [
        NavSubItem(
          title: 'Create Exam',
          path: '/exam/create',
          icon: Icons.note_add_outlined,
        ),
        NavSubItem(
          title: 'Exam Schedule',
          path: '/exam/schedule',
          icon: Icons.calendar_month_outlined,
        ),
        NavSubItem(
          title: 'Assign Marks',
          path: '/exam/assign-marks',
          icon: Icons.edit_note_rounded,
        ),
        NavSubItem(
          title: 'Marks List',
          path: '/exam/marks-list',
          icon: Icons.grading_rounded,
        ),
        NavSubItem(
          title: 'Grade Management',
          path: '/exam/grade-management',
          icon: Icons.auto_graph_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'Online Exam',
      icon: Icons.quiz_rounded,
      subItems: [
        NavSubItem(
          title: 'Create Exam',
          path: '/online-exam/create',
          icon: Icons.add_task_rounded,
        ),
        NavSubItem(
          title: 'Question Paper Builder',
          path: '/online-exam/question-paper-builder',
          icon: Icons.dynamic_form_outlined,
        ),
        NavSubItem(
          title: 'Add Questions',
          path: '/online-exam/add-questions',
          icon: Icons.help_outline_rounded,
        ),
        NavSubItem(
          title: 'Online Exam Marks',
          path: '/online-exam/marks',
          icon: Icons.analytics_outlined,
        ),
      ],
    ),
    NavItem(
      title: 'Live Class',
      icon: Icons.video_camera_front_rounded,
      subItems: [
        NavSubItem(
          title: 'View Live Classes',
          path: '/live-class/view',
          icon: Icons.live_tv_rounded,
        ),
        NavSubItem(
          title: 'Live Class Setup',
          path: '/live-class/setup',
          icon: Icons.settings_input_antenna_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'ID & Admit Card',
      icon: Icons.credit_card_rounded,
      subItems: [
        NavSubItem(
          title: 'ID Card Template',
          path: '/cards/id-template',
          icon: Icons.style_outlined,
        ),
        NavSubItem(
          title: 'Generate ID Cards',
          path: '/cards/generate-id',
          icon: Icons.contact_page_outlined,
        ),
        NavSubItem(
          title: 'Admit Card Template',
          path: '/cards/admit-template',
          icon: Icons.featured_play_list_outlined,
        ),
        NavSubItem(
          title: 'Generate Admit Cards',
          path: '/cards/generate-admit',
          icon: Icons.print_outlined,
        ),
      ],
    ),
    NavItem(
      title: 'Certificate & Marksheet',
      icon: Icons.workspace_premium_rounded,
      subItems: [
        NavSubItem(
          title: 'Certificate Template',
          path: '/certificate/template',
          icon: Icons.verified_outlined,
        ),
        NavSubItem(
          title: 'Generate Certificates',
          path: '/certificate/generate',
          icon: Icons.military_tech_outlined,
        ),
        NavSubItem(
          title: 'Marksheet Template',
          path: '/marksheet/template',
          icon: Icons.description_outlined,
        ),
        NavSubItem(
          title: 'Generate Marksheets',
          path: '/marksheet/generate',
          icon: Icons.print_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'System Settings',
      icon: Icons.tune_rounded,
      subItems: [
        NavSubItem(
          title: 'General Settings',
          path: '/settings/general',
          icon: Icons.settings_suggest_rounded,
        ),
        NavSubItem(
          title: 'Payment Gateway',
          path: '/settings/payment-gateway',
          icon: Icons.account_balance_rounded,
        ),
        NavSubItem(
          title: 'Payment QR Code',
          path: '/settings/payment-qr',
          icon: Icons.qr_code_2_rounded,
        ),
        NavSubItem(
          title: 'Batch Payment QR',
          path: '/settings/batch-qr',
          icon: Icons.qr_code_scanner_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'Partner Management',
      icon: Icons.handshake_rounded,
      subItems: [
        NavSubItem(
          title: 'Add Partner',
          path: '/partners/add',
          icon: Icons.person_add_alt_1_outlined,
        ),
        NavSubItem(
          title: 'All Partners',
          path: '/partners/all',
          icon: Icons.groups_outlined,
        ),
        NavSubItem(
          title: 'Partner Transactions',
          path: '/partners/transactions',
          icon: Icons.price_change_outlined,
        ),
      ],
    ),
    NavItem(
      title: 'Expense Management',
      icon: Icons.receipt_rounded,
      subItems: [
        NavSubItem(
          title: 'Voucher Head',
          path: '/expense/voucher-head',
          icon: Icons.bookmark_border_rounded,
        ),
        NavSubItem(
          title: 'All Voucher Heads',
          path: '/expense/voucher-heads',
          icon: Icons.collections_bookmark_outlined,
        ),
        NavSubItem(
          title: 'Deposit Voucher',
          path: '/expense/deposit-voucher',
          icon: Icons.account_balance_wallet_outlined,
        ),
        NavSubItem(
          title: 'Expense Voucher',
          path: '/expense/expense-voucher',
          icon: Icons.request_quote_outlined,
        ),
      ],
    ),
    NavItem(
      title: 'Attendance Management',
      icon: Icons.fact_check_rounded,
      subItems: [
        NavSubItem(
          title: 'Mark Attendance',
          path: '/attendance/mark',
          icon: Icons.check_box_outlined,
        ),
        NavSubItem(
          title: 'Attendance Report',
          path: '/attendance/report',
          icon: Icons.assessment_outlined,
        ),
        NavSubItem(
          title: 'Attendance Logs',
          path: '/attendance/logs',
          icon: Icons.history_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'User Management',
      icon: Icons.manage_accounts_rounded,
      subItems: [
        NavSubItem(
          title: 'All Users',
          path: '/user/all',
          icon: Icons.supervised_user_circle_outlined,
        ),
        NavSubItem(
          title: 'User Roles',
          path: '/user/roles',
          icon: Icons.admin_panel_settings_outlined,
        ),
        NavSubItem(
          title: 'Access Control',
          path: '/user/access-control',
          icon: Icons.security_rounded,
        ),
      ],
    ),
    NavItem(
      title: 'Session Year',
      icon: Icons.date_range_rounded,
      subItems: [
        NavSubItem(
          title: 'Add Session Year',
          path: '/session/add',
          icon: Icons.event_available_outlined,
        ),
        NavSubItem(
          title: 'All Session Years',
          path: '/session/all',
          icon: Icons.calendar_today_rounded,
        ),
      ],
    ),
  ];

  /// Look up category and sub-item by a given path.
  static ({NavItem parent, NavSubItem item})? findByPath(String path) {
    for (final parent in menuItems) {
      for (final item in parent.subItems) {
        if (item.path == path) {
          return (parent: parent, item: item);
        }
      }
    }
    return null;
  }
}
