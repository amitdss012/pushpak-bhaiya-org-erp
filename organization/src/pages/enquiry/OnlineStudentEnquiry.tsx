import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatsCard } from "@/components/ui/StatsCard";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { GraduationCap, UserCheck, Clock, TrendingUp, Download, Users } from "lucide-react";

interface StudentEnquiry {
  id: string;
  date: string;
  name: string;
  phone: string;
  email: string;
  currentClass: string;
  applyingFor: string;
  parentName: string;
  parentPhone: string;
  city: string;
  preferredBranch: string;
  status: "new" | "contacted" | "scheduled" | "visited" | "applied";
}

const enquiriesData: StudentEnquiry[] = [
  { id: "1", date: "2024-01-15", name: "Arjun Mehta", phone: "+91 98765 43210", email: "arjun@example.com", currentClass: "10th", applyingFor: "11th Science", parentName: "Rajesh Mehta", parentPhone: "+91 98765 43211", city: "Mumbai", preferredBranch: "Main Campus", status: "new" },
  { id: "2", date: "2024-01-15", name: "Kavya Nair", phone: "+91 87654 32109", email: "kavya@example.com", currentClass: "12th", applyingFor: "B.Tech CSE", parentName: "Suresh Nair", parentPhone: "+91 87654 32110", city: "Pune", preferredBranch: "North Campus", status: "contacted" },
  { id: "3", date: "2024-01-14", name: "Rohan Desai", phone: "+91 76543 21098", email: "rohan@example.com", currentClass: "9th", applyingFor: "10th", parentName: "Mahesh Desai", parentPhone: "+91 76543 21099", city: "Delhi", preferredBranch: "Main Campus", status: "scheduled" },
  { id: "4", date: "2024-01-14", name: "Ishika Kapoor", phone: "+91 65432 10987", email: "ishika@example.com", currentClass: "12th", applyingFor: "BBA", parentName: "Vinod Kapoor", parentPhone: "+91 65432 10988", city: "Bangalore", preferredBranch: "South Campus", status: "visited" },
  { id: "5", date: "2024-01-13", name: "Aditya Rao", phone: "+91 54321 09876", email: "aditya@example.com", currentClass: "Graduate", applyingFor: "MBA", parentName: "Krishna Rao", parentPhone: "+91 54321 09877", city: "Hyderabad", preferredBranch: "Main Campus", status: "applied" },
];

const columns: Column<StudentEnquiry>[] = [
  {
    key: "date",
    header: "Date",
    sortable: true,
  },
  {
    key: "name",
    header: "Student",
    cell: (enquiry) => (
      <div>
        <p className="font-medium">{enquiry.name}</p>
        <p className="text-xs text-muted-foreground">{enquiry.email}</p>
      </div>
    ),
  },
  {
    key: "currentClass",
    header: "Current Class",
    cell: (enquiry) => <Badge variant="outline">{enquiry.currentClass}</Badge>,
  },
  {
    key: "applyingFor",
    header: "Applying For",
    cell: (enquiry) => <Badge variant="secondary">{enquiry.applyingFor}</Badge>,
  },
  {
    key: "parentName",
    header: "Parent",
    cell: (enquiry) => (
      <div>
        <p className="text-sm">{enquiry.parentName}</p>
        <p className="text-xs text-muted-foreground">{enquiry.parentPhone}</p>
      </div>
    ),
  },
  {
    key: "preferredBranch",
    header: "Preferred Branch",
  },
  {
    key: "city",
    header: "City",
  },
  {
    key: "status",
    header: "Status",
    cell: (enquiry) => <StatusBadge status={enquiry.status} />,
  },
];

export default function OnlineStudentEnquiry() {
  const handleActions = (enquiry: StudentEnquiry) => [
    { label: "View Details", onClick: () => console.log("View", enquiry.id) },
    { label: "Schedule Visit", onClick: () => console.log("Schedule", enquiry.id) },
    { label: "Send Info Pack", onClick: () => console.log("Send", enquiry.id) },
    { label: "Convert to Application", onClick: () => console.log("Convert", enquiry.id) },
    { label: "Mark as Closed", onClick: () => console.log("Close", enquiry.id), destructive: true },
  ];

  const statusCounts = {
    new: enquiriesData.filter(e => e.status === "new").length,
    contacted: enquiriesData.filter(e => e.status === "contacted").length,
    scheduled: enquiriesData.filter(e => e.status === "scheduled").length,
    visited: enquiriesData.filter(e => e.status === "visited").length,
    applied: enquiriesData.filter(e => e.status === "applied").length,
  };

  return (
    <AppLayout>
      <PageHeader
        title="Online Student Enquiries"
        description="Manage admission enquiries from prospective students"
        breadcrumbs={[
          { label: "Enquiry Management", href: "/enquiry/branch" },
          { label: "Online Student Enquiry" },
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
          title="Total Enquiries"
          value={enquiriesData.length}
          subtitle="This month"
          icon={GraduationCap}
          trend={{ value: 18, isPositive: true }}
        />
        <StatsCard
          title="New Leads"
          value={statusCounts.new}
          subtitle="Pending contact"
          icon={Users}
        />
        <StatsCard
          title="Visits Scheduled"
          value={statusCounts.scheduled}
          subtitle="This week"
          icon={Clock}
        />
        <StatsCard
          title="Conversion Rate"
          value="32%"
          subtitle="Enquiry to application"
          icon={TrendingUp}
          trend={{ value: 5, isPositive: true }}
        />
      </div>

      <div className="grid gap-4 md:grid-cols-5 mb-6">
        <Card>
          <CardContent className="p-4 text-center">
            <p className="text-2xl font-bold text-muted-foreground">{statusCounts.new}</p>
            <p className="text-sm text-muted-foreground">New</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 text-center">
            <p className="text-2xl font-bold text-primary">{statusCounts.contacted}</p>
            <p className="text-sm text-muted-foreground">Contacted</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 text-center">
            <p className="text-2xl font-bold text-warning">{statusCounts.scheduled}</p>
            <p className="text-sm text-muted-foreground">Scheduled</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 text-center">
            <p className="text-2xl font-bold text-success">{statusCounts.visited}</p>
            <p className="text-sm text-muted-foreground">Visited</p>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4 text-center">
            <p className="text-2xl font-bold text-success">{statusCounts.applied}</p>
            <p className="text-sm text-muted-foreground">Applied</p>
          </CardContent>
        </Card>
      </div>

      <DataTable
        data={enquiriesData}
        columns={columns}
        searchPlaceholder="Search student enquiries..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
