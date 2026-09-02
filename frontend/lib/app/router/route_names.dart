/// Strongly typed route name and path constants for GoRouter.
class RouteNames {
  RouteNames._();

  // Root & Auth Routes
  static const String landing = 'landing';
  static const String landingPath = '/';

  static const String login = 'login';
  static const String loginPath = '/login';

  // Platform Panel Routes
  static const String platformLogin = 'platformLogin';
  static const String platformLoginPath = '/platform/login';

  static const String platformDashboard = 'platformDashboard';
  static const String platformDashboardPath = '/platform/dashboard';

  // Standalone Panel Routes
  static const String branchDashboard = 'branchDashboard';
  static const String branchDashboardPath = '/branch/dashboard';

  static const String studentDashboard = 'studentDashboard';
  static const String studentDashboardPath = '/student/dashboard';

  // Organization Dashboard
  static const String dashboard = 'dashboard';
  static const String dashboardPath = '/dashboard';

  // 1. Reception
  static const String visitEnquiry = 'visitEnquiry';
  static const String visitEnquiryPath = '/reception/enquiry';

  static const String receptionVisitors = 'receptionVisitors';
  static const String receptionVisitorsPath = '/reception/visitors';

  static const String receptionDispatch = 'receptionDispatch';
  static const String receptionDispatchPath = '/reception/dispatch';

  static const String receptionReceive = 'receptionReceive';
  static const String receptionReceivePath = '/reception/receive';

  // 2. Branch Management
  static const String branchCreate = 'branchCreate';
  static const String branchCreatePath = '/branch/create';

  static const String branchView = 'branchView';
  static const String branchViewPath = '/branch/view';

  static const String branchWallet = 'branchWallet';
  static const String branchWalletPath = '/branch/wallet';

  static const String branchTransactions = 'branchTransactions';
  static const String branchTransactionsPath = '/branch/transactions';

  static const String branchNoticeBoard = 'branchNoticeBoard';
  static const String branchNoticeBoardPath = '/branch/notice-board';

  static const String branchWebsiteSettings = 'branchWebsiteSettings';
  static const String branchWebsiteSettingsPath = '/branch/website-settings';

  // 3. Enquiry Management
  static const String enquiryBranch = 'enquiryBranch';
  static const String enquiryBranchPath = '/enquiry/branch';

  static const String enquiryOnlineBranch = 'enquiryOnlineBranch';
  static const String enquiryOnlineBranchPath = '/enquiry/online-branch';

  static const String enquiryOnlineStudent = 'enquiryOnlineStudent';
  static const String enquiryOnlineStudentPath = '/enquiry/online-student';

  // 4. Course Management
  static const String courseCreate = 'courseCreate';
  static const String courseCreatePath = '/course/create';

  static const String courseView = 'courseView';
  static const String courseViewPath = '/course/view';

  static const String courseBatchCreate = 'courseBatchCreate';
  static const String courseBatchCreatePath = '/course/batch/create';

  static const String courseBatchTiming = 'courseBatchTiming';
  static const String courseBatchTimingPath = '/course/batch/timing';

  static const String courseBatchAssign = 'courseBatchAssign';
  static const String courseBatchAssignPath = '/course/batch/assign';

  // 5. Student Management
  static const String studentAdmissionForm = 'studentAdmissionForm';
  static const String studentAdmissionFormPath = '/student/admission-form';

  static const String studentAdd = 'studentAdd';
  static const String studentAddPath = '/student/add';

  static const String studentView = 'studentView';
  static const String studentViewPath = '/student/view';

  static const String studentOnlineAdmissions = 'studentOnlineAdmissions';
  static const String studentOnlineAdmissionsPath = '/student/online-admissions';

  // 6. Fee Management
  static const String feeTypes = 'feeTypes';
  static const String feeTypesPath = '/fee/types';

  static const String feeGroups = 'feeGroups';
  static const String feeGroupsPath = '/fee/groups';

  static const String feeAllocation = 'feeAllocation';
  static const String feeAllocationPath = '/fee/allocation';

  static const String feeCollection = 'feeCollection';
  static const String feeCollectionPath = '/fee/collection';

  static const String feeDueCollection = 'feeDueCollection';
  static const String feeDueCollectionPath = '/fee/due-collection';

  // 7. Exam & Marks
  static const String examCreate = 'examCreate';
  static const String examCreatePath = '/exam/create';

  static const String examSchedule = 'examSchedule';
  static const String examSchedulePath = '/exam/schedule';

  static const String examAssignMarks = 'examAssignMarks';
  static const String examAssignMarksPath = '/exam/assign-marks';

