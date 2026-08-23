import 'package:flutter/material.dart';

/// Available login portals in the SaaS authentication system.
enum LoginPortalType {
  organization(
    title: 'Organization',
    subtitle: 'Head Org Panel',
    icon: Icons.corporate_fare_rounded,
    emailHint: 'admin@organization.com',
    targetPath: '/dashboard',
  ),
  branch(
    title: 'Branch',
    subtitle: 'Branch Admin Panel',
    icon: Icons.domain_rounded,
    emailHint: 'manager@branch.com',
    targetPath: '/branch/dashboard',
  ),
  student(
    title: 'Student',
    subtitle: 'Student Portal',
    icon: Icons.school_rounded,
    emailHint: 'student@school.com',
    targetPath: '/student/dashboard',
  );

  final String title;
  final String subtitle;
  final IconData icon;
  final String emailHint;
  final String targetPath;

  const LoginPortalType({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.emailHint,
    required this.targetPath,
  });
}
