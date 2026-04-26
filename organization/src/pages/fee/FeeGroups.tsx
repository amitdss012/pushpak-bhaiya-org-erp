import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { Plus, Layers, IndianRupee, Users, BookOpen } from "lucide-react";
import { useState } from "react";

interface FeeGroup {
  id: string;
  name: string;
  description: string;
  feeTypes: string[];
  totalAmount: number;
  courses: string[];
  studentsCount: number;
  status: "active" | "inactive";
}

const feeGroupsData: FeeGroup[] = [
  { id: "1", name: "Standard Fee Package", description: "Regular student fee structure", feeTypes: ["Tuition Fee", "Admission Fee", "Exam Fee", "Library Fee"], totalAmount: 59000, courses: ["All Courses"], studentsCount: 450, status: "active" },
  { id: "2", name: "Science Stream Package", description: "Fee structure for science students", feeTypes: ["Tuition Fee", "Admission Fee", "Exam Fee", "Library Fee", "Lab Fee"], totalAmount: 62000, courses: ["Computer Science", "Engineering", "Science"], studentsCount: 280, status: "active" },
  { id: "3", name: "Hostel Student Package", description: "Complete package with hostel", feeTypes: ["Tuition Fee", "Admission Fee", "Exam Fee", "Library Fee", "Hostel Fee"], totalAmount: 119000, courses: ["All Courses"], studentsCount: 85, status: "active" },
  { id: "4", name: "Day Scholar with Transport", description: "Day scholar with bus facility", feeTypes: ["Tuition Fee", "Admission Fee", "Exam Fee", "Library Fee", "Transport Fee"], totalAmount: 71000, courses: ["All Courses"], studentsCount: 120, status: "active" },
  { id: "5", name: "Merit Scholarship Package", description: "Reduced fee for merit students", feeTypes: ["Tuition Fee (50%)", "Exam Fee", "Library Fee"], totalAmount: 29000, courses: ["All Courses"], studentsCount: 25, status: "active" },
];

const availableFeeTypes = [
  { id: "tf", name: "Tuition Fee", amount: 50000 },
  { id: "af", name: "Admission Fee", amount: 5000 },
  { id: "ef", name: "Exam Fee", amount: 2000 },
  { id: "lf", name: "Lab Fee", amount: 3000 },
  { id: "lib", name: "Library Fee", amount: 2000 },
  { id: "sf", name: "Sports Fee", amount: 1500 },
  { id: "trf", name: "Transport Fee", amount: 12000 },
  { id: "hf", name: "Hostel Fee", amount: 60000 },
];

const columns: Column<FeeGroup>[] = [
  {
    key: "name",
    header: "Fee Group",
    sortable: true,
    cell: (group) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <Layers className="h-5 w-5 text-primary" />
        </div>
        <div>
          <p className="font-medium">{group.name}</p>
          <p className="text-xs text-muted-foreground">{group.description}</p>
        </div>
      </div>
    ),
  },
  {
    key: "feeTypes",
    header: "Fee Types",
    cell: (group) => (
      <div className="flex flex-wrap gap-1 max-w-[200px]">
        {group.feeTypes.slice(0, 2).map((type) => (
          <Badge key={type} variant="secondary" className="text-xs">{type}</Badge>
        ))}
        {group.feeTypes.length > 2 && (
          <Badge variant="secondary" className="text-xs">+{group.feeTypes.length - 2}</Badge>
        )}
      </div>
    ),
  },
  {
    key: "totalAmount",
    header: "Total Amount",
    sortable: true,
    cell: (group) => <span className="font-medium text-success">₹{group.totalAmount.toLocaleString()}</span>,
  },
  {
    key: "courses",
    header: "Courses",
    cell: (group) => (
      group.courses[0] === "All Courses" ? (
        <Badge variant="default">All Courses</Badge>
      ) : (
        <Badge variant="outline">{group.courses.length} courses</Badge>
      )
    ),
  },
  {
    key: "studentsCount",
    header: "Students",
    sortable: true,
    cell: (group) => (
      <div className="flex items-center gap-1">
        <Users className="h-4 w-4 text-muted-foreground" />
        <span>{group.studentsCount}</span>
      </div>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (group) => <StatusBadge status={group.status} />,
  },
];

