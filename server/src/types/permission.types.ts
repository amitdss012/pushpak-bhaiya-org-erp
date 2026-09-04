import type { Scope } from "./types.js";

/**
 * Complete catalog of atomic system permission keys in the application.
 * Format: [ACTION]_[RESOURCE/MODULE]
 */
export enum PermissionKey {
  /* ==========================================================================
     1. User Management (USER)
     ========================================================================== */
  CREATE_USER = "CREATE_USER",
  READ_USER = "READ_USER",
  UPDATE_USER = "UPDATE_USER",
  DELETE_USER = "DELETE_USER",
  INVITE_USER = "INVITE_USER",
  SUSPEND_USER = "SUSPEND_USER",

  /* ==========================================================================
     2. Role & RBAC Management (ROLE)
     ========================================================================== */
  CREATE_ROLE = "CREATE_ROLE",
  READ_ROLE = "READ_ROLE",
  UPDATE_ROLE = "UPDATE_ROLE",
  DELETE_ROLE = "DELETE_ROLE",
  ASSIGN_ROLE = "ASSIGN_ROLE",

  /* ==========================================================================
     3. Permission Catalog (PERMISSION)
     ========================================================================== */
  READ_PERMISSION = "READ_PERMISSION",
  ASSIGN_PERMISSION = "ASSIGN_PERMISSION",

  /* ==========================================================================
     4. Organization / Tenant (ORGANIZATION)
     ========================================================================== */
  READ_ORGANIZATION = "READ_ORGANIZATION",
  UPDATE_ORGANIZATION = "UPDATE_ORGANIZATION",
  MANAGE_ORGANIZATION_SETTINGS = "MANAGE_ORGANIZATION_SETTINGS",
  VIEW_ORGANIZATION_ANALYTICS = "VIEW_ORGANIZATION_ANALYTICS",

  /* ==========================================================================
     5. Branch Sub-units (BRANCH)
     ========================================================================== */
  CREATE_BRANCH = "CREATE_BRANCH",
  READ_BRANCH = "READ_BRANCH",
  UPDATE_BRANCH = "UPDATE_BRANCH",
  DELETE_BRANCH = "DELETE_BRANCH",
  SWITCH_BRANCH = "SWITCH_BRANCH",

  /* ==========================================================================
     6. Students & Admissions (STUDENT)
     ========================================================================== */
  CREATE_STUDENT = "CREATE_STUDENT",
  READ_STUDENT = "READ_STUDENT",
  UPDATE_STUDENT = "UPDATE_STUDENT",
  DELETE_STUDENT = "DELETE_STUDENT",
  APPROVE_STUDENT_ADMISSION = "APPROVE_STUDENT_ADMISSION",
  REJECT_STUDENT_ADMISSION = "REJECT_STUDENT_ADMISSION",
  EXPORT_STUDENT = "EXPORT_STUDENT",

  /* ==========================================================================
     7. Teachers & Faculty (TEACHER)
     ========================================================================== */
  CREATE_TEACHER = "CREATE_TEACHER",
  READ_TEACHER = "READ_TEACHER",
  UPDATE_TEACHER = "UPDATE_TEACHER",
  DELETE_TEACHER = "DELETE_TEACHER",
  ASSIGN_TEACHER_SUBJECT = "ASSIGN_TEACHER_SUBJECT",
  EXPORT_TEACHER = "EXPORT_TEACHER",

  /* ==========================================================================
     8. Parents & Guardians (PARENT)
     ========================================================================== */
  CREATE_PARENT = "CREATE_PARENT",
  READ_PARENT = "READ_PARENT",
  UPDATE_PARENT = "UPDATE_PARENT",
  DELETE_PARENT = "DELETE_PARENT",
  LINK_PARENT_STUDENT = "LINK_PARENT_STUDENT",
  UNLINK_PARENT_STUDENT = "UNLINK_PARENT_STUDENT",

  /* ==========================================================================
     9. Device Sessions & Security (SESSION)
     ========================================================================== */
  READ_SESSION = "READ_SESSION",
  REVOKE_SESSION = "REVOKE_SESSION",

  /* ==========================================================================
     10. Security Audit Trail (AUDIT_LOG)
     ========================================================================== */
  READ_AUDIT_LOG = "READ_AUDIT_LOG",
  EXPORT_AUDIT_LOG = "EXPORT_AUDIT_LOG",

