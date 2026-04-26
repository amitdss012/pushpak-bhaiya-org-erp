import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Badge } from "@/components/ui/badge";
import { Users, Calendar, Clock, Plus, BookOpen } from "lucide-react";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { useState } from "react";

interface Batch {
  id: string;
  name: string;
  course: string;
  startDate: string;
  endDate: string;
  capacity: number;
  enrolled: number;
  timing: string;
  instructor: string;
  status: "active" | "upcoming" | "completed";
}

const batchesData: Batch[] = [
  { id: "1", name: "CS-2024-A", course: "Computer Science", startDate: "2024-01-15", endDate: "2025-01-14", capacity: 60, enrolled: 45, timing: "Morning", instructor: "Dr. Smith", status: "active" },
  { id: "2", name: "CS-2024-B", course: "Computer Science", startDate: "2024-01-15", endDate: "2025-01-14", capacity: 60, enrolled: 58, timing: "Evening", instructor: "Prof. Johnson", status: "active" },
  { id: "3", name: "COM-2024-A", course: "Commerce", startDate: "2024-02-01", endDate: "2025-01-31", capacity: 50, enrolled: 32, timing: "Morning", instructor: "Dr. Patel", status: "upcoming" },
  { id: "4", name: "ENG-2024-A", course: "Engineering", startDate: "2024-03-01", endDate: "2028-02-28", capacity: 80, enrolled: 0, timing: "Full Day", instructor: "Prof. Kumar", status: "upcoming" },
  { id: "5", name: "CS-2023-A", course: "Computer Science", startDate: "2023-01-15", endDate: "2024-01-14", capacity: 60, enrolled: 55, timing: "Morning", instructor: "Dr. Smith", status: "completed" },
];

const columns: Column<Batch>[] = [
  {
    key: "name",
    header: "Batch",
    sortable: true,
    cell: (batch) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <Users className="h-5 w-5 text-primary" />
        </div>
        <div>
          <p className="font-medium">{batch.name}</p>
          <p className="text-xs text-muted-foreground">{batch.course}</p>
        </div>
      </div>
    ),
  },
  {
    key: "startDate",
    header: "Duration",
    cell: (batch) => (
      <div>
        <p className="text-sm">{batch.startDate}</p>
        <p className="text-xs text-muted-foreground">to {batch.endDate}</p>
      </div>
    ),
  },
  {
    key: "timing",
    header: "Timing",
    cell: (batch) => <Badge variant="outline">{batch.timing}</Badge>,
  },
  {
    key: "capacity",
    header: "Capacity",
    cell: (batch) => (
      <div>
        <p className="text-sm font-medium">{batch.enrolled}/{batch.capacity}</p>
        <div className="w-20 h-1.5 bg-muted rounded-full mt-1">
          <div
            className="h-full bg-primary rounded-full"
            style={{ width: `${(batch.enrolled / batch.capacity) * 100}%` }}
          />
        </div>
      </div>
    ),
  },
  {
    key: "instructor",
    header: "Instructor",
  },
  {
    key: "status",
    header: "Status",
    cell: (batch) => <StatusBadge status={batch.status} />,
  },
];

