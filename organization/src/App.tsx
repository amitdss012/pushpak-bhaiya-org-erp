import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { ThemeProvider } from "next-themes";

// Pages
import Index from "./pages/Index";
import NotFound from "./pages/NotFound";

// Reception
import VisitEnquiry from "./pages/reception/VisitEnquiry";
import VisitorsInformation from "./pages/reception/VisitorsInformation";
import ItemDispatch from "./pages/reception/ItemDispatch";
import ItemReceive from "./pages/reception/ItemReceive";

// Branch Management
import CreateBranch from "./pages/branch/CreateBranch";
import ViewBranch from "./pages/branch/ViewBranch";
import WalletRecharge from "./pages/branch/WalletRecharge";
import BranchTransactions from "./pages/branch/BranchTransactions";
import BranchNoticeBoard from "./pages/branch/BranchNoticeBoard";
import BranchWebsiteSettings from "./pages/branch/BranchWebsiteSettings";

// Enquiry Management
import BranchEnquiry from "./pages/enquiry/BranchEnquiry";
import OnlineBranchEnquiry from "./pages/enquiry/OnlineBranchEnquiry";
import OnlineStudentEnquiry from "./pages/enquiry/OnlineStudentEnquiry";

// Student Management
import ViewStudents from "./pages/student/ViewStudents";
import AddStudent from "./pages/student/AddStudent";
import OnlineAdmissionList from "./pages/student/OnlineAdmissionList";
import StudentAdmissionForm from "./pages/student/StudentAdmissionForm";

// Fee Management
import FeeCollection from "./pages/fee/FeeCollection";
import FeeTypes from "./pages/fee/FeeTypes";
import FeeGroups from "./pages/fee/FeeGroups";
import FeeAllocation from "./pages/fee/FeeAllocation";
import DueFeeCollection from "./pages/fee/DueFeeCollection";

// Course Management
import ViewCourses from "./pages/course/ViewCourses";
import CreateCourse from "./pages/course/CreateCourse";
import CreateBatch from "./pages/course/CreateBatch";
import BatchTiming from "./pages/course/BatchTiming";
import AssignCourseToBatch from "./pages/course/AssignCourseToBatch";

// Exam Management
import ExamSchedule from "./pages/exam/ExamSchedule";
import CreateExam from "./pages/exam/CreateExam";
import AssignMarks from "./pages/exam/AssignMarks";
import MarksList from "./pages/exam/MarksList";
import GradeManagement from "./pages/exam/GradeManagement";

// Online Exam
import CreateOnlineExam from "./pages/online-exam/CreateOnlineExam";
import QuestionPaperBuilder from "./pages/online-exam/QuestionPaperBuilder";
import AddQuestions from "./pages/online-exam/AddQuestions";
import OnlineExamMarks from "./pages/online-exam/OnlineExamMarks";

// Live Class
import ViewLiveClasses from "./pages/live-class/ViewLiveClasses";
import LiveClassSetup from "./pages/live-class/LiveClassSetup";

// Cards
import IDCardTemplate from "./pages/cards/IDCardTemplate";
import GenerateIDCards from "./pages/cards/GenerateIDCards";
import AdmitCardTemplate from "./pages/cards/AdmitCardTemplate";
import GenerateAdmitCards from "./pages/cards/GenerateAdmitCards";

// Certificates
import CertificateTemplate from "./pages/certificate/CertificateTemplate";
import GenerateCertificates from "./pages/certificate/GenerateCertificates";

// Marksheets
import MarksheetTemplate from "./pages/marksheet/MarksheetTemplate";
import GenerateMarksheets from "./pages/marksheet/GenerateMarksheets";

// Settings
import GeneralSettings from "./pages/settings/GeneralSettings";
import PaymentGateway from "./pages/settings/PaymentGateway";
import PaymentQRCode from "./pages/settings/PaymentQRCode";
import BatchPaymentQR from "./pages/settings/BatchPaymentQR";

// Partner Management
import AddPartner from "./pages/partners/AddPartner";
import AllPartners from "./pages/partners/AllPartners";
import PartnerTransactions from "./pages/partners/PartnerTransactions";

// Expense Management
import VoucherHead from "./pages/expense/VoucherHead";
import VoucherHeads from "./pages/expense/VoucherHeads";
import DepositVoucher from "./pages/expense/DepositVoucher";
import ExpenseVoucher from "./pages/expense/ExpenseVoucher";

// Attendance Management
import Attendance from "./pages/attendance/Attendance";
import AttendanceReport from "./pages/attendance/AttendanceReport";
import AttendanceLogs from "./pages/attendance/AttendanceLogs";

// User Management
import AllUsers from "./pages/user/AllUsers";
import UserRoles from "./pages/user/UserRoles";
import AccessControl from "./pages/user/AccessControl";