  /* ==========================================================================
     11. Subscription & Billing (SUBSCRIPTION)
     ========================================================================== */
  READ_SUBSCRIPTION = "READ_SUBSCRIPTION",
  UPGRADE_SUBSCRIPTION = "UPGRADE_SUBSCRIPTION",
  CANCEL_SUBSCRIPTION = "CANCEL_SUBSCRIPTION",

  /* ==========================================================================
     12. Dashboards (DASHBOARD)
     ========================================================================== */
  VIEW_ORG_DASHBOARD = "VIEW_ORG_DASHBOARD",
  VIEW_BRANCH_DASHBOARD = "VIEW_BRANCH_DASHBOARD",

  /* ==========================================================================
     13. Academic & Curriculum (ACADEMIC)
     ========================================================================== */
  MANAGE_ACADEMIC_YEAR = "MANAGE_ACADEMIC_YEAR",
  MANAGE_CLASSES = "MANAGE_CLASSES",
  MANAGE_SUBJECTS = "MANAGE_SUBJECTS",
  MANAGE_TIMETABLE = "MANAGE_TIMETABLE",

  /* ==========================================================================
     14. Attendance (ATTENDANCE)
     ========================================================================== */
  MARK_ATTENDANCE = "MARK_ATTENDANCE",
  READ_ATTENDANCE = "READ_ATTENDANCE",
  UPDATE_ATTENDANCE = "UPDATE_ATTENDANCE",

  /* ==========================================================================
     15. Fee & Finance (FEE)
     ========================================================================== */
  MANAGE_FEE_STRUCTURE = "MANAGE_FEE_STRUCTURE",
  COLLECT_FEE = "COLLECT_FEE",
  READ_FEE = "READ_FEE",
  GENERATE_FEE_RECEIPT = "GENERATE_FEE_RECEIPT",

  /* ==========================================================================
     16. Examinations & Assessments (EXAMINATION)
     ========================================================================== */
  CREATE_EXAM = "CREATE_EXAM",
  RECORD_MARKS = "RECORD_MARKS",
  READ_EXAM_RESULTS = "READ_EXAM_RESULTS",
  PUBLISH_REPORT_CARD = "PUBLISH_REPORT_CARD",

  /* ==========================================================================
     17. Circulars & Communication (COMMUNICATION)
     ========================================================================== */
  CREATE_NOTICE = "CREATE_NOTICE",
  READ_NOTICE = "READ_NOTICE",
  DELETE_NOTICE = "DELETE_NOTICE",
  SEND_SMS_NOTIFICATION = "SEND_SMS_NOTIFICATION",
}

/**
 * Metadata definition for seeding and validating system permissions.
 */
export interface PermissionDefinition {
  key: PermissionKey;
  name: string;
  description: string;
  module: string;
  action: string;
  allowedScopes: Scope[];
}

/**
 * Master catalog of all system-defined atomic permissions with descriptions and scopes.
 */
