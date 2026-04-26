import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatsCard } from "@/components/ui/StatsCard";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
 import { Plus, Building2, Users, GraduationCap, IndianRupee, CalendarClock } from "lucide-react";

interface Branch {
  id: string;
  name: string;
  code: string;
  type: string;
   instituteType: string;
  city: string;
  state: string;
  students: number;
  staff: number;
  revenue: number;
  status: "active" | "inactive";
   expiryDate: string;
}

const branchesData: Branch[] = [
 { id: "1", name: "Main Campus", code: "BR001", type: "Main Branch", instituteType: "Computer Institute", city: "Mumbai", state: "Maharashtra", students: 1200, staff: 85, revenue: 2500000, status: "active", expiryDate: "2025-12-31" },
 { id: "2", name: "North Campus", code: "BR002", type: "Sub Branch", instituteType: "Typing Institute", city: "Delhi", state: "Delhi", students: 850, staff: 60, revenue: 1800000, status: "active", expiryDate: "2025-06-30" },
 { id: "3", name: "South Campus", code: "BR003", type: "Sub Branch", instituteType: "Computer Institute", city: "Bangalore", state: "Karnataka", students: 650, staff: 45, revenue: 1400000, status: "active", expiryDate: "2025-09-15" },
 { id: "4", name: "East Campus", code: "BR004", type: "Franchise", instituteType: "Paramedical Institute", city: "Kolkata", state: "West Bengal", students: 420, staff: 32, revenue: 950000, status: "active", expiryDate: "2025-03-31" },
 { id: "5", name: "West Campus", code: "BR005", type: "Sub Branch", instituteType: "Other", city: "Ahmedabad", state: "Gujarat", students: 380, staff: 28, revenue: 820000, status: "inactive", expiryDate: "2024-12-31" },
];

const columns: Column<Branch>[] = [
  {
    key: "name",
    header: "Branch",
    sortable: true,
    cell: (branch) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <Building2 className="h-5 w-5 text-primary" />
        </div>
        <div>
          <p className="font-medium">{branch.name}</p>
          <p className="text-xs text-muted-foreground">{branch.code}</p>
        </div>
      </div>
    ),
  },
  {
    key: "type",
    header: "Type",
     cell: (branch) => (
       <div className="space-y-1">
         <Badge variant="outline">{branch.type}</Badge>
         <p className="text-xs text-muted-foreground">{branch.instituteType}</p>
       </div>
     ),
  },
  {
    key: "city",
    header: "Location",
    cell: (branch) => (
      <span>{branch.city}, {branch.state}</span>
    ),
  },
  {
    key: "students",
    header: "Students",
    sortable: true,
    cell: (branch) => <span className="font-medium">{branch.students.toLocaleString()}</span>,
  },
  {
    key: "staff",
    header: "Staff",
    sortable: true,
  },
  {
    key: "revenue",
    header: "Revenue",
    sortable: true,
    cell: (branch) => <span className="font-medium text-success">₹{(branch.revenue / 100000).toFixed(1)}L</span>,
  },
  {
     key: "expiryDate",
     header: "Expiry",
     sortable: true,
     cell: (branch) => {
       const expiry = new Date(branch.expiryDate);
       const today = new Date();
       const isExpired = expiry < today;
       const isExpiringSoon = !isExpired && expiry <= new Date(today.getTime() + 30 * 24 * 60 * 60 * 1000);
       return (
         <div className="flex items-center gap-1">
           <CalendarClock className={`h-4 w-4 ${isExpired ? 'text-destructive' : isExpiringSoon ? 'text-warning' : 'text-muted-foreground'}`} />
           <span className={isExpired ? 'text-destructive' : isExpiringSoon ? 'text-warning' : ''}>
             {branch.expiryDate}
           </span>
         </div>
       );
     },
   },
   {
    key: "status",
    header: "Status",
    cell: (branch) => <StatusBadge status={branch.status} />,
  },
];

export default function ViewBranch() {
  const handleActions = (branch: Branch) => [
    { label: "View Details", onClick: () => console.log("View", branch.id) },
    { label: "Edit Branch", onClick: () => console.log("Edit", branch.id) },
     { label: "Center Certificate", onClick: () => console.log("Certificate", branch.id) },
    { label: "Manage Staff", onClick: () => console.log("Staff", branch.id) },
    { label: "View Reports", onClick: () => console.log("Reports", branch.id) },
    { label: "Delete", onClick: () => console.log("Delete", branch.id), destructive: true },
  ];

  const totalStudents = branchesData.reduce((sum, b) => sum + b.students, 0);
  const totalStaff = branchesData.reduce((sum, b) => sum + b.staff, 0);
  const totalRevenue = branchesData.reduce((sum, b) => sum + b.revenue, 0);
  const activeBranches = branchesData.filter(b => b.status === "active").length;

  return (
    <AppLayout>
      <PageHeader
        title="View Branches"
        description="Manage all branches and their details"
        breadcrumbs={[
          { label: "Branch Management", href: "/branch/view" },
          { label: "View Branches" },
        ]}
        actions={
          <Button className="gap-2">
            <Plus className="h-4 w-4" />
            Add Branch
          </Button>
        }
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <StatsCard
          title="Total Branches"
          value={branchesData.length}
          subtitle={`${activeBranches} active`}
          icon={Building2}
          trend={{ value: 2, isPositive: true }}
        />
        <StatsCard
          title="Total Students"
          value={totalStudents.toLocaleString()}
          subtitle="Across all branches"
          icon={GraduationCap}
          trend={{ value: 12, isPositive: true }}
        />
        <StatsCard
          title="Total Staff"
          value={totalStaff}
          subtitle="Teaching & non-teaching"
          icon={Users}
        />
        <StatsCard
          title="Total Revenue"
          value={`₹${(totalRevenue / 100000).toFixed(1)}L`}
          subtitle="This month"
          icon={IndianRupee}
          trend={{ value: 8, isPositive: true }}
        />
      </div>

      <DataTable
        data={branchesData}
        columns={columns}
        searchPlaceholder="Search branches..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
