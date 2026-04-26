import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Calendar, BookOpen } from "lucide-react";

interface Course {
  id: string;
  name: string;
  code: string;
  duration: string;
  fee: number;
  batches: number;
  students: number;
  status: "active" | "inactive";
}

const coursesData: Course[] = [
  { id: "1", name: "Computer Science", code: "CS101", duration: "4 Years", fee: 50000, batches: 3, students: 120, status: "active" },
  { id: "2", name: "Commerce", code: "COM101", duration: "3 Years", fee: 45000, batches: 2, students: 85, status: "active" },
  { id: "3", name: "Arts", code: "ART101", duration: "3 Years", fee: 35000, batches: 2, students: 65, status: "active" },
  { id: "4", name: "Science", code: "SCI101", duration: "2 Years", fee: 40000, batches: 4, students: 150, status: "active" },
  { id: "5", name: "Engineering", code: "ENG101", duration: "4 Years", fee: 75000, batches: 5, students: 200, status: "active" },
  { id: "6", name: "Medical", code: "MED101", duration: "5 Years", fee: 100000, batches: 2, students: 50, status: "inactive" },
];

const columns: Column<Course>[] = [
  {
    key: "name",
    header: "Course Name",
    sortable: true,
    cell: (course) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <BookOpen className="h-5 w-5 text-primary" />
        </div>
        <div>
          <p className="font-medium">{course.name}</p>
          <p className="text-xs text-muted-foreground">{course.code}</p>
        </div>
      </div>
    ),
  },
  { key: "duration", header: "Duration", sortable: true },
  {
    key: "fee",
    header: "Fee",
    cell: (course) => <span className="font-medium">₹{course.fee.toLocaleString()}</span>,
  },
  {
    key: "batches",
    header: "Batches",
    cell: (course) => <Badge variant="secondary">{course.batches} batches</Badge>,
  },
  {
    key: "students",
    header: "Students",
    sortable: true,
    cell: (course) => <span>{course.students} enrolled</span>,
  },
  {
    key: "status",
    header: "Status",
    cell: (course) => <StatusBadge status={course.status} />,
  },
];

export default function ViewCourses() {
  const handleActions = (course: Course) => [
    { label: "View Details", onClick: () => console.log("View", course.id) },
    { label: "Edit Course", onClick: () => console.log("Edit", course.id) },
    { label: "Manage Batches", onClick: () => console.log("Batches", course.id) },
    { label: "Delete", onClick: () => console.log("Delete", course.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="View Courses"
        description="Manage all courses and their details"
        breadcrumbs={[
          { label: "Course Management", href: "/course/view" },
          { label: "View Courses" },
        ]}
        actions={
          <Button className="gap-2">
            <Plus className="h-4 w-4" />
            Create Course
          </Button>
        }
      />

      <DataTable
        data={coursesData}
        columns={columns}
        searchPlaceholder="Search courses..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