export const ALL_SYSTEM_PERMISSIONS: PermissionDefinition[] = [
  /* ---------------- User Management (USER) ---------------- */
  {
    key: PermissionKey.CREATE_USER,
    name: "Create User",
    description: "Create new user accounts inside organization or branch",
    module: "USER",
    action: "CREATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.READ_USER,
    name: "View Users",
    description: "View user lists and detailed user profiles",
    module: "USER",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.UPDATE_USER,
    name: "Update User",
    description: "Edit user profile details and status",
    module: "USER",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.DELETE_USER,
    name: "Delete User",
    description: "Deactivate or soft-delete user accounts",
    module: "USER",
    action: "DELETE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.INVITE_USER,
    name: "Invite User",
    description: "Send invitation emails to join organization or branch",
    module: "USER",
    action: "CREATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.SUSPEND_USER,
    name: "Suspend User",
    description: "Temporarily block or suspend active user access",
    module: "USER",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },

  /* ---------------- Role & RBAC (ROLE) ---------------- */
  {
    key: PermissionKey.CREATE_ROLE,
    name: "Create Role",
    description: "Create custom roles with permission sets",
    module: "ROLE",
    action: "CREATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.READ_ROLE,
    name: "View Roles",
    description: "View roles and assigned permission maps",
    module: "ROLE",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.UPDATE_ROLE,
    name: "Update Role",
    description: "Modify role names, descriptions, and permission bindings",
    module: "ROLE",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.DELETE_ROLE,
    name: "Delete Role",
    description: "Remove custom non-system roles",
    module: "ROLE",
    action: "DELETE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.ASSIGN_ROLE,
    name: "Assign Role",
    description: "Assign or revoke roles to users",
    module: "ROLE",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },

  /* ---------------- Permission Catalog (PERMISSION) ---------------- */
  {
    key: PermissionKey.READ_PERMISSION,
    name: "View Permissions",
    description: "Inspect the master catalog of atomic system permissions",
    module: "PERMISSION",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.ASSIGN_PERMISSION,
    name: "Assign Permissions to Role",
    description: "Attach or detach system permissions to specific roles",
    module: "PERMISSION",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },

  /* ---------------- Organization (ORGANIZATION) ---------------- */
  {
    key: PermissionKey.READ_ORGANIZATION,
    name: "View Organization Details",
    description: "View tenant profile, address, and branding",
    module: "ORGANIZATION",
    action: "READ",
    allowedScopes: ["ORGANIZATION"],
  },
  {
    key: PermissionKey.UPDATE_ORGANIZATION,
    name: "Update Organization Profile",
    description: "Edit organization branding, logo, name, and address",
    module: "ORGANIZATION",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION"],
  },
  {
    key: PermissionKey.MANAGE_ORGANIZATION_SETTINGS,
    name: "Manage Organization Settings",
    description: "Configure tenant-wide policies, security, and defaults",
    module: "ORGANIZATION",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION"],
  },
  {
    key: PermissionKey.VIEW_ORGANIZATION_ANALYTICS,
    name: "View Organization Analytics",
    description: "View consolidated multi-branch business and growth metrics",
    module: "ORGANIZATION",
    action: "READ",
    allowedScopes: ["ORGANIZATION"],
  },

  /* ---------------- Branch (BRANCH) ---------------- */
  {
    key: PermissionKey.CREATE_BRANCH,
    name: "Create Branch",
    description: "Provision new branches under the organization",
    module: "BRANCH",
    action: "CREATE",
    allowedScopes: ["ORGANIZATION"],
  },
  {
    key: PermissionKey.READ_BRANCH,
    name: "View Branches",
    description: "View branch profiles, addresses, and contacts",
    module: "BRANCH",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.UPDATE_BRANCH,
    name: "Update Branch",
    description: "Edit branch details, status, and contact info",
    module: "BRANCH",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.DELETE_BRANCH,
    name: "Delete Branch",
    description: "Deactivate or soft-delete branch records",
    module: "BRANCH",
    action: "DELETE",
    allowedScopes: ["ORGANIZATION"],
  },
  {
    key: PermissionKey.SWITCH_BRANCH,
    name: "Switch Branch Context",
    description: "Navigate between branches for multi-branch staff",
    module: "BRANCH",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },

  /* ---------------- Student Management (STUDENT) ---------------- */
  {
    key: PermissionKey.CREATE_STUDENT,
    name: "Create Student Admission",
    description: "Submit new student admission and enrollment record",
    module: "STUDENT",
    action: "CREATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.READ_STUDENT,
    name: "View Students",
    description: "Search and view student profiles, documents, and academic history",
    module: "STUDENT",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.UPDATE_STUDENT,
    name: "Update Student",
    description: "Modify student personal, academic, address, and family info",
    module: "STUDENT",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.DELETE_STUDENT,
    name: "Delete Student",
    description: "Soft delete or mark student as withdrawn",
    module: "STUDENT",
    action: "DELETE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.APPROVE_STUDENT_ADMISSION,
    name: "Approve Student Admission",
    description: "Approve submitted student applications and assign enrollment numbers",
    module: "STUDENT",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.REJECT_STUDENT_ADMISSION,
    name: "Reject Student Admission",
    description: "Reject submitted student admission applications",
    module: "STUDENT",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.EXPORT_STUDENT,
    name: "Export Students Data",
    description: "Export student directories and academic data to Excel / CSV",
    module: "STUDENT",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },

  /* ---------------- Teacher Management (TEACHER) ---------------- */
  {
    key: PermissionKey.CREATE_TEACHER,
    name: "Create Teacher",
    description: "Add new faculty member or instructional staff",
    module: "TEACHER",
    action: "CREATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.READ_TEACHER,
    name: "View Teachers",
    description: "View teacher directory, qualifications, and staff profiles",
    module: "TEACHER",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.UPDATE_TEACHER,
    name: "Update Teacher",
    description: "Edit teacher profile, designation, department, and bio",
    module: "TEACHER",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.DELETE_TEACHER,
    name: "Delete Teacher",
    description: "Deactivate or terminate teacher staff profile",
    module: "TEACHER",
    action: "DELETE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.ASSIGN_TEACHER_SUBJECT,
    name: "Assign Teacher Subjects & Classes",
    description: "Map teachers to classes, sections, and subjects",
    module: "TEACHER",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.EXPORT_TEACHER,
    name: "Export Teachers Data",
    description: "Export teacher lists and qualifications to CSV",
    module: "TEACHER",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },

  /* ---------------- Parent Management (PARENT) ---------------- */
  {
    key: PermissionKey.CREATE_PARENT,
    name: "Create Parent Record",
    description: "Register parent or legal guardian in branch",
    module: "PARENT",
    action: "CREATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.READ_PARENT,
    name: "View Parents",
    description: "View parent directory and emergency contact numbers",
    module: "PARENT",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.UPDATE_PARENT,
    name: "Update Parent",
    description: "Modify parent occupation, address, and phone numbers",
    module: "PARENT",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.DELETE_PARENT,
    name: "Delete Parent",
    description: "Soft delete or remove parent record",
    module: "PARENT",
    action: "DELETE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.LINK_PARENT_STUDENT,
    name: "Link Parent to Student",
    description: "Establish StudentParentRelation mapping with relationship details",
    module: "PARENT",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.UNLINK_PARENT_STUDENT,
    name: "Unlink Parent from Student",
    description: "Remove mapping between student and parent",
    module: "PARENT",
    action: "DELETE",
    allowedScopes: ["BRANCH"],
  },

  /* ---------------- Device Sessions (SESSION) ---------------- */
  {
    key: PermissionKey.READ_SESSION,
    name: "View Device Sessions",
    description: "Inspect active logged-in device sessions across the branch/org",
    module: "SESSION",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.REVOKE_SESSION,
    name: "Revoke Remote Device Session",
    description: "Force logout specific devices or users remotely",
    module: "SESSION",
    action: "DELETE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },

  /* ---------------- Security Audit Logs (AUDIT_LOG) ---------------- */
  {
    key: PermissionKey.READ_AUDIT_LOG,
    name: "View Audit Logs",
    description: "Inspect chronological security, authentication, and update events",
    module: "AUDIT_LOG",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.EXPORT_AUDIT_LOG,
    name: "Export Audit Logs",
    description: "Export audit trails for regulatory and compliance audits",
    module: "AUDIT_LOG",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },

  /* ---------------- Subscription (SUBSCRIPTION) ---------------- */
  {
    key: PermissionKey.READ_SUBSCRIPTION,
    name: "View Subscription Details",
    description: "View current subscription plan, feature quotas, and billing cycle",
    module: "SUBSCRIPTION",
    action: "READ",
    allowedScopes: ["ORGANIZATION"],
  },
  {
    key: PermissionKey.UPGRADE_SUBSCRIPTION,
    name: "Upgrade Subscription Plan",
    description: "Upgrade plan, renew cycle, or change branch capacity limits",
    module: "SUBSCRIPTION",
    action: "UPDATE",
    allowedScopes: ["ORGANIZATION"],
  },
  {
    key: PermissionKey.CANCEL_SUBSCRIPTION,
    name: "Cancel Subscription",
    description: "Request cancellation of active subscription plan",
    module: "SUBSCRIPTION",
    action: "DELETE",
    allowedScopes: ["ORGANIZATION"],
  },

  /* ---------------- Dashboard (DASHBOARD) ---------------- */
  {
    key: PermissionKey.VIEW_ORG_DASHBOARD,
    name: "View Organization Dashboard",
    description: "Access executive organization analytics and branch roll-ups",
    module: "DASHBOARD",
    action: "READ",
    allowedScopes: ["ORGANIZATION"],
  },
  {
    key: PermissionKey.VIEW_BRANCH_DASHBOARD,
    name: "View Branch Dashboard",
    description: "Access branch operations, attendance, admissions, and fee dashboards",
    module: "DASHBOARD",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },

  /* ---------------- Academic & Curriculum (ACADEMIC) ---------------- */
  {
    key: PermissionKey.MANAGE_ACADEMIC_YEAR,
    name: "Manage Academic Year",
    description: "Configure active school sessions and academic calendars",
    module: "ACADEMIC",
    action: "MANAGE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.MANAGE_CLASSES,
    name: "Manage Classes & Sections",
    description: "Define class grades, classrooms, and student section allocations",
    module: "ACADEMIC",
    action: "MANAGE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.MANAGE_SUBJECTS,
    name: "Manage Subjects",
    description: "Configure school courses, subject codes, and curriculum",
    module: "ACADEMIC",
    action: "MANAGE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.MANAGE_TIMETABLE,
    name: "Manage Timetable",
    description: "Build class period schedules and teacher period rosters",
    module: "ACADEMIC",
    action: "MANAGE",
    allowedScopes: ["BRANCH"],
  },

  /* ---------------- Attendance (ATTENDANCE) ---------------- */
  {
    key: PermissionKey.MARK_ATTENDANCE,
    name: "Mark Attendance",
    description: "Record daily attendance roll-call for students and faculty",
    module: "ATTENDANCE",
    action: "CREATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.READ_ATTENDANCE,
    name: "View Attendance Records",
    description: "View daily, weekly, and monthly student/staff attendance sheets",
    module: "ATTENDANCE",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.UPDATE_ATTENDANCE,
    name: "Update Attendance",
    description: "Correct historical attendance records and approve leave requests",
    module: "ATTENDANCE",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },

  /* ---------------- Fees & Billing (FEE) ---------------- */
  {
    key: PermissionKey.MANAGE_FEE_STRUCTURE,
    name: "Manage Fee Structure",
    description: "Configure fee heads, tuition schedules, and discount categories",
    module: "FEE",
    action: "MANAGE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.COLLECT_FEE,
    name: "Collect Fee",
    description: "Accept and record fee installments (cash, cheque, UPI, online)",
    module: "FEE",
    action: "CREATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.READ_FEE,
    name: "View Fee Ledger",
    description: "Inspect student fee dues, overdue balances, and transaction history",
    module: "FEE",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.GENERATE_FEE_RECEIPT,
    name: "Generate Fee Receipts",
    description: "Print and issue signed fee payment vouchers and receipts",
    module: "FEE",
    action: "CREATE",
    allowedScopes: ["BRANCH"],
  },

  /* ---------------- Examination (EXAMINATION) ---------------- */
  {
    key: PermissionKey.CREATE_EXAM,
    name: "Create Examination Schedule",
    description: "Schedule unit tests, midterms, and annual exams",
    module: "EXAMINATION",
    action: "CREATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.RECORD_MARKS,
    name: "Record Marks & Grades",
    description: "Enter subject-wise student marks and scholastic evaluations",
    module: "EXAMINATION",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.READ_EXAM_RESULTS,
    name: "View Examination Results",
    description: "Review class performance analytics and student grade sheets",
    module: "EXAMINATION",
    action: "READ",
    allowedScopes: ["BRANCH"],
  },
  {
    key: PermissionKey.PUBLISH_REPORT_CARD,
    name: "Publish Report Cards",
    description: "Generate and publish final student progress reports and grade cards",
    module: "EXAMINATION",
    action: "UPDATE",
    allowedScopes: ["BRANCH"],
  },

  /* ---------------- Communication (COMMUNICATION) ---------------- */
  {
    key: PermissionKey.CREATE_NOTICE,
    name: "Create Notice / Circular",
    description: "Publish notices for students, teachers, or parents",
    module: "COMMUNICATION",
    action: "CREATE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.READ_NOTICE,
    name: "View Notices",
    description: "Read notice board circulars and announcements",
    module: "COMMUNICATION",
    action: "READ",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.DELETE_NOTICE,
    name: "Delete Notice",
    description: "Remove expired or retracted circulars",
    module: "COMMUNICATION",
    action: "DELETE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
  {
    key: PermissionKey.SEND_SMS_NOTIFICATION,
    name: "Send SMS & Push Broadcasts",
    description: "Broadcast urgent alerts, emergency notices, and SMS reminders",
    module: "COMMUNICATION",
    action: "EXECUTE",
    allowedScopes: ["ORGANIZATION", "BRANCH"],
  },
];
