import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Plus, ClipboardList, Calendar, Award, FileText } from "lucide-react";

interface ExamRecord {
  id: string;
  examName: string;
  course: string;
  batch: string;
  date: string;
  duration: string;
  totalMarks: number;
  studentsAppeared: number;
  status: "completed" | "pending" | "active";
}

const examsData: ExamRecord[] = [
  { id: "1", examName: "Mid-Term Examination", course: "Computer Science", batch: "2024-A", date: "2024-01-25", duration: "3 hours", totalMarks: 100, studentsAppeared: 45, status: "completed" },
  { id: "2", examName: "Practical Test", course: "Science", batch: "2024-B", date: "2024-01-28", duration: "2 hours", totalMarks: 50, studentsAppeared: 38, status: "completed" },
  { id: "3", examName: "Unit Test 1", course: "Commerce", batch: "2024-A", date: "2024-02-05", duration: "1 hour", totalMarks: 25, studentsAppeared: 0, status: "pending" },
  { id: "4", examName: "Final Examination", course: "Arts", batch: "2024-C", date: "2024-02-15", duration: "3 hours", totalMarks: 100, studentsAppeared: 0, status: "pending" },
  { id: "5", examName: "Lab Practical", course: "Engineering", batch: "2024-A", date: "2024-01-30", duration: "4 hours", totalMarks: 50, studentsAppeared: 52, status: "active" },
];

const columns: Column<ExamRecord>[] = [
  {
    key: "examName",
    header: "Exam",
    sortable: true,
    cell: (exam) => (
      <div>
        <p className="font-medium">{exam.examName}</p>
        <p className="text-xs text-muted-foreground">{exam.course}</p>
      </div>
    ),
  },
  { key: "batch", header: "Batch" },
  {
    key: "date",
    header: "Date",
    sortable: true,
    cell: (exam) => (
      <div className="flex items-center gap-2">
        <Calendar className="h-4 w-4 text-muted-foreground" />
        <span>{new Date(exam.date).toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" })}</span>
      </div>
    ),
  },
  { key: "duration", header: "Duration" },
  {
    key: "totalMarks",
    header: "Total Marks",
    cell: (exam) => <Badge variant="secondary">{exam.totalMarks} marks</Badge>,
  },
  {
    key: "studentsAppeared",
    header: "Appeared",
    cell: (exam) => exam.studentsAppeared > 0 ? `${exam.studentsAppeared} students` : "-",
  },
  {
    key: "status",
    header: "Status",
    cell: (exam) => <StatusBadge status={exam.status} />,
  },
];

export default function ExamSchedule() {
  const handleActions = (exam: ExamRecord) => [
    { label: "View Details", onClick: () => console.log("View", exam.id) },
    { label: "Assign Marks", onClick: () => console.log("Marks", exam.id) },
    { label: "Print Hall Ticket", onClick: () => console.log("Hall Ticket", exam.id) },
    { label: "Edit", onClick: () => console.log("Edit", exam.id) },
    { label: "Delete", onClick: () => console.log("Delete", exam.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Exam Schedule"
        description="View and manage examination schedules"
        breadcrumbs={[
          { label: "Exam & Marks", href: "/exam/schedule" },
          { label: "Exam Schedule" },
        ]}
        actions={
          <Button className="gap-2">
            <Plus className="h-4 w-4" />
            Schedule Exam
          </Button>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard title="Total Exams" value="12" subtitle="This semester" icon={ClipboardList} variant="primary" />
        <StatsCard title="Completed" value="5" subtitle="Successfully conducted" icon={Award} variant="success" />
        <StatsCard title="Upcoming" value="4" subtitle="Scheduled" icon={Calendar} variant="info" />
        <StatsCard title="Results Pending" value="3" subtitle="Awaiting marks entry" icon={FileText} variant="warning" />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Examination Schedule</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={examsData}
            columns={columns}
            searchPlaceholder="Search exams..."
            actions={handleActions}
          />
        </CardContent>
      </Card>
    </AppLayout>
  );
}