export default function CreateBatch() {
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  const handleActions = (batch: Batch) => [
    { label: "View Details", onClick: () => console.log("View", batch.id) },
    { label: "Edit Batch", onClick: () => console.log("Edit", batch.id) },
    { label: "Manage Students", onClick: () => console.log("Students", batch.id) },
    { label: "Set Timetable", onClick: () => console.log("Timetable", batch.id) },
    { label: "Delete", onClick: () => console.log("Delete", batch.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Create Batch"
        description="Manage course batches and enrollments"
        breadcrumbs={[
          { label: "Course Management", href: "/course/view" },
          { label: "Create Batch" },
        ]}
        actions={
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button className="gap-2">
                <Plus className="h-4 w-4" />
                New Batch
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl">
              <DialogHeader>
                <DialogTitle>Create New Batch</DialogTitle>
              </DialogHeader>
              <div className="space-y-4 mt-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Batch Name *</Label>
                    <Input placeholder="e.g., CS-2024-A" />
                  </div>
                  <div className="space-y-2">
                    <Label>Select Branch *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select branch" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="main">Main Branch</SelectItem>
                        <SelectItem value="north">North Campus</SelectItem>
                        <SelectItem value="south">South Campus</SelectItem>
                        <SelectItem value="east">East Campus</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Course *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select course" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="cs">Computer Science</SelectItem>
                        <SelectItem value="commerce">Commerce</SelectItem>
                        <SelectItem value="engineering">Engineering</SelectItem>
                        <SelectItem value="arts">Arts</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Department *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select department" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="science">Science</SelectItem>
                        <SelectItem value="commerce">Commerce</SelectItem>
                        <SelectItem value="arts">Arts</SelectItem>
                        <SelectItem value="engineering">Engineering</SelectItem>
                        <SelectItem value="medical">Medical</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Start Date *</Label>
                    <Input type="date" />
                  </div>
                  <div className="space-y-2">
                    <Label>End Date *</Label>
                    <Input type="date" />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label>Batch Subjects</Label>
                  <div className="grid grid-cols-3 gap-3 p-3 border rounded-lg bg-muted/30">
                    {["Mathematics", "Physics", "Chemistry", "Biology", "English", "CS"].map((subject) => (
                      <div key={subject} className="flex items-center gap-2">
                        <Switch id={`batch-${subject}`} />
                        <Label htmlFor={`batch-${subject}`} className="text-xs cursor-pointer">{subject}</Label>
                      </div>
                    ))}
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Capacity *</Label>
                    <Input type="number" placeholder="e.g., 60" />
                  </div>
                  <div className="space-y-2">
                    <Label>Timing</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select timing" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="morning">Morning (8AM - 12PM)</SelectItem>
                        <SelectItem value="afternoon">Afternoon (12PM - 4PM)</SelectItem>
                        <SelectItem value="evening">Evening (4PM - 8PM)</SelectItem>
                        <SelectItem value="fullday">Full Day</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Instructor</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select instructor" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="smith">Dr. Smith</SelectItem>
                        <SelectItem value="johnson">Prof. Johnson</SelectItem>
                        <SelectItem value="patel">Dr. Patel</SelectItem>
                        <SelectItem value="kumar">Prof. Kumar</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="space-y-2">
                  <Label>Description</Label>
                  <Textarea placeholder="Brief description of the batch..." rows={3} />
                </div>
                <div className="flex items-center gap-4">
                  <div className="flex items-center gap-2">
                    <Switch id="active" defaultChecked />
                    <Label htmlFor="active">Active</Label>
                  </div>
                  <div className="flex items-center gap-2">
                    <Switch id="enrollment" defaultChecked />
                    <Label htmlFor="enrollment">Allow Enrollment</Label>
                  </div>
                </div>
                <div className="flex justify-end gap-3 pt-4">
                  <Button variant="outline" onClick={() => setIsDialogOpen(false)}>Cancel</Button>
                  <Button onClick={() => setIsDialogOpen(false)}>Create Batch</Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        }
      />

      <div className="grid gap-4 md:grid-cols-5 mb-6">
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
                <Users className="h-5 w-5 text-primary" />
              </div>
              <div>
                <p className="text-2xl font-bold">{batchesData.length}</p>
                <p className="text-sm text-muted-foreground">Total Batches</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-secondary/10 flex items-center justify-center">
                <BookOpen className="h-5 w-5 text-secondary-foreground" />
              </div>
              <div>
                <p className="text-2xl font-bold">4</p>
                <p className="text-sm text-muted-foreground">Total Branches</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-accent/10 flex items-center justify-center">
                <Calendar className="h-5 w-5 text-accent-foreground" />
              </div>
              <div>
                <p className="text-2xl font-bold">3</p>
                <p className="text-sm text-muted-foreground">Assigned Batches</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-success/10 flex items-center justify-center">
                <Clock className="h-5 w-5 text-success" />
              </div>
              <div>
                <p className="text-2xl font-bold">{batchesData.filter(b => b.status === "active").length}</p>
                <p className="text-sm text-muted-foreground">Active Batches</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-warning/10 flex items-center justify-center">
                <Calendar className="h-5 w-5 text-warning" />
              </div>
              <div>
                <p className="text-2xl font-bold">{batchesData.filter(b => b.status === "upcoming").length}</p>
                <p className="text-sm text-muted-foreground">Upcoming</p>
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
                <p className="text-2xl font-bold">{batchesData.reduce((sum, b) => sum + b.enrolled, 0)}</p>
                <p className="text-sm text-muted-foreground">Total Enrolled</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <DataTable
        data={batchesData}
        columns={columns}
        searchPlaceholder="Search batches..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
