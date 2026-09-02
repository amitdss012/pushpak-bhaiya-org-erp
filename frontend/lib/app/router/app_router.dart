import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/branch/presentation/screens/branch_dashboard_screen.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/navigation/presentation/widgets/app_shell.dart';
import '../../features/organization/presentation/screens/attendance/attendance_logs/index.dart';
import '../../features/organization/presentation/screens/attendance/attendance_report/index.dart';
import '../../features/organization/presentation/screens/attendance/mark_attendance/index.dart';
import '../../features/organization/presentation/screens/branch_management/branch_transactions/index.dart';
import '../../features/organization/presentation/screens/branch_management/create_branch/index.dart';
import '../../features/organization/presentation/screens/branch_management/notice_board/index.dart';
import '../../features/organization/presentation/screens/branch_management/view_branch/index.dart';
import '../../features/organization/presentation/screens/branch_management/wallet_recharge/index.dart';
import '../../features/organization/presentation/screens/branch_management/website_settings/index.dart';
import '../../features/organization/presentation/screens/cards/admit_card_template/index.dart';
import '../../features/organization/presentation/screens/cards/generate_admit_cards/index.dart';
import '../../features/organization/presentation/screens/cards/generate_id_cards/index.dart';
import '../../features/organization/presentation/screens/cards/id_card_template/index.dart';
import '../../features/organization/presentation/screens/certificate/certificate_template/index.dart';
import '../../features/organization/presentation/screens/certificate/generate_certificates/index.dart';
import '../../features/organization/presentation/screens/course/assign_course_to_batch/index.dart';
import '../../features/organization/presentation/screens/course/batch_timing/index.dart';
import '../../features/organization/presentation/screens/course/create_batch/index.dart';
import '../../features/organization/presentation/screens/course/create_course/index.dart';
import '../../features/organization/presentation/screens/course/view_courses/index.dart';
import '../../features/organization/presentation/screens/dashboard_screen.dart';
import '../../features/organization/presentation/screens/enquiry/branch_enquiry/index.dart';
import '../../features/organization/presentation/screens/enquiry/online_branch_enquiry/index.dart';
import '../../features/organization/presentation/screens/enquiry/online_student_enquiry/index.dart';
import '../../features/organization/presentation/screens/exam/assign_marks/index.dart';
import '../../features/organization/presentation/screens/exam/create_exam/index.dart';
import '../../features/organization/presentation/screens/exam/exam_schedule/index.dart';
import '../../features/organization/presentation/screens/exam/grade_management/index.dart';
import '../../features/organization/presentation/screens/exam/marks_list/index.dart';
import '../../features/organization/presentation/screens/expense/deposit_voucher/index.dart';
import '../../features/organization/presentation/screens/expense/expense_voucher/index.dart';
import '../../features/organization/presentation/screens/expense/voucher_head/index.dart';
import '../../features/organization/presentation/screens/expense/voucher_heads/index.dart';
import '../../features/organization/presentation/screens/fee/due_fee_collection/index.dart';
import '../../features/organization/presentation/screens/fee/fee_allocation/index.dart';
import '../../features/organization/presentation/screens/fee/fee_collection/index.dart';
import '../../features/organization/presentation/screens/fee/fee_groups/index.dart';
import '../../features/organization/presentation/screens/fee/fee_types/index.dart';
import '../../features/organization/presentation/screens/live_class/live_class_setup/index.dart';
import '../../features/organization/presentation/screens/live_class/view_classes/index.dart';
import '../../features/organization/presentation/screens/online_exam/add_questions/index.dart';
import '../../features/organization/presentation/screens/online_exam/create_online_exam/index.dart';
import '../../features/organization/presentation/screens/online_exam/online_exam_marks/index.dart';
import '../../features/organization/presentation/screens/online_exam/question_paper_builder/index.dart';
import '../../features/organization/presentation/screens/partners/add_partner/index.dart';
import '../../features/organization/presentation/screens/partners/all_partners/index.dart';
import '../../features/organization/presentation/screens/partners/partner_transactions/index.dart';
import '../../features/organization/presentation/screens/placeholder/module_placeholder_screen.dart';
import '../../features/organization/presentation/screens/reception/item_dispatch/index.dart';
import '../../features/organization/presentation/screens/reception/item_receive/index.dart';
import '../../features/organization/presentation/screens/reception/visit_enquiry/index.dart';
import '../../features/organization/presentation/screens/reception/visitors_information/index.dart';
import '../../features/organization/presentation/screens/session/add_session_year/index.dart';
import '../../features/organization/presentation/screens/session/all_session_years/index.dart';
import '../../features/organization/presentation/screens/settings/batch_payment_qr/index.dart';
import '../../features/organization/presentation/screens/settings/general_settings/index.dart';
import '../../features/organization/presentation/screens/settings/payment_gateway/index.dart';
import '../../features/organization/presentation/screens/settings/payment_qr_code/index.dart';
import '../../features/organization/presentation/screens/student/add_student/index.dart';
import '../../features/organization/presentation/screens/student/admission_form/index.dart';
import '../../features/organization/presentation/screens/user/access_control/index.dart';
import '../../features/organization/presentation/screens/user/all_users/index.dart';
import '../../features/organization/presentation/screens/user/user_roles/index.dart';
import '../../features/organization/presentation/screens/student/online_admission_list/index.dart';
import '../../features/organization/presentation/screens/student/view_students/index.dart';
import '../../features/platform/presentation/screens/platform_dashboard_screen.dart';
import '../../features/platform/presentation/screens/platform_login_screen.dart';
import '../../features/student/presentation/screens/student_dashboard_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.dashboardPath,
    debugLogDiagnostics: true,
    routes: [
      // Landing & Public Routes
      GoRoute(
        path: RouteNames.landingPath,
        name: RouteNames.landing,
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Platform Owner Panel Routes
      GoRoute(
        path: RouteNames.platformLoginPath,
        name: RouteNames.platformLogin,
        builder: (context, state) => const PlatformLoginScreen(),
      ),
      GoRoute(
        path: '/platfrom/login',
        redirect: (context, state) => RouteNames.platformLoginPath,
      ),
      GoRoute(
        path: RouteNames.platformDashboardPath,
        name: RouteNames.platformDashboard,
        builder: (context, state) => const PlatformDashboardScreen(),
      ),
      GoRoute(
        path: '/platfrom/dashboard',
        redirect: (context, state) => RouteNames.platformDashboardPath,
      ),

      // Branch Panel Route (Standalone)
      GoRoute(
        path: RouteNames.branchDashboardPath,
        name: RouteNames.branchDashboard,
        builder: (context, state) => const BranchDashboardScreen(),
      ),

      // Student Portal Route (Standalone)
      GoRoute(
        path: RouteNames.studentDashboardPath,
        name: RouteNames.studentDashboard,
        builder: (context, state) => const StudentDashboardScreen(),
      ),

      // Organization Authenticated Shell Routes
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) =>
            AppShell(currentPath: state.matchedLocation, child: child),
        routes: [
          // Overview Dashboard
          GoRoute(
            path: RouteNames.dashboardPath,
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),

          // 1. Reception
          GoRoute(
            path: RouteNames.visitEnquiryPath,
            name: RouteNames.visitEnquiry,
            builder: (context, state) => const VisitEnquiryScreen(),
          ),
          GoRoute(
            path: RouteNames.receptionVisitorsPath,
            name: RouteNames.receptionVisitors,
            builder: (context, state) => const VisitorsInformationScreen(),
          ),
          GoRoute(
            path: RouteNames.receptionDispatchPath,
            name: RouteNames.receptionDispatch,
            builder: (context, state) => const ItemDispatchScreen(),
          ),
          GoRoute(
            path: RouteNames.receptionReceivePath,
            name: RouteNames.receptionReceive,
            builder: (context, state) => const ItemReceiveScreen(),
          ),

          // 2. Branch Management
          GoRoute(
            path: RouteNames.branchCreatePath,
            name: RouteNames.branchCreate,
            builder: (context, state) => const CreateBranchScreen(),
          ),
          GoRoute(
            path: RouteNames.branchViewPath,
            name: RouteNames.branchView,
            builder: (context, state) => const ViewBranchScreen(),
          ),
          GoRoute(
            path: RouteNames.branchWalletPath,
            name: RouteNames.branchWallet,
            builder: (context, state) => const WalletRechargeScreen(),
          ),
          GoRoute(
            path: RouteNames.branchTransactionsPath,
            name: RouteNames.branchTransactions,
            builder: (context, state) => const BranchTransactionsScreen(),
          ),
          GoRoute(
            path: RouteNames.branchNoticeBoardPath,
            name: RouteNames.branchNoticeBoard,
            builder: (context, state) => const BranchNoticeBoardScreen(),
          ),
          GoRoute(
            path: RouteNames.branchWebsiteSettingsPath,
            name: RouteNames.branchWebsiteSettings,
            builder: (context, state) => const BranchWebsiteSettingsScreen(),
          ),

          // 3. Enquiry Management
          GoRoute(
            path: RouteNames.enquiryBranchPath,
            name: RouteNames.enquiryBranch,
            builder: (context, state) => const BranchEnquiryScreen(),
          ),
          GoRoute(
            path: RouteNames.enquiryOnlineBranchPath,
            name: RouteNames.enquiryOnlineBranch,
            builder: (context, state) => const OnlineBranchEnquiryScreen(),
          ),
          GoRoute(
            path: RouteNames.enquiryOnlineStudentPath,
            name: RouteNames.enquiryOnlineStudent,
            builder: (context, state) => const OnlineStudentEnquiryScreen(),
          ),

          // 4. Course Management
          GoRoute(
            path: RouteNames.courseCreatePath,
            name: RouteNames.courseCreate,
            builder: (context, state) => const CreateCourseScreen(),
          ),
          GoRoute(
            path: RouteNames.courseViewPath,
            name: RouteNames.courseView,
            builder: (context, state) => const ViewCoursesScreen(),
          ),
          GoRoute(
            path: RouteNames.courseBatchCreatePath,
            name: RouteNames.courseBatchCreate,
            builder: (context, state) => const CreateBatchScreen(),
          ),
          GoRoute(
            path: RouteNames.courseBatchTimingPath,
            name: RouteNames.courseBatchTiming,
            builder: (context, state) => const BatchTimingScreen(),
          ),
          GoRoute(
            path: RouteNames.courseBatchAssignPath,
            name: RouteNames.courseBatchAssign,
            builder: (context, state) => const AssignCourseToBatchScreen(),
          ),

          // 5. Student Management
          GoRoute(
            path: RouteNames.studentAdmissionFormPath,
            name: RouteNames.studentAdmissionForm,
            builder: (context, state) => const StudentAdmissionFormScreen(),
          ),
          GoRoute(
            path: RouteNames.studentAddPath,
            name: RouteNames.studentAdd,
            builder: (context, state) => const AddStudentScreen(),
          ),
          GoRoute(
            path: RouteNames.studentViewPath,
            name: RouteNames.studentView,
            builder: (context, state) => const ViewStudentsScreen(),
          ),
          GoRoute(
            path: RouteNames.studentOnlineAdmissionsPath,
            name: RouteNames.studentOnlineAdmissions,
            builder: (context, state) => const OnlineAdmissionListScreen(),
          ),

          // 6. Fee Management
          GoRoute(
            path: RouteNames.feeTypesPath,
            name: RouteNames.feeTypes,
            builder: (context, state) => const FeeTypesScreen(),
          ),
          GoRoute(
            path: RouteNames.feeGroupsPath,
            name: RouteNames.feeGroups,
            builder: (context, state) => const FeeGroupsScreen(),
          ),
          GoRoute(
            path: RouteNames.feeAllocationPath,
            name: RouteNames.feeAllocation,
            builder: (context, state) => const FeeAllocationScreen(),
          ),
          GoRoute(
            path: RouteNames.feeCollectionPath,
            name: RouteNames.feeCollection,
            builder: (context, state) => const FeeCollectionScreen(),
          ),
          GoRoute(
            path: RouteNames.feeDueCollectionPath,
            name: RouteNames.feeDueCollection,
            builder: (context, state) => const DueFeeCollectionScreen(),
          ),

          // 7. Exam & Marks
          GoRoute(
            path: RouteNames.examCreatePath,
            name: RouteNames.examCreate,
            builder: (context, state) => const CreateExamScreen(),
          ),
          GoRoute(
            path: RouteNames.examSchedulePath,
            name: RouteNames.examSchedule,
            builder: (context, state) => const ExamScheduleScreen(),
          ),
          GoRoute(
            path: RouteNames.examAssignMarksPath,
            name: RouteNames.examAssignMarks,
            builder: (context, state) => const AssignMarksScreen(),
          ),
          GoRoute(
            path: RouteNames.examMarksListPath,
            name: RouteNames.examMarksList,
            builder: (context, state) => const MarksListScreen(),
          ),
          GoRoute(
            path: RouteNames.examGradeManagementPath,
            name: RouteNames.examGradeManagement,
            builder: (context, state) => const GradeManagementScreen(),
          ),

          // 8. Online Exam
          GoRoute(
            path: RouteNames.onlineExamCreatePath,
            name: RouteNames.onlineExamCreate,
            builder: (context, state) => const CreateOnlineExamScreen(),
          ),
          GoRoute(
            path: RouteNames.onlineExamQuestionPaperBuilderPath,
            name: RouteNames.onlineExamQuestionPaperBuilder,
            builder: (context, state) => const QuestionPaperBuilderScreen(),
          ),
          GoRoute(
            path: RouteNames.onlineExamAddQuestionsPath,
            name: RouteNames.onlineExamAddQuestions,
            builder: (context, state) => const AddQuestionsScreen(),
          ),
          GoRoute(
            path: RouteNames.onlineExamMarksPath,
            name: RouteNames.onlineExamMarks,
            builder: (context, state) => const OnlineExamMarksScreen(),
          ),

          // 9. Live Class
          GoRoute(
            path: RouteNames.liveClassViewPath,
            name: RouteNames.liveClassView,
            builder: (context, state) => const ViewLiveClassesScreen(),
          ),
          GoRoute(
            path: RouteNames.liveClassSetupPath,
            name: RouteNames.liveClassSetup,
            builder: (context, state) => const LiveClassSetupScreen(),
          ),

          // 10. ID & Admit Card
          GoRoute(
            path: RouteNames.cardsIdTemplatePath,
            name: RouteNames.cardsIdTemplate,
            builder: (context, state) => const IDCardTemplateScreen(),
          ),
          GoRoute(
            path: RouteNames.cardsGenerateIdPath,
            name: RouteNames.cardsGenerateId,
            builder: (context, state) => const GenerateIDCardsScreen(),
          ),
          GoRoute(
            path: RouteNames.cardsAdmitTemplatePath,
            name: RouteNames.cardsAdmitTemplate,
            builder: (context, state) => const AdmitCardTemplateScreen(),
          ),
          GoRoute(
            path: RouteNames.cardsGenerateAdmitPath,
            name: RouteNames.cardsGenerateAdmit,
            builder: (context, state) => const GenerateAdmitCardsScreen(),
          ),

          // 11. Certificate & Marksheet
          GoRoute(
            path: RouteNames.certificateTemplatePath,
            name: RouteNames.certificateTemplate,
            builder: (context, state) => const CertificateTemplateScreen(),
          ),
          GoRoute(
            path: RouteNames.certificateGeneratePath,
            name: RouteNames.certificateGenerate,
            builder: (context, state) => const GenerateCertificatesScreen(),
          ),
          GoRoute(
            path: RouteNames.marksheetTemplatePath,
            name: RouteNames.marksheetTemplate,
            builder: (context, state) => const ModulePlaceholderScreen(
              path: RouteNames.marksheetTemplatePath,
            ),
          ),
          GoRoute(
            path: RouteNames.marksheetGeneratePath,
            name: RouteNames.marksheetGenerate,
            builder: (context, state) => const ModulePlaceholderScreen(
              path: RouteNames.marksheetGeneratePath,
            ),
          ),

          // 12. System Settings
          GoRoute(
            path: RouteNames.settingsGeneralPath,
            name: RouteNames.settingsGeneral,
            builder: (context, state) => const GeneralSettingsScreen(),
          ),
          GoRoute(
            path: RouteNames.settingsPaymentGatewayPath,
            name: RouteNames.settingsPaymentGateway,
            builder: (context, state) => const PaymentGatewayScreen(),
          ),
          GoRoute(
            path: RouteNames.settingsPaymentQrPath,
            name: RouteNames.settingsPaymentQr,
            builder: (context, state) => const PaymentQRCodeScreen(),
          ),
          GoRoute(
            path: RouteNames.settingsBatchQrPath,
            name: RouteNames.settingsBatchQr,
            builder: (context, state) => const BatchPaymentQRScreen(),
          ),

          // 13. Partner Management
          GoRoute(
            path: RouteNames.partnersAddPath,
            name: RouteNames.partnersAdd,
            builder: (context, state) => const AddPartnerScreen(),
          ),
          GoRoute(
            path: RouteNames.partnersAllPath,
            name: RouteNames.partnersAll,
            builder: (context, state) => const AllPartnersScreen(),
          ),
          GoRoute(
            path: RouteNames.partnersTransactionsPath,
            name: RouteNames.partnersTransactions,
            builder: (context, state) => const PartnerTransactionsScreen(),
          ),

          // 14. Expense Management
          GoRoute(
            path: RouteNames.expenseVoucherHeadPath,
            name: RouteNames.expenseVoucherHead,
            builder: (context, state) => const VoucherHeadScreen(),
          ),
          GoRoute(
            path: RouteNames.expenseVoucherHeadsPath,
            name: RouteNames.expenseVoucherHeads,
            builder: (context, state) => const VoucherHeadsScreen(),
          ),
          GoRoute(
            path: RouteNames.expenseDepositVoucherPath,
            name: RouteNames.expenseDepositVoucher,
            builder: (context, state) => const DepositVoucherScreen(),
          ),
          GoRoute(
            path: RouteNames.expenseExpenseVoucherPath,
            name: RouteNames.expenseExpenseVoucher,
            builder: (context, state) => const ExpenseVoucherScreen(),
          ),

          // 15. Attendance Management
          GoRoute(
            path: RouteNames.attendanceMarkPath,
            name: RouteNames.attendanceMark,
            builder: (context, state) => const MarkAttendanceScreen(),
          ),
          GoRoute(
            path: RouteNames.attendanceReportPath,
            name: RouteNames.attendanceReport,
            builder: (context, state) => const AttendanceReportScreen(),
          ),
          GoRoute(
            path: RouteNames.attendanceLogsPath,
            name: RouteNames.attendanceLogs,
            builder: (context, state) => const AttendanceLogsScreen(),
          ),

          // 16. User Management
          GoRoute(
            path: RouteNames.userAllPath,
            name: RouteNames.userAll,
            builder: (context, state) => const AllUsersScreen(),
          ),
          GoRoute(
            path: RouteNames.userRolesPath,
            name: RouteNames.userRoles,
            builder: (context, state) => const UserRolesScreen(),
          ),
          GoRoute(
            path: RouteNames.userAccessControlPath,
            name: RouteNames.userAccessControl,
            builder: (context, state) => const AccessControlScreen(),
          ),

          // 17. Session Year
          GoRoute(
            path: RouteNames.sessionAddPath,
            name: RouteNames.sessionAdd,
            builder: (context, state) => const AddSessionYearScreen(),
          ),
          GoRoute(
            path: RouteNames.sessionAllPath,
            name: RouteNames.sessionAll,
            builder: (context, state) => const AllSessionYearsScreen(),
          ),
        ],
      ),
    ],
  );
}