export default function FeeGroups() {
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [selectedFeeTypes, setSelectedFeeTypes] = useState<string[]>([]);

  const handleActions = (group: FeeGroup) => [
    { label: "View Details", onClick: () => console.log("View", group.id) },
    { label: "Edit Group", onClick: () => console.log("Edit", group.id) },
    { label: "Assign to Students", onClick: () => console.log("Assign", group.id) },
    { label: "Duplicate", onClick: () => console.log("Duplicate", group.id) },
    { label: "Delete", onClick: () => console.log("Delete", group.id), destructive: true },
  ];

  const toggleFeeType = (feeId: string) => {
    setSelectedFeeTypes((prev) =>
      prev.includes(feeId) ? prev.filter((id) => id !== feeId) : [...prev, feeId]
    );
  };

  const totalSelected = selectedFeeTypes.reduce((sum, id) => {
    const fee = availableFeeTypes.find(f => f.id === id);
    return sum + (fee?.amount || 0);
  }, 0);

  return (
    <AppLayout>
      <PageHeader
        title="Fee Groups"
        description="Create and manage fee group packages"
        breadcrumbs={[
          { label: "Fee Management", href: "/fee/collection" },
          { label: "Fee Groups" },
        ]}
        actions={
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button className="gap-2">
                <Plus className="h-4 w-4" />
                Create Fee Group
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl">
              <DialogHeader>
                <DialogTitle>Create New Fee Group</DialogTitle>
              </DialogHeader>
              <div className="space-y-4 mt-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Group Name *</Label>
                    <Input placeholder="e.g., Standard Fee Package" />
                  </div>
                  <div className="space-y-2">
                    <Label>Applicable Courses</Label>
                    <Input placeholder="All Courses or specific courses" />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label>Description</Label>
                  <Textarea placeholder="Brief description of the fee group..." rows={2} />
                </div>
                <div className="space-y-2">
                  <Label>Select Fee Types</Label>
                  <div className="border rounded-lg p-4 space-y-3 max-h-64 overflow-y-auto">
                    {availableFeeTypes.map((fee) => (
                      <div key={fee.id} className="flex items-center justify-between p-2 hover:bg-muted rounded-lg">
                        <div className="flex items-center gap-3">
                          <Checkbox
                            id={fee.id}
                            checked={selectedFeeTypes.includes(fee.id)}
                            onCheckedChange={() => toggleFeeType(fee.id)}
                          />
                          <label htmlFor={fee.id} className="cursor-pointer">
                            <span className="font-medium">{fee.name}</span>
                          </label>
                        </div>
                        <span className="text-muted-foreground">₹{fee.amount.toLocaleString()}</span>
                      </div>
                    ))}
                  </div>
                </div>
                {selectedFeeTypes.length > 0 && (
                  <Card className="bg-muted/50">
                    <CardContent className="p-4">
                      <div className="flex items-center justify-between">
                        <span className="font-medium">Total Amount:</span>
                        <span className="text-xl font-bold text-primary">₹{totalSelected.toLocaleString()}</span>
                      </div>
                    </CardContent>
                  </Card>
                )}
                <div className="flex justify-end gap-3 pt-4">
                  <Button variant="outline" onClick={() => setIsDialogOpen(false)}>Cancel</Button>
                  <Button onClick={() => setIsDialogOpen(false)}>Create Group</Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        }
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
                <Layers className="h-5 w-5 text-primary" />
              </div>
              <div>
                <p className="text-2xl font-bold">{feeGroupsData.length}</p>
                <p className="text-sm text-muted-foreground">Fee Groups</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-success/10 flex items-center justify-center">
                <Users className="h-5 w-5 text-success" />
              </div>
              <div>
                <p className="text-2xl font-bold">{feeGroupsData.reduce((sum, g) => sum + g.studentsCount, 0)}</p>
                <p className="text-sm text-muted-foreground">Students Assigned</p>
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
                <p className="text-2xl font-bold">₹{Math.round(feeGroupsData.reduce((sum, g) => sum + g.totalAmount, 0) / feeGroupsData.length / 1000)}K</p>
                <p className="text-sm text-muted-foreground">Avg. Group Amount</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-muted flex items-center justify-center">
                <BookOpen className="h-5 w-5 text-muted-foreground" />
              </div>
              <div>
                <p className="text-2xl font-bold">{availableFeeTypes.length}</p>
                <p className="text-sm text-muted-foreground">Fee Types Available</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <DataTable
        data={feeGroupsData}
        columns={columns}
        searchPlaceholder="Search fee groups..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
