import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Badge } from "@/components/ui/badge";
import { DataTable, Column } from "@/components/ui/DataTable";
import { Users, IndianRupee, CheckCircle, Link2, AlertCircle } from "lucide-react";
import { useState } from "react";

interface StudentAllocation {
  id: string;
  studentId: string;
  name: string;
  course: string;
  batch: string;
  feeGroup: string;
  totalFee: number;
  allocated: boolean;
  dueDate: string;
}

const allocationData: StudentAllocation[] = [
  { id: "1", studentId: "STU001", name: "Rahul Sharma", course: "Computer Science", batch: "CS-2024-A", feeGroup: "Standard Fee Package", totalFee: 59000, allocated: true, dueDate: "2024-02-15" },
  { id: "2", studentId: "STU002", name: "Priya Patel", course: "Computer Science", batch: "CS-2024-A", feeGroup: "Science Stream Package", totalFee: 62000, allocated: true, dueDate: "2024-02-15" },
  { id: "3", studentId: "STU003", name: "Amit Kumar", course: "Commerce", batch: "COM-2024-A", feeGroup: "Standard Fee Package", totalFee: 59000, allocated: true, dueDate: "2024-02-15" },
  { id: "4", studentId: "STU004", name: "Sneha Gupta", course: "Engineering", batch: "ENG-2024-A", feeGroup: "", totalFee: 0, allocated: false, dueDate: "-" },
  { id: "5", studentId: "STU005", name: "Vikram Singh", course: "Arts", batch: "ART-2024-A", feeGroup: "", totalFee: 0, allocated: false, dueDate: "-" },
  { id: "6", studentId: "STU006", name: "Anita Reddy", course: "Science", batch: "SCI-2024-A", feeGroup: "Science Stream Package", totalFee: 62000, allocated: true, dueDate: "2024-02-15" },
];

const columns: Column<StudentAllocation>[] = [
  {
    key: "studentId",
    header: "Student",
    cell: (student) => (
      <div>
        <p className="font-medium">{student.name}</p>
        <p className="text-xs text-muted-foreground">{student.studentId}</p>
      </div>
    ),
  },
  {
    key: "course",
    header: "Course",
    cell: (student) => (
      <div>
        <Badge variant="outline">{student.course}</Badge>
        <p className="text-xs text-muted-foreground mt-1">{student.batch}</p>
      </div>
    ),
  },
  {
    key: "feeGroup",
    header: "Fee Group",
    cell: (student) => (
      student.feeGroup ? (
        <Badge variant="secondary">{student.feeGroup}</Badge>
      ) : (
        <span className="text-muted-foreground text-sm">Not assigned</span>
      )
    ),
  },
  {
    key: "totalFee",
    header: "Total Fee",
    sortable: true,
    cell: (student) => (
      student.totalFee > 0 ? (
        <span className="font-medium">₹{student.totalFee.toLocaleString()}</span>
      ) : (
        <span className="text-muted-foreground">-</span>
      )
    ),
  },
  {
    key: "dueDate",
    header: "Due Date",
    cell: (student) => (
      student.dueDate !== "-" ? (
        <span>{student.dueDate}</span>
      ) : (
        <span className="text-muted-foreground">-</span>
      )
    ),
  },
  {
    key: "allocated",
    header: "Status",
    cell: (student) => (
      student.allocated ? (
        <Badge variant="default" className="gap-1">
          <CheckCircle className="h-3 w-3" />
          Allocated
        </Badge>
      ) : (
        <Badge variant="destructive" className="gap-1">
          <AlertCircle className="h-3 w-3" />
          Pending
        </Badge>
      )
    ),
  },
];

const feeGroups = [
  { id: "standard", name: "Standard Fee Package", amount: 59000 },
  { id: "science", name: "Science Stream Package", amount: 62000 },
  { id: "hostel", name: "Hostel Student Package", amount: 119000 },
  { id: "transport", name: "Day Scholar with Transport", amount: 71000 },
  { id: "merit", name: "Merit Scholarship Package", amount: 29000 },
];

