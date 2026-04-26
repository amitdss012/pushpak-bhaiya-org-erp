import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Download, FileText, Users, Award, TrendingUp, AlertTriangle } from "lucide-react";

interface MarksRecord {
  id: string;
  studentName: string;
  rollNo: string;
  examName: string;
  subject: string;
  maxMarks: number;
  obtainedMarks: number;
  percentage: number;
  grade: string;
  status: "completed" | "pending" | "absent";
}

const marksData: MarksRecord[] = [
  { id: "1", studentName: "Alice Johnson", rollNo: "CS2024001", examName: "Mid-Term", subject: "Mathematics", maxMarks: 100, obtainedMarks: 92, percentage: 92, grade: "A+", status: "completed" },
  { id: "2", studentName: "Bob Smith", rollNo: "CS2024002", examName: "Mid-Term", subject: "Mathematics", maxMarks: 100, obtainedMarks: 78, percentage: 78, grade: "B+", status: "completed" },
  { id: "3", studentName: "Charlie Brown", rollNo: "CS2024003", examName: "Mid-Term", subject: "Mathematics", maxMarks: 100, obtainedMarks: 65, percentage: 65, grade: "B", status: "completed" },
  { id: "4", studentName: "Diana Ross", rollNo: "CS2024004", examName: "Mid-Term", subject: "Mathematics", maxMarks: 100, obtainedMarks: 0, percentage: 0, grade: "-", status: "absent" },
  { id: "5", studentName: "Edward Wilson", rollNo: "CS2024005", examName: "Mid-Term", subject: "Mathematics", maxMarks: 100, obtainedMarks: 88, percentage: 88, grade: "A", status: "completed" },
  { id: "6", studentName: "Fiona Green", rollNo: "CS2024006", examName: "Mid-Term", subject: "Mathematics", maxMarks: 100, obtainedMarks: 45, percentage: 45, grade: "C", status: "completed" },
  { id: "7", studentName: "George Martin", rollNo: "CS2024007", examName: "Mid-Term", subject: "Mathematics", maxMarks: 100, obtainedMarks: 32, percentage: 32, grade: "F", status: "completed" },
];

const getGradeColor = (grade: string) => {
  switch (grade) {
    case "A+": case "A": return "bg-success/10 text-success border-success/20";
    case "B+": case "B": return "bg-info/10 text-info border-info/20";
    case "C+": case "C": return "bg-warning/10 text-warning border-warning/20";
    case "F": return "bg-destructive/10 text-destructive border-destructive/20";
    default: return "bg-muted text-muted-foreground";
  }
};

const columns: Column<MarksRecord>[] = [
  {
    key: "studentName",
    header: "Student",
    sortable: true,
    cell: (record) => (
      <div className="flex items-center gap-3">
        <Avatar className="h-8 w-8">
          <AvatarFallback className="text-xs">
            {record.studentName.split(" ").map(n => n[0]).join("")}
          </AvatarFallback>
        </Avatar>
        <div>
          <p className="font-medium">{record.studentName}</p>
          <p className="text-xs text-muted-foreground">{record.rollNo}</p>
        </div>
      </div>
    ),
  },
  { key: "examName", header: "Exam" },
  { key: "subject", header: "Subject" },
  {
    key: "obtainedMarks",
    header: "Marks",
    sortable: true,
    cell: (record) => (
      <span className="font-medium">
        {record.status === "absent" ? "-" : `${record.obtainedMarks}/${record.maxMarks}`}
      </span>
    ),
  },
  {
    key: "percentage",
    header: "Percentage",
    sortable: true,
    cell: (record) => (
      <span>{record.status === "absent" ? "-" : `${record.percentage}%`}</span>
    ),
  },
  {
    key: "grade",
    header: "Grade",
    cell: (record) => (
      <Badge variant="outline" className={getGradeColor(record.grade)}>
        {record.grade}
      </Badge>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (record) => <StatusBadge status={record.status} />,
  },
];

export default function MarksList() {
  const handleActions = (record: MarksRecord) => [
    { label: "View Details", onClick: () => console.log("View", record.id) },
    { label: "Edit Marks", onClick: () => console.log("Edit", record.id) },
    { label: "Print Report", onClick: () => console.log("Print", record.id) },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Marks List"
        description="View and manage student examination marks"
        breadcrumbs={[
          { label: "Exam & Marks", href: "/exam/schedule" },
          { label: "Marks List" },
        ]}
        actions={
          <Button variant="outline" className="gap-2">
            <Download className="h-4 w-4" />
            Export Report
          </Button>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard title="Total Students" value="45" subtitle="In this batch" icon={Users} variant="primary" />
        <StatsCard title="Average Score" value="72%" subtitle="+5% from last exam" icon={TrendingUp} variant="success" />
        <StatsCard title="Top Scorers" value="8" subtitle="Above 85%" icon={Award} variant="info" />
        <StatsCard title="Below Passing" value="3" subtitle="Need attention" icon={AlertTriangle} variant="warning" />
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Mid-Term Examination Results
          </CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={marksData}
            columns={columns}
            searchPlaceholder="Search students..."
            actions={handleActions}
          />
        </CardContent>
      </Card>
    </AppLayout>
  );
}
