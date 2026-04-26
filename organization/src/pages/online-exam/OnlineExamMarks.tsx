import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";
import { Download, Users, Award, Clock, AlertCircle } from "lucide-react";

interface OnlineExamResult {
  id: string;
  studentName: string;
  rollNo: string;
  examTitle: string;
  startTime: string;
  submitTime: string;
  totalQuestions: number;
  attempted: number;
  correct: number;
  wrong: number;
  score: number;
  maxScore: number;
  percentage: number;
  status: "completed" | "in_progress" | "absent";
}

const resultsData: OnlineExamResult[] = [
  { id: "1", studentName: "Alice Johnson", rollNo: "CS2024001", examTitle: "Mid-Term Online Test", startTime: "10:00 AM", submitTime: "10:45 AM", totalQuestions: 50, attempted: 48, correct: 42, wrong: 6, score: 84, maxScore: 100, percentage: 84, status: "completed" },
  { id: "2", studentName: "Bob Smith", rollNo: "CS2024002", examTitle: "Mid-Term Online Test", startTime: "10:00 AM", submitTime: "10:58 AM", totalQuestions: 50, attempted: 50, correct: 38, wrong: 12, score: 76, maxScore: 100, percentage: 76, status: "completed" },
  { id: "3", studentName: "Charlie Brown", rollNo: "CS2024003", examTitle: "Mid-Term Online Test", startTime: "10:00 AM", submitTime: "-", totalQuestions: 50, attempted: 25, correct: 0, wrong: 0, score: 0, maxScore: 100, percentage: 0, status: "in_progress" },
  { id: "4", studentName: "Diana Ross", rollNo: "CS2024004", examTitle: "Mid-Term Online Test", startTime: "-", submitTime: "-", totalQuestions: 50, attempted: 0, correct: 0, wrong: 0, score: 0, maxScore: 100, percentage: 0, status: "absent" },
  { id: "5", studentName: "Edward Wilson", rollNo: "CS2024005", examTitle: "Mid-Term Online Test", startTime: "10:00 AM", submitTime: "10:52 AM", totalQuestions: 50, attempted: 50, correct: 45, wrong: 5, score: 90, maxScore: 100, percentage: 90, status: "completed" },
];

const columns: Column<OnlineExamResult>[] = [
  {
    key: "studentName",
    header: "Student",
    sortable: true,
    cell: (result) => (
      <div className="flex items-center gap-3">
        <Avatar className="h-8 w-8">
          <AvatarFallback className="text-xs">
            {result.studentName.split(" ").map(n => n[0]).join("")}
          </AvatarFallback>
        </Avatar>
        <div>
          <p className="font-medium">{result.studentName}</p>
          <p className="text-xs text-muted-foreground">{result.rollNo}</p>
        </div>
      </div>
    ),
  },
  {
    key: "attempted",
    header: "Progress",
    cell: (result) => (
      <div className="space-y-1">
        <div className="flex justify-between text-xs">
          <span>{result.attempted}/{result.totalQuestions}</span>
          <span>{Math.round((result.attempted / result.totalQuestions) * 100)}%</span>
        </div>
        <Progress value={(result.attempted / result.totalQuestions) * 100} className="h-2" />
      </div>
    ),
  },
  {
    key: "correct",
    header: "Correct/Wrong",
    cell: (result) => (
      <div className="flex gap-2">
        <Badge variant="outline" className="bg-success/10 text-success border-success/20">
          ✓ {result.correct}
        </Badge>
        <Badge variant="outline" className="bg-destructive/10 text-destructive border-destructive/20">
          ✗ {result.wrong}
        </Badge>
      </div>
    ),
  },
  {
    key: "score",
    header: "Score",
    sortable: true,
    cell: (result) => (
      <span className="font-medium">{result.score}/{result.maxScore}</span>
    ),
  },
  {
    key: "percentage",
    header: "Percentage",
    sortable: true,
    cell: (result) => (
      <Badge 
        variant="secondary"
        className={
          result.percentage >= 80 ? "bg-success/10 text-success" :
          result.percentage >= 60 ? "bg-info/10 text-info" :
          result.percentage >= 40 ? "bg-warning/10 text-warning" :
          "bg-destructive/10 text-destructive"
        }
      >
        {result.percentage}%
      </Badge>
    ),
  },
  {
    key: "submitTime",
    header: "Timing",
    cell: (result) => (
      <div className="text-sm">
        <p>Start: {result.startTime}</p>
        <p className="text-muted-foreground">Submit: {result.submitTime}</p>
      </div>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (result) => <StatusBadge status={result.status} />,
  },
];

export default function OnlineExamMarks() {
  const handleActions = (result: OnlineExamResult) => [
    { label: "View Details", onClick: () => console.log("View", result.id) },
    { label: "View Answers", onClick: () => console.log("Answers", result.id) },
    { label: "Download Report", onClick: () => console.log("Download", result.id) },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Online Exam Marks"
        description="View and analyze online examination results"
        breadcrumbs={[
          { label: "Online Exam", href: "/online-exam/create" },
          { label: "Exam Marks" },
        ]}
        actions={
          <Button variant="outline" className="gap-2">
            <Download className="h-4 w-4" />
            Export Results
          </Button>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard title="Total Students" value="45" subtitle="Registered for exam" icon={Users} variant="primary" />
        <StatsCard title="Completed" value="38" subtitle="Submitted successfully" icon={Award} variant="success" />
        <StatsCard title="In Progress" value="4" subtitle="Currently attempting" icon={Clock} variant="info" />
        <StatsCard title="Absent" value="3" subtitle="Did not attempt" icon={AlertCircle} variant="warning" />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Mid-Term Online Test Results</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={resultsData}
            columns={columns}
            searchPlaceholder="Search students..."
            actions={handleActions}
          />
        </CardContent>
      </Card>
    </AppLayout>
  );
}