export default function FeeAllocation() {
  const [selectedFeeGroup, setSelectedFeeGroup] = useState("");
  const [selectedStudents, setSelectedStudents] = useState<string[]>([]);

  const handleActions = (student: StudentAllocation) => [
    { label: "View Details", onClick: () => console.log("View", student.id) },
    { label: "Change Fee Group", onClick: () => console.log("Change", student.id) },
    { label: "Add Discount", onClick: () => console.log("Discount", student.id) },
    { label: "Remove Allocation", onClick: () => console.log("Remove", student.id), destructive: true },
  ];

  const pendingCount = allocationData.filter(s => !s.allocated).length;
  const allocatedCount = allocationData.filter(s => s.allocated).length;
  const totalAllocated = allocationData.filter(s => s.allocated).reduce((sum, s) => sum + s.totalFee, 0);

  return (
    <AppLayout>
      <PageHeader
        title="Fee Allocation"
        description="Assign fee groups to students"
        breadcrumbs={[
          { label: "Fee Management", href: "/fee/collection" },
          { label: "Fee Allocation" },
        ]}
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
                <Users className="h-5 w-5 text-primary" />
              </div>
              <div>
                <p className="text-2xl font-bold">{allocationData.length}</p>
                <p className="text-sm text-muted-foreground">Total Students</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-success/10 flex items-center justify-center">
                <CheckCircle className="h-5 w-5 text-success" />
              </div>
              <div>
                <p className="text-2xl font-bold">{allocatedCount}</p>
                <p className="text-sm text-muted-foreground">Fee Allocated</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-destructive/10 flex items-center justify-center">
                <AlertCircle className="h-5 w-5 text-destructive" />
              </div>
              <div>
                <p className="text-2xl font-bold">{pendingCount}</p>
                <p className="text-sm text-muted-foreground">Pending Allocation</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-warning/10 flex items-center justify-center">
                <IndianRupee className="h-5 w-5 text-warning" />
              </div>
              <div>
                <p className="text-2xl font-bold">₹{(totalAllocated / 100000).toFixed(1)}L</p>
                <p className="text-sm text-muted-foreground">Total Allocated</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-6 lg:grid-cols-4 mb-6">
        <Card className="lg:col-span-1">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Link2 className="h-5 w-5" />
              Quick Allocation
            </CardTitle>
            <CardDescription>Assign fee group to multiple students</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>Fee Group</Label>
              <Select value={selectedFeeGroup} onValueChange={setSelectedFeeGroup}>
                <SelectTrigger>
                  <SelectValue placeholder="Select fee group" />
                </SelectTrigger>
                <SelectContent>
                  {feeGroups.map((group) => (
                    <SelectItem key={group.id} value={group.id}>
                      <div className="flex flex-col">
                        <span>{group.name}</span>
                        <span className="text-xs text-muted-foreground">₹{group.amount.toLocaleString()}</span>
                      </div>
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Filter by Course</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="All courses" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Courses</SelectItem>
                  <SelectItem value="cs">Computer Science</SelectItem>
                  <SelectItem value="commerce">Commerce</SelectItem>
                  <SelectItem value="engineering">Engineering</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Filter by Batch</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="All batches" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Batches</SelectItem>
                  <SelectItem value="csa">CS-2024-A</SelectItem>
                  <SelectItem value="csb">CS-2024-B</SelectItem>
                  <SelectItem value="coma">COM-2024-A</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Due Date</Label>
              <input type="date" className="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm" />
            </div>
            <Button className="w-full" disabled={!selectedFeeGroup}>
              Allocate to Selected
            </Button>
          </CardContent>
        </Card>

        <Card className="lg:col-span-3">
          <CardHeader>
            <CardTitle>Student List</CardTitle>
            <CardDescription>Select students to allocate fee groups</CardDescription>
          </CardHeader>
          <CardContent>
            <DataTable
              data={allocationData}
              columns={columns}
              searchPlaceholder="Search students..."
              actions={handleActions}
              selectable
            />
          </CardContent>
        </Card>
      </div>
    </AppLayout>
  );
}
