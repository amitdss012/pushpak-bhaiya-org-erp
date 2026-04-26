import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { AlertTriangle, IndianRupee, Users, Clock, Send, Download, Bell } from "lucide-react";
import { useState } from "react";

interface DueFee {
  id: string;
  studentId: string;
  name: string;
  course: string;
  batch: string;
  phone: string;
  totalDue: number;
  dueDate: string;
  daysOverdue: number;
  lastReminder: string;
  status: "overdue" | "due_today" | "due_soon";
}

const dueFeesData: DueFee[] = [
  { id: "1", studentId: "STU001", name: "Rahul Sharma", course: "Computer Science", batch: "CS-2024-A", phone: "+91 98765 43210", totalDue: 25000, dueDate: "2024-01-01", daysOverdue: 14, lastReminder: "2024-01-10", status: "overdue" },
  { id: "2", studentId: "STU002", name: "Priya Patel", course: "Commerce", batch: "COM-2024-A", phone: "+91 87654 32109", totalDue: 15000, dueDate: "2024-01-05", daysOverdue: 10, lastReminder: "2024-01-12", status: "overdue" },
  { id: "3", studentId: "STU003", name: "Amit Kumar", course: "Engineering", batch: "ENG-2024-A", phone: "+91 76543 21098", totalDue: 35000, dueDate: "2024-01-15", daysOverdue: 0, lastReminder: "-", status: "due_today" },
  { id: "4", studentId: "STU004", name: "Sneha Gupta", course: "Science", batch: "SCI-2024-A", phone: "+91 65432 10987", totalDue: 12000, dueDate: "2024-01-20", daysOverdue: -5, lastReminder: "-", status: "due_soon" },
  { id: "5", studentId: "STU005", name: "Vikram Singh", course: "Arts", batch: "ART-2024-A", phone: "+91 54321 09876", totalDue: 8000, dueDate: "2023-12-15", daysOverdue: 31, lastReminder: "2024-01-05", status: "overdue" },
  { id: "6", studentId: "STU006", name: "Anita Reddy", course: "Computer Science", batch: "CS-2024-B", phone: "+91 43210 98765", totalDue: 20000, dueDate: "2024-01-18", daysOverdue: -3, lastReminder: "-", status: "due_soon" },
];

