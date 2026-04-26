import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { Plus, IndianRupee, Tags, Edit } from "lucide-react";
import { useState } from "react";

interface FeeType {
  id: string;
  name: string;
  code: string;
  category: string;
  defaultAmount: number;
  frequency: string;
  applicableTo: string[];
  description: string;
  status: "active" | "inactive";
}

const feeTypesData: FeeType[] = [
  { id: "1", name: "Tuition Fee", code: "TF001", category: "Academic", defaultAmount: 50000, frequency: "Yearly", applicableTo: ["All Courses"], description: "Main academic tuition fee", status: "active" },
  { id: "2", name: "Admission Fee", code: "AF001", category: "One-time", defaultAmount: 5000, frequency: "One-time", applicableTo: ["All Courses"], description: "One-time admission processing fee", status: "active" },
  { id: "3", name: "Exam Fee", code: "EF001", category: "Academic", defaultAmount: 2000, frequency: "Per Semester", applicableTo: ["All Courses"], description: "Examination and assessment fee", status: "active" },
  { id: "4", name: "Lab Fee", code: "LF001", category: "Academic", defaultAmount: 3000, frequency: "Yearly", applicableTo: ["Computer Science", "Engineering", "Science"], description: "Laboratory equipment and materials", status: "active" },
  { id: "5", name: "Library Fee", code: "LIB001", category: "Facility", defaultAmount: 2000, frequency: "Yearly", applicableTo: ["All Courses"], description: "Library access and resources", status: "active" },
  { id: "6", name: "Sports Fee", code: "SF001", category: "Facility", defaultAmount: 1500, frequency: "Yearly", applicableTo: ["All Courses"], description: "Sports facilities and activities", status: "active" },
  { id: "7", name: "Transport Fee", code: "TRF001", category: "Optional", defaultAmount: 12000, frequency: "Yearly", applicableTo: ["All Courses"], description: "School bus transportation", status: "active" },
  { id: "8", name: "Hostel Fee", code: "HF001", category: "Optional", defaultAmount: 60000, frequency: "Yearly", applicableTo: ["All Courses"], description: "Hostel accommodation charges", status: "inactive" },
  { id: "9", name: "Re-Exam Fee", code: "REF001", category: "Academic", defaultAmount: 500, frequency: "Per Exam", applicableTo: ["All Courses"], description: "Fee for re-examination attempts", status: "active" },
  { id: "10", name: "Re-Admission Fee", code: "RAF001", category: "One-time", defaultAmount: 2500, frequency: "One-time", applicableTo: ["All Courses"], description: "Fee for re-admission after discontinuation", status: "active" },
];

const columns: Column<FeeType>[] = [
  {
    key: "name",
    header: "Fee Type",
    sortable: true,
    cell: (fee) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <IndianRupee className="h-5 w-5 text-primary" />
        </div>
        <div>
          <p className="font-medium">{fee.name}</p>
          <p className="text-xs text-muted-foreground">{fee.code}</p>
        </div>
      </div>
    ),
  },
  {
    key: "category",
    header: "Category",
    cell: (fee) => <Badge variant="outline">{fee.category}</Badge>,
  },
  {
    key: "defaultAmount",
    header: "Default Amount",
    sortable: true,
    cell: (fee) => <span className="font-medium">₹{fee.defaultAmount.toLocaleString()}</span>,
  },
  {
    key: "frequency",
    header: "Frequency",
    cell: (fee) => <Badge variant="secondary">{fee.frequency}</Badge>,
  },
  {
    key: "applicableTo",
    header: "Applicable To",
    cell: (fee) => (
      <div className="flex flex-wrap gap-1 max-w-[150px]">
        {fee.applicableTo[0] === "All Courses" ? (
          <Badge variant="default">All Courses</Badge>
        ) : (
          <>
            <Badge variant="secondary" className="text-xs">{fee.applicableTo[0]}</Badge>
            {fee.applicableTo.length > 1 && (
              <Badge variant="secondary" className="text-xs">+{fee.applicableTo.length - 1}</Badge>
            )}
          </>
        )}
      </div>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (fee) => <StatusBadge status={fee.status} />,
  },
];

