import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { CreditCard, Receipt, AlertCircle, CheckCircle, Plus, Printer } from "lucide-react";

interface FeeRecord {
  id: string;
  studentName: string;
  rollNo: string;
  course: string;
  feeType: string;
  totalAmount: number;
  paidAmount: number;
  dueAmount: number;
  dueDate: string;
  status: "paid" | "due" | "partial";
}

const feeData: FeeRecord[] = [
  {
    id: "1",
    studentName: "John Doe",
    rollNo: "STU001",
    course: "Computer Science",
    feeType: "Tuition Fee",
    totalAmount: 50000,
    paidAmount: 50000,
    dueAmount: 0,
    dueDate: "2024-01-15",
    status: "paid",
  },
  {
    id: "2",
    studentName: "Sarah Smith",
    rollNo: "STU002",
    course: "Commerce",
    feeType: "Tuition Fee",
    totalAmount: 45000,
    paidAmount: 25000,
    dueAmount: 20000,
    dueDate: "2024-01-20",
    status: "partial",
  },
  {
    id: "3",
    studentName: "Mike Johnson",
    rollNo: "STU003",
    course: "Arts",
    feeType: "Exam Fee",
    totalAmount: 5000,
    paidAmount: 0,
    dueAmount: 5000,
    dueDate: "2024-01-10",
    status: "due",
  },
  {
    id: "4",
    studentName: "Emily Brown",
    rollNo: "STU004",
    course: "Science",
    feeType: "Lab Fee",
    totalAmount: 15000,
    paidAmount: 15000,
    dueAmount: 0,
    dueDate: "2024-01-25",
    status: "paid",
  },
  {
    id: "5",
    studentName: "David Wilson",
    rollNo: "STU005",
    course: "Engineering",
    feeType: "Tuition Fee",
    totalAmount: 75000,
    paidAmount: 50000,
    dueAmount: 25000,
    dueDate: "2024-01-18",
    status: "partial",
  },
  {
    id: "6",
    studentName: "Lisa Anderson",
    rollNo: "STU006",
    course: "Medical",
    feeType: "Tuition Fee",
    totalAmount: 100000,
    paidAmount: 0,
    dueAmount: 100000,
    dueDate: "2024-01-12",
    status: "due",
  },
];