const columns: Column<DueFee>[] = [
  {
    key: "studentId",
    header: "Student",
    cell: (fee) => (
      <div>
        <p className="font-medium">{fee.name}</p>
        <p className="text-xs text-muted-foreground">{fee.studentId} • {fee.phone}</p>
      </div>
    ),
  },
  {
    key: "course",
    header: "Course",
    cell: (fee) => (
      <div>
        <Badge variant="outline">{fee.course}</Badge>
        <p className="text-xs text-muted-foreground mt-1">{fee.batch}</p>
      </div>
    ),
  },
  {
    key: "totalDue",
    header: "Amount Due",
    sortable: true,
    cell: (fee) => <span className="font-medium text-destructive">₹{fee.totalDue.toLocaleString()}</span>,
  },
  {
    key: "dueDate",
    header: "Due Date",
    sortable: true,
  },
  {
    key: "daysOverdue",
    header: "Overdue",
    sortable: true,
    cell: (fee) => (
      fee.daysOverdue > 0 ? (
        <Badge variant="destructive">{fee.daysOverdue} days</Badge>
      ) : fee.daysOverdue === 0 ? (
        <Badge variant="default">Today</Badge>
      ) : (
        <Badge variant="secondary">In {Math.abs(fee.daysOverdue)} days</Badge>
      )
    ),
  },
  {
    key: "lastReminder",
    header: "Last Reminder",
    cell: (fee) => (
      fee.lastReminder !== "-" ? (
        <span className="text-sm">{fee.lastReminder}</span>
      ) : (
        <span className="text-muted-foreground text-sm">Not sent</span>
      )
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (fee) => (
      <Badge variant={fee.status === "overdue" ? "destructive" : fee.status === "due_today" ? "default" : "secondary"}>
        {fee.status === "overdue" ? "Overdue" : fee.status === "due_today" ? "Due Today" : "Due Soon"}
      </Badge>
    ),
  },
];

export default function DueFeeCollection() {
  const [isCollectDialogOpen, setIsCollectDialogOpen] = useState(false);
  const [selectedStudent, setSelectedStudent] = useState<DueFee | null>(null);

  const handleActions = (fee: DueFee) => [
    { label: "Collect Payment", onClick: () => { setSelectedStudent(fee); setIsCollectDialogOpen(true); } },
    { label: "Send Reminder", onClick: () => console.log("Remind", fee.id) },
    { label: "View History", onClick: () => console.log("History", fee.id) },
    { label: "Add Penalty", onClick: () => console.log("Penalty", fee.id) },
    { label: "Waive Late Fee", onClick: () => console.log("Waive", fee.id) },
  ];

  const totalDue = dueFeesData.reduce((sum, f) => sum + f.totalDue, 0);
  const overdueCount = dueFeesData.filter(f => f.status === "overdue").length;
  const dueTodayCount = dueFeesData.filter(f => f.status === "due_today").length;

  return (
    <AppLayout>
      <PageHeader
        title="Due Fee Collection"
        description="Track and collect overdue fees from students"
        breadcrumbs={[
          { label: "Fee Management", href: "/fee/collection" },
          { label: "Due Fee Collection" },
        ]}
        actions={
          <div className="flex gap-2">
            <Button variant="outline" className="gap-2">
              <Bell className="h-4 w-4" />
              Send Bulk Reminder
            </Button>
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Export Report
            </Button>
          </div>
        }
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <StatsCard
          title="Total Due Amount"
          value={`₹${(totalDue / 1000).toFixed(0)}K`}
          subtitle="From all students"
          icon={IndianRupee}
        />
        <StatsCard
          title="Students with Dues"
          value={dueFeesData.length}
          subtitle="Need follow-up"
          icon={Users}
        />
        <StatsCard
          title="Overdue"
          value={overdueCount}
          subtitle="Past due date"
          icon={AlertTriangle}
        />
        <StatsCard
          title="Due Today"
          value={dueTodayCount}
          subtitle="Payment expected"
          icon={Clock}
        />
      </div>

      <DataTable
        data={dueFeesData}
        columns={columns}
        searchPlaceholder="Search students with dues..."
        actions={handleActions}
        selectable
      />

      <Dialog open={isCollectDialogOpen} onOpenChange={setIsCollectDialogOpen}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle>Collect Due Payment</DialogTitle>
          </DialogHeader>
          {selectedStudent && (
            <div className="space-y-4 mt-4">
              <div className="p-4 bg-muted rounded-lg">
                <div className="flex justify-between mb-2">
                  <span className="text-muted-foreground">Student:</span>
                  <span className="font-medium">{selectedStudent.name}</span>
                </div>
                <div className="flex justify-between mb-2">
                  <span className="text-muted-foreground">Total Due:</span>
                  <span className="font-medium text-destructive">₹{selectedStudent.totalDue.toLocaleString()}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-muted-foreground">Days Overdue:</span>
                  <span className="font-medium">{selectedStudent.daysOverdue > 0 ? `${selectedStudent.daysOverdue} days` : "Not overdue"}</span>
                </div>
              </div>
              <div className="space-y-2">
                <Label>Amount to Collect *</Label>
                <Input type="number" placeholder="Enter amount" defaultValue={selectedStudent.totalDue} />
              </div>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label>Payment Method *</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="Select method" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="cash">Cash</SelectItem>
                      <SelectItem value="card">Card</SelectItem>
                      <SelectItem value="upi">UPI</SelectItem>
                      <SelectItem value="bank">Bank Transfer</SelectItem>
                      <SelectItem value="cheque">Cheque</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label>Late Fee</Label>
                  <Input type="number" placeholder="e.g., 500" />
                </div>
              </div>
              <div className="space-y-2">
                <Label>Reference Number</Label>
                <Input placeholder="Transaction reference" />
              </div>
              <div className="flex justify-end gap-3 pt-4">
                <Button variant="outline" onClick={() => setIsCollectDialogOpen(false)}>Cancel</Button>
                <Button onClick={() => setIsCollectDialogOpen(false)}>
                  <IndianRupee className="h-4 w-4 mr-2" />
                  Collect Payment
                </Button>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </AppLayout>
  );
}