export default function FeeTypes() {
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  const handleActions = (fee: FeeType) => [
    { label: "Edit Fee Type", onClick: () => console.log("Edit", fee.id) },
    { label: "View Usage", onClick: () => console.log("Usage", fee.id) },
    { label: "Duplicate", onClick: () => console.log("Duplicate", fee.id) },
    { label: "Delete", onClick: () => console.log("Delete", fee.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Fee Types"
        description="Manage different types of fees"
        breadcrumbs={[
          { label: "Fee Management", href: "/fee/collection" },
          { label: "Fee Types" },
        ]}
        actions={
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button className="gap-2">
                <Plus className="h-4 w-4" />
                Add Fee Type
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-lg">
              <DialogHeader>
                <DialogTitle>Add New Fee Type</DialogTitle>
              </DialogHeader>
              <div className="space-y-4 mt-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Fee Name *</Label>
                    <Input placeholder="e.g., Tuition Fee" />
                  </div>
                  <div className="space-y-2">
                    <Label>Fee Code *</Label>
                    <Input placeholder="e.g., TF001" />
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Category</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select category" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="academic">Academic</SelectItem>
                        <SelectItem value="facility">Facility</SelectItem>
                        <SelectItem value="onetime">One-time</SelectItem>
                        <SelectItem value="optional">Optional</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Default Amount (₹) *</Label>
                    <Input type="number" placeholder="e.g., 5000" />
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Frequency</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select frequency" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="onetime">One-time</SelectItem>
                        <SelectItem value="monthly">Monthly</SelectItem>
                        <SelectItem value="quarterly">Quarterly</SelectItem>
                        <SelectItem value="semester">Per Semester</SelectItem>
                        <SelectItem value="yearly">Yearly</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Applicable To</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select courses" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="all">All Courses</SelectItem>
                        <SelectItem value="cs">Computer Science</SelectItem>
                        <SelectItem value="engineering">Engineering</SelectItem>
                        <SelectItem value="commerce">Commerce</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="space-y-2">
                  <Label>Description</Label>
                  <Textarea placeholder="Brief description of the fee type..." rows={2} />
                </div>
                <div className="flex items-center gap-2">
                  <Switch id="active" defaultChecked />
                  <Label htmlFor="active">Active</Label>
                </div>
                <div className="flex justify-end gap-3 pt-4">
                  <Button variant="outline" onClick={() => setIsDialogOpen(false)}>Cancel</Button>
                  <Button onClick={() => setIsDialogOpen(false)}>Add Fee Type</Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        }
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <div className="p-4 bg-card border rounded-lg">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
              <Tags className="h-5 w-5 text-primary" />
            </div>
            <div>
              <p className="text-2xl font-bold">{feeTypesData.length}</p>
              <p className="text-sm text-muted-foreground">Total Fee Types</p>
            </div>
          </div>
        </div>
        <div className="p-4 bg-card border rounded-lg">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-lg bg-success/10 flex items-center justify-center">
              <IndianRupee className="h-5 w-5 text-success" />
            </div>
            <div>
              <p className="text-2xl font-bold">{feeTypesData.filter(f => f.status === "active").length}</p>
              <p className="text-sm text-muted-foreground">Active Types</p>
            </div>
          </div>
        </div>
        <div className="p-4 bg-card border rounded-lg">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-lg bg-warning/10 flex items-center justify-center">
              <Edit className="h-5 w-5 text-warning" />
            </div>
            <div>
              <p className="text-2xl font-bold">{feeTypesData.filter(f => f.category === "Academic").length}</p>
              <p className="text-sm text-muted-foreground">Academic Fees</p>
            </div>
          </div>
        </div>
        <div className="p-4 bg-card border rounded-lg">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-lg bg-muted flex items-center justify-center">
              <Tags className="h-5 w-5 text-muted-foreground" />
            </div>
            <div>
              <p className="text-2xl font-bold">{feeTypesData.filter(f => f.category === "Optional").length}</p>
              <p className="text-sm text-muted-foreground">Optional Fees</p>
            </div>
          </div>
        </div>
      </div>

      <DataTable
        data={feeTypesData}
        columns={columns}
        searchPlaceholder="Search fee types..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