const columns: Column<FeeRecord>[] = [
  {
    key: "studentName",
    header: "Student",
    sortable: true,
    cell: (record) => (
      <div className="flex items-center gap-3">
        <Avatar className="h-9 w-9">
          <AvatarFallback className="bg-primary/10 text-primary text-sm">
            {record.studentName.split(" ").map((n) => n[0]).join("")}
          </AvatarFallback>
        </Avatar>
        <div>
          <p className="font-medium">{record.studentName}</p>
          <p className="text-xs text-muted-foreground">{record.rollNo}</p>
        </div>
      </div>
    ),
  },
  {
    key: "course",
    header: "Course",
    sortable: true,
  },
  {
    key: "feeType",
    header: "Fee Type",
    sortable: true,
  },
  {
    key: "totalAmount",
    header: "Total",
    cell: (record) => (
      <span className="font-medium">₹{record.totalAmount.toLocaleString()}</span>
    ),
  },
  {
    key: "paidAmount",
    header: "Paid",
    cell: (record) => (
      <span className="text-success font-medium">₹{record.paidAmount.toLocaleString()}</span>
    ),
  },
  {
    key: "dueAmount",
    header: "Due",
    cell: (record) => (
      <span className={record.dueAmount > 0 ? "text-destructive font-medium" : ""}>
        ₹{record.dueAmount.toLocaleString()}
      </span>
    ),
  },
  {
    key: "dueDate",
    header: "Due Date",
    sortable: true,
    cell: (record) => (
      <span className="text-sm">
        {new Date(record.dueDate).toLocaleDateString("en-US", {
          year: "numeric",
          month: "short",
          day: "numeric",
        })}
      </span>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (record) => <StatusBadge status={record.status} />,
  },
];

export default function FeeCollection() {
  const [isCollectDialogOpen, setIsCollectDialogOpen] = useState(false);
  const [selectedRecord, setSelectedRecord] = useState<FeeRecord | null>(null);

  const totalCollected = feeData.reduce((sum, r) => sum + r.paidAmount, 0);
  const totalPending = feeData.reduce((sum, r) => sum + r.dueAmount, 0);
  const paidCount = feeData.filter((r) => r.status === "paid").length;
  const dueCount = feeData.filter((r) => r.status === "due").length;

  const handleCollectFee = (record: FeeRecord) => {
    setSelectedRecord(record);
    setIsCollectDialogOpen(true);
  };

  const handleActions = (record: FeeRecord) => [
    { label: "Collect Payment", onClick: () => handleCollectFee(record) },
    { label: "View History", onClick: () => console.log("History", record.id) },
    { label: "Print Receipt", onClick: () => console.log("Print", record.id) },
    { label: "Send Reminder", onClick: () => console.log("Remind", record.id) },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Fee Collection"
        description="Manage student fee payments and collections"
        breadcrumbs={[
          { label: "Fee Management", href: "/fee/collection" },
          { label: "Fee Collection" },
        ]}
        actions={
          <Button className="gap-2">
            <Plus className="h-4 w-4" />
            New Collection
          </Button>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard
          title="Total Collected"
          value={`₹${(totalCollected / 100000).toFixed(1)}L`}
          subtitle="This month"
          icon={CreditCard}
          variant="success"
        />
        <StatsCard
          title="Pending Amount"
          value={`₹${(totalPending / 100000).toFixed(1)}L`}
          subtitle={`${dueCount + feeData.filter((r) => r.status === "partial").length} students`}
          icon={AlertCircle}
          variant="warning"
        />
        <StatsCard
          title="Fully Paid"
          value={paidCount}
          subtitle="Students with no dues"
          icon={CheckCircle}
          variant="primary"
        />
        <StatsCard
          title="Overdue"
          value={dueCount}
          subtitle="Requires follow-up"
          icon={Receipt}
          variant="info"
        />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Fee Records</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={feeData}
            columns={columns}
            selectable
            searchPlaceholder="Search by student name, roll no, or course..."
            actions={handleActions}
          />
        </CardContent>
      </Card>

      <Dialog open={isCollectDialogOpen} onOpenChange={setIsCollectDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Collect Fee Payment</DialogTitle>
          </DialogHeader>
          {selectedRecord && (
            <div className="space-y-4">
              <div className="p-4 rounded-lg bg-muted/50">
                <div className="flex items-center gap-3 mb-3">
                  <Avatar className="h-10 w-10">
                    <AvatarFallback className="bg-primary/10 text-primary">
                      {selectedRecord.studentName.split(" ").map((n) => n[0]).join("")}
                    </AvatarFallback>
                  </Avatar>
                  <div>
                    <p className="font-medium">{selectedRecord.studentName}</p>
                    <p className="text-sm text-muted-foreground">
                      {selectedRecord.rollNo} • {selectedRecord.course}
                    </p>
                  </div>
                </div>
                <div className="grid grid-cols-2 gap-2 text-sm">
                  <div>
                    <span className="text-muted-foreground">Due Amount:</span>
                    <span className="ml-2 font-medium text-destructive">
                      ₹{selectedRecord.dueAmount.toLocaleString()}
                    </span>
                  </div>
                  <div>
                    <span className="text-muted-foreground">Fee Type:</span>
                    <span className="ml-2 font-medium">{selectedRecord.feeType}</span>
                  </div>
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="amount">Payment Amount *</Label>
                <Input
                  id="amount"
                  type="number"
                  placeholder="Enter amount"
                  defaultValue={selectedRecord.dueAmount}
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="method">Payment Method</Label>
                <Select defaultValue="cash">
                  <SelectTrigger>
                    <SelectValue />
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
                <Label htmlFor="remarks">Remarks</Label>
                <Input id="remarks" placeholder="Optional remarks" />
              </div>
            </div>
          )}
          <DialogFooter className="gap-2">
            <Button variant="outline" onClick={() => setIsCollectDialogOpen(false)}>
              Cancel
            </Button>
            <Button variant="outline" className="gap-2">
              <Printer className="h-4 w-4" />
              Print Receipt
            </Button>
            <Button onClick={() => setIsCollectDialogOpen(false)}>
              Collect Payment
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AppLayout>
  );
}