// Session Year Management
import AddSessionYear from "./pages/session/AddSessionYear";
import AllSessionYears from "./pages/session/AllSessionYears";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <ThemeProvider attribute="class" defaultTheme="system" enableSystem storageKey="theme">
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <BrowserRouter>
          <Routes>
          {/* Dashboard */}
          <Route path="/" element={<Index />} />
          
          {/* Reception Management */}
          <Route path="/reception/enquiry" element={<VisitEnquiry />} />
          <Route path="/reception/visitors" element={<VisitorsInformation />} />
          <Route path="/reception/dispatch" element={<ItemDispatch />} />
          <Route path="/reception/receive" element={<ItemReceive />} />
          
          {/* Branch Management */}
          <Route path="/branch/create" element={<CreateBranch />} />
          <Route path="/branch/view" element={<ViewBranch />} />
          <Route path="/branch/wallet" element={<WalletRecharge />} />
          <Route path="/branch/transactions" element={<BranchTransactions />} />
          <Route path="/branch/notice-board" element={<BranchNoticeBoard />} />
          <Route path="/branch/website-settings" element={<BranchWebsiteSettings />} />
          
          {/* Enquiry Management */}
          <Route path="/enquiry/branch" element={<BranchEnquiry />} />
          <Route path="/enquiry/online-branch" element={<OnlineBranchEnquiry />} />
          <Route path="/enquiry/online-student" element={<OnlineStudentEnquiry />} />
          
          {/* Student Management */}
          <Route path="/student/view" element={<ViewStudents />} />
          <Route path="/student/add" element={<AddStudent />} />
          <Route path="/student/online-admissions" element={<OnlineAdmissionList />} />
          <Route path="/student/admission-form" element={<StudentAdmissionForm />} />
          
          {/* Fee Management */}
          <Route path="/fee/types" element={<FeeTypes />} />
          <Route path="/fee/groups" element={<FeeGroups />} />
          <Route path="/fee/allocation" element={<FeeAllocation />} />
          <Route path="/fee/collection" element={<FeeCollection />} />
          <Route path="/fee/due-collection" element={<DueFeeCollection />} />
          
          {/* Course Management */}
          <Route path="/course/create" element={<CreateCourse />} />
          <Route path="/course/view" element={<ViewCourses />} />
          <Route path="/course/batch/create" element={<CreateBatch />} />
          <Route path="/course/batch/timing" element={<BatchTiming />} />
          <Route path="/course/batch/assign" element={<AssignCourseToBatch />} />
          
          {/* Exam Management */}
          <Route path="/exam/create" element={<CreateExam />} />
          <Route path="/exam/schedule" element={<ExamSchedule />} />
          <Route path="/exam/assign-marks" element={<AssignMarks />} />
          <Route path="/exam/marks-list" element={<MarksList />} />
          <Route path="/exam/grade-management" element={<GradeManagement />} />
          
          {/* Online Exam */}
          <Route path="/online-exam/create" element={<CreateOnlineExam />} />
          <Route path="/online-exam/question-paper-builder" element={<QuestionPaperBuilder />} />
          <Route path="/online-exam/add-questions" element={<AddQuestions />} />
          <Route path="/online-exam/marks" element={<OnlineExamMarks />} />
          
          {/* Live Class */}
          <Route path="/live-class/view" element={<ViewLiveClasses />} />
          <Route path="/live-class/setup" element={<LiveClassSetup />} />
          
          {/* Cards */}
          <Route path="/cards/id-template" element={<IDCardTemplate />} />
          <Route path="/cards/generate-id" element={<GenerateIDCards />} />
          <Route path="/cards/admit-template" element={<AdmitCardTemplate />} />
          <Route path="/cards/generate-admit" element={<GenerateAdmitCards />} />
          
          {/* Certificates */}
          <Route path="/certificate/template" element={<CertificateTemplate />} />
          <Route path="/certificate/generate" element={<GenerateCertificates />} />
          
          {/* Marksheets */}
          <Route path="/marksheet/template" element={<MarksheetTemplate />} />
          <Route path="/marksheet/generate" element={<GenerateMarksheets />} />
          
          {/* Settings */}
          <Route path="/settings/general" element={<GeneralSettings />} />
          <Route path="/settings/payment-gateway" element={<PaymentGateway />} />
          <Route path="/settings/payment-qr" element={<PaymentQRCode />} />
          <Route path="/settings/batch-qr" element={<BatchPaymentQR />} />
          
          {/* Partner Management */}
          <Route path="/partners/add" element={<AddPartner />} />
          <Route path="/partners/all" element={<AllPartners />} />
          <Route path="/partners/transactions" element={<PartnerTransactions />} />
          
          {/* Expense Management */}
          <Route path="/expense/voucher-head" element={<VoucherHead />} />
          <Route path="/expense/voucher-heads" element={<VoucherHeads />} />
          <Route path="/expense/deposit-voucher" element={<DepositVoucher />} />
          <Route path="/expense/expense-voucher" element={<ExpenseVoucher />} />
          
          {/* Attendance Management */}
          <Route path="/attendance/mark" element={<Attendance />} />
          <Route path="/attendance/report" element={<AttendanceReport />} />
          <Route path="/attendance/logs" element={<AttendanceLogs />} />
          
          {/* User Management */}
          <Route path="/user/all" element={<AllUsers />} />
          <Route path="/user/roles" element={<UserRoles />} />
          <Route path="/user/access-control" element={<AccessControl />} />
          
          {/* Session Year Management */}
          <Route path="/session/add" element={<AddSessionYear />} />
          <Route path="/session/all" element={<AllSessionYears />} />
          
          {/* Catch-all */}
          <Route path="*" element={<NotFound />} />
          </Routes>
        </BrowserRouter>
      </TooltipProvider>
    </ThemeProvider>
  </QueryClientProvider>
);

export default App;