  static const String examMarksList = 'examMarksList';
  static const String examMarksListPath = '/exam/marks-list';

  static const String examGradeManagement = 'examGradeManagement';
  static const String examGradeManagementPath = '/exam/grade-management';

  // 8. Online Exam
  static const String onlineExamCreate = 'onlineExamCreate';
  static const String onlineExamCreatePath = '/online-exam/create';

  static const String onlineExamQuestionPaperBuilder = 'onlineExamQuestionPaperBuilder';
  static const String onlineExamQuestionPaperBuilderPath = '/online-exam/question-paper-builder';

  static const String onlineExamAddQuestions = 'onlineExamAddQuestions';
  static const String onlineExamAddQuestionsPath = '/online-exam/add-questions';

  static const String onlineExamMarks = 'onlineExamMarks';
  static const String onlineExamMarksPath = '/online-exam/marks';

  // 9. Live Class
  static const String liveClassView = 'liveClassView';
  static const String liveClassViewPath = '/live-class/view';

  static const String liveClassSetup = 'liveClassSetup';
  static const String liveClassSetupPath = '/live-class/setup';

  // 10. ID & Admit Card
  static const String cardsIdTemplate = 'cardsIdTemplate';
  static const String cardsIdTemplatePath = '/cards/id-template';

  static const String cardsGenerateId = 'cardsGenerateId';
  static const String cardsGenerateIdPath = '/cards/generate-id';

  static const String cardsAdmitTemplate = 'cardsAdmitTemplate';
  static const String cardsAdmitTemplatePath = '/cards/admit-template';

  static const String cardsGenerateAdmit = 'cardsGenerateAdmit';
  static const String cardsGenerateAdmitPath = '/cards/generate-admit';

  // 11. Certificate & Marksheet
  static const String certificateTemplate = 'certificateTemplate';
  static const String certificateTemplatePath = '/certificate/template';

  static const String certificateGenerate = 'certificateGenerate';
  static const String certificateGeneratePath = '/certificate/generate';

  static const String marksheetTemplate = 'marksheetTemplate';
  static const String marksheetTemplatePath = '/marksheet/template';

  static const String marksheetGenerate = 'marksheetGenerate';
  static const String marksheetGeneratePath = '/marksheet/generate';

  // 12. System Settings
  static const String settingsGeneral = 'settingsGeneral';
  static const String settingsGeneralPath = '/settings/general';

  static const String settingsPaymentGateway = 'settingsPaymentGateway';
  static const String settingsPaymentGatewayPath = '/settings/payment-gateway';

  static const String settingsPaymentQr = 'settingsPaymentQr';
  static const String settingsPaymentQrPath = '/settings/payment-qr';

  static const String settingsBatchQr = 'settingsBatchQr';
  static const String settingsBatchQrPath = '/settings/batch-qr';

  // 13. Partner Management
  static const String partnersAdd = 'partnersAdd';
  static const String partnersAddPath = '/partners/add';

  static const String partnersAll = 'partnersAll';
  static const String partnersAllPath = '/partners/all';

  static const String partnersTransactions = 'partnersTransactions';
  static const String partnersTransactionsPath = '/partners/transactions';

  // 14. Expense Management
  static const String expenseVoucherHead = 'expenseVoucherHead';
  static const String expenseVoucherHeadPath = '/expense/voucher-head';

  static const String expenseVoucherHeads = 'expenseVoucherHeads';
  static const String expenseVoucherHeadsPath = '/expense/voucher-heads';

  static const String expenseDepositVoucher = 'expenseDepositVoucher';
  static const String expenseDepositVoucherPath = '/expense/deposit-voucher';

  static const String expenseExpenseVoucher = 'expenseExpenseVoucher';
  static const String expenseExpenseVoucherPath = '/expense/expense-voucher';

  // 15. Attendance Management
  static const String attendanceMark = 'attendanceMark';
  static const String attendanceMarkPath = '/attendance/mark';

  static const String attendanceReport = 'attendanceReport';
  static const String attendanceReportPath = '/attendance/report';

  static const String attendanceLogs = 'attendanceLogs';
  static const String attendanceLogsPath = '/attendance/logs';

  // 16. User Management
  static const String userAll = 'userAll';
  static const String userAllPath = '/user/all';

  static const String userRoles = 'userRoles';
  static const String userRolesPath = '/user/roles';

  static const String userAccessControl = 'userAccessControl';
  static const String userAccessControlPath = '/user/access-control';

  // 17. Session Year
  static const String sessionAdd = 'sessionAdd';
  static const String sessionAddPath = '/session/add';

  static const String sessionAll = 'sessionAll';
  static const String sessionAllPath = '/session/all';
}
