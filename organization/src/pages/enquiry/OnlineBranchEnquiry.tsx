import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatsCard } from "@/components/ui/StatsCard";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Globe, Building2, Clock, CheckCircle, Download, Eye } from "lucide-react";

interface OnlineEnquiry {
  id: string;
  date: string;
  branch: string;
  name: string;
  phone: string;
  email: string;
  enquiryType: string;
  message: string;
  ipAddress: string;
  status: "pending" | "reviewed" | "responded" | "closed";
}

const enquiriesData: OnlineEnquiry[] = [
  { id: "1", date: "2024-01-15 10:30 AM", branch: "Main Campus", name: "Ravi Kumar", phone: "+91 98765 43210", email: "ravi@example.com", enquiryType: "Admission", message: "Interested in admission for B.Tech program", ipAddress: "192.168.1.100", status: "pending" },
  { id: "2", date: "2024-01-15 09:15 AM", branch: "North Campus", name: "Anita Sharma", phone: "+91 87654 32109", email: "anita@example.com", enquiryType: "Fee Structure", message: "Please share the fee structure for MBA", ipAddress: "192.168.1.101", status: "reviewed" },
  { id: "3", date: "2024-01-14 04:45 PM", branch: "Main Campus", name: "Deepak Verma", phone: "+91 76543 21098", email: "deepak@example.com", enquiryType: "Course Details", message: "Looking for information about BCA course", ipAddress: "192.168.1.102", status: "responded" },
  { id: "4", date: "2024-01-14 02:30 PM", branch: "South Campus", name: "Meera Joshi", phone: "+91 65432 10987", email: "meera@example.com", enquiryType: "Scholarship", message: "What scholarships are available?", ipAddress: "192.168.1.103", status: "pending" },
  { id: "5", date: "2024-01-13 11:00 AM", branch: "East Campus", name: "Suresh Reddy", phone: "+91 54321 09876", email: "suresh@example.com", enquiryType: "Hostel", message: "Need information about hostel facilities", ipAddress: "192.168.1.104", status: "closed" },
];

const columns: Column<OnlineEnquiry>[] = [
  {
    key: "date",
    header: "Received",
    sortable: true,
    cell: (enquiry) => (
      <div>
        <p className="text-sm">{enquiry.date.split(" ")[0]}</p>
        <p className="text-xs text-muted-foreground">{enquiry.date.split(" ").slice(1).join(" ")}</p>
      </div>
    ),
  },
  {
    key: "branch",
    header: "Branch",
    cell: (enquiry) => <Badge variant="outline">{enquiry.branch}</Badge>,
  },
  {
    key: "name",
    header: "Enquirer",
    cell: (enquiry) => (
      <div>
        <p className="font-medium">{enquiry.name}</p>
        <p className="text-xs text-muted-foreground">{enquiry.email}</p>
      </div>
    ),
  },
  {
    key: "enquiryType",
    header: "Type",
    cell: (enquiry) => <Badge variant="secondary">{enquiry.enquiryType}</Badge>,
  },
  {
    key: "message",
    header: "Message",
    cell: (enquiry) => (
      <p className="text-sm text-muted-foreground truncate max-w-[200px]">{enquiry.message}</p>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (enquiry) => <StatusBadge status={enquiry.status} />,
  },
];

export default function OnlineBranchEnquiry() {
  const handleActions = (enquiry: OnlineEnquiry) => [
    { label: "View Full Message", onClick: () => console.log("View", enquiry.id) },
    { label: "Mark as Reviewed", onClick: () => console.log("Review", enquiry.id) },
    { label: "Send Response", onClick: () => console.log("Respond", enquiry.id) },
    { label: "Convert to Lead", onClick: () => console.log("Convert", enquiry.id) },
    { label: "Close", onClick: () => console.log("Close", enquiry.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Online Branch Enquiries"
        description="Manage enquiries received from branch websites"
        breadcrumbs={[
          { label: "Enquiry Management", href: "/enquiry/branch" },
          { label: "Online Branch Enquiry" },
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
          title="Total Online Enquiries"
          value={enquiriesData.length}
          subtitle="This month"
          icon={Globe}
          trend={{ value: 20, isPositive: true }}
        />
        <StatsCard
          title="Pending Review"
          value={enquiriesData.filter(e => e.status === "pending").length}
          subtitle="Needs attention"
          icon={Clock}
        />
        <StatsCard
          title="Responded"
          value={enquiriesData.filter(e => e.status === "responded").length}
          subtitle="This week"
          icon={CheckCircle}
        />
        <StatsCard
          title="By Branch"
          value="4"
          subtitle="Active branches"
          icon={Building2}
        />
      </div>

      <DataTable
        data={enquiriesData}
        columns={columns}
        searchPlaceholder="Search online enquiries..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
