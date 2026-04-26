import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatsCard } from "@/components/ui/StatsCard";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { GraduationCap, Clock, CheckCircle, XCircle, Download, Eye } from "lucide-react";

interface OnlineAdmission {
  id: string;
  applicationNo: string;
  date: string;
  name: string;
  email: string;
  phone: string;
  course: string;
  batch: string;
  documents: string[];
  paymentStatus: "paid" | "pending" | "failed";
  status: "pending" | "approved" | "rejected" | "under_review";
}

const admissionsData: OnlineAdmission[] = [
  { id: "1", applicationNo: "APP2024001", date: "2024-01-15", name: "Rahul Verma", email: "rahul@example.com", phone: "+91 98765 43210", course: "Computer Science", batch: "CS-2024-A", documents: ["Photo", "10th Marksheet", "12th Marksheet", "Aadhar"], paymentStatus: "paid", status: "pending" },
  { id: "2", applicationNo: "APP2024002", date: "2024-01-14", name: "Priya Singh", email: "priya@example.com", phone: "+91 87654 32109", course: "Commerce", batch: "COM-2024-A", documents: ["Photo", "10th Marksheet", "12th Marksheet"], paymentStatus: "paid", status: "under_review" },
  { id: "3", applicationNo: "APP2024003", date: "2024-01-14", name: "Amit Kumar", email: "amit@example.com", phone: "+91 76543 21098", course: "Engineering", batch: "ENG-2024-A", documents: ["Photo", "10th Marksheet", "12th Marksheet", "Aadhar", "Transfer Certificate"], paymentStatus: "paid", status: "approved" },
  { id: "4", applicationNo: "APP2024004", date: "2024-01-13", name: "Sneha Gupta", email: "sneha@example.com", phone: "+91 65432 10987", course: "Science", batch: "SCI-2024-A", documents: ["Photo", "10th Marksheet"], paymentStatus: "pending", status: "pending" },
  { id: "5", applicationNo: "APP2024005", date: "2024-01-12", name: "Vikram Rao", email: "vikram@example.com", phone: "+91 54321 09876", course: "Arts", batch: "ART-2024-A", documents: ["Photo", "10th Marksheet", "12th Marksheet", "Aadhar"], paymentStatus: "failed", status: "rejected" },
];

const columns: Column<OnlineAdmission>[] = [
  {
    key: "applicationNo",
    header: "Application",
    sortable: true,
    cell: (admission) => (
      <div>
        <p className="font-medium">{admission.applicationNo}</p>
        <p className="text-xs text-muted-foreground">{admission.date}</p>
      </div>
    ),
  },
  {
    key: "name",
    header: "Applicant",
    cell: (admission) => (
      <div>
        <p className="font-medium">{admission.name}</p>
        <p className="text-xs text-muted-foreground">{admission.email}</p>
      </div>
    ),
  },
  {
    key: "course",
    header: "Course",
    cell: (admission) => (
      <div>
        <Badge variant="outline">{admission.course}</Badge>
        <p className="text-xs text-muted-foreground mt-1">{admission.batch}</p>
      </div>
    ),
  },
  {
    key: "documents",
    header: "Documents",
    cell: (admission) => (
      <div className="flex items-center gap-1">
        <Badge variant="secondary">{admission.documents.length} uploaded</Badge>
      </div>
    ),
  },
  {
    key: "paymentStatus",
    header: "Payment",
    cell: (admission) => (
      <Badge variant={admission.paymentStatus === "paid" ? "default" : admission.paymentStatus === "pending" ? "secondary" : "destructive"}>
        {admission.paymentStatus}
      </Badge>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (admission) => <StatusBadge status={admission.status} />,
  },
];

export default function OnlineAdmissionList() {
  const handleActions = (admission: OnlineAdmission) => [
    { label: "View Application", onClick: () => console.log("View", admission.id) },
    { label: "Approve", onClick: () => console.log("Approve", admission.id) },
    { label: "Request Documents", onClick: () => console.log("Request", admission.id) },
    { label: "Reject", onClick: () => console.log("Reject", admission.id), destructive: true },
  ];

  const statusCounts = {
    pending: admissionsData.filter(a => a.status === "pending").length,
    under_review: admissionsData.filter(a => a.status === "under_review").length,
    approved: admissionsData.filter(a => a.status === "approved").length,
    rejected: admissionsData.filter(a => a.status === "rejected").length,
  };

  return (
    <AppLayout>
      <PageHeader
        title="Online Admission List"
        description="Manage online admission applications"
        breadcrumbs={[
          { label: "Student Management", href: "/student/view" },
          { label: "Online Admission List" },
        ]}
        actions={
          <Button variant="outline" className="gap-2">
            <Download className="h-4 w-4" />
            Export Data
          </Button>
        }
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <StatsCard
          title="Total Applications"
          value={admissionsData.length}
          subtitle="This session"
          icon={GraduationCap}
          trend={{ value: 12, isPositive: true }}
        />
        <StatsCard
          title="Pending Review"
          value={statusCounts.pending + statusCounts.under_review}
          subtitle="Needs attention"
          icon={Clock}
        />
        <StatsCard
          title="Approved"
          value={statusCounts.approved}
          subtitle="Ready for enrollment"
          icon={CheckCircle}
          trend={{ value: 8, isPositive: true }}
        />
        <StatsCard
          title="Rejected"
          value={statusCounts.rejected}
          subtitle="This session"
          icon={XCircle}
        />
      </div>

      <DataTable
        data={admissionsData}
        columns={columns}
        searchPlaceholder="Search applications..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
