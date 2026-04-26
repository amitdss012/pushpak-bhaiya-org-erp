import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Plus, FileText, HelpCircle, CheckSquare, ListOrdered, Save } from "lucide-react";

interface QuestionPaper {
  id: string;
  paperCode: string;
  title: string;
  course: string;
  totalQuestions: number;
  totalMarks: number;
  duration: string;
  createdDate: string;
  status: "draft" | "published" | "archived";
}

const papersData: QuestionPaper[] = [
  { id: "1", paperCode: "QP-2024-CS-001", title: "Mid-Term Computer Science", course: "Computer Science", totalQuestions: 50, totalMarks: 100, duration: "2 hours", createdDate: "2024-01-15", status: "published" },
  { id: "2", paperCode: "QP-2024-PHY-001", title: "Physics Unit Test", course: "Science", totalQuestions: 30, totalMarks: 50, duration: "1 hour", createdDate: "2024-01-18", status: "published" },
  { id: "3", paperCode: "QP-2024-MATH-001", title: "Mathematics Final Exam", course: "Commerce", totalQuestions: 60, totalMarks: 100, duration: "3 hours", createdDate: "2024-01-20", status: "draft" },
  { id: "4", paperCode: "QP-2024-ENG-001", title: "English Comprehension", course: "Arts", totalQuestions: 40, totalMarks: 80, duration: "1.5 hours", createdDate: "2024-01-22", status: "draft" },
];

const getStatusColor = (status: string) => {
  switch (status) {
    case "published": return "bg-success/10 text-success border-success/20";
    case "draft": return "bg-warning/10 text-warning border-warning/20";
    case "archived": return "bg-muted text-muted-foreground";
    default: return "bg-muted text-muted-foreground";
  }
};

const columns: Column<QuestionPaper>[] = [
  {
    key: "paperCode",
    header: "Paper Code",
    sortable: true,
    cell: (paper) => (
      <div>
        <p className="font-medium">{paper.paperCode}</p>
        <p className="text-xs text-muted-foreground">{paper.title}</p>
      </div>
    ),
  },
  { key: "course", header: "Course" },
  {
    key: "totalQuestions",
    header: "Questions",
    cell: (paper) => (
      <div className="flex items-center gap-2">
        <HelpCircle className="h-4 w-4 text-muted-foreground" />
        <span>{paper.totalQuestions}</span>
      </div>
    ),
  },
  {
    key: "totalMarks",
    header: "Total Marks",
    cell: (paper) => <Badge variant="secondary">{paper.totalMarks} marks</Badge>,
  },
  { key: "duration", header: "Duration" },
  {
    key: "createdDate",
    header: "Created",
    sortable: true,
    cell: (paper) => new Date(paper.createdDate).toLocaleDateString(),
  },
  {
    key: "status",
    header: "Status",
    cell: (paper) => (
      <Badge variant="outline" className={getStatusColor(paper.status)}>
        {paper.status.charAt(0).toUpperCase() + paper.status.slice(1)}
      </Badge>
    ),
  },
];

export default function QuestionPaperBuilder() {
  const handleActions = (paper: QuestionPaper) => [
    { label: "Edit Paper", onClick: () => console.log("Edit", paper.id) },
    { label: "Add Questions", onClick: () => console.log("Add Questions", paper.id) },
    { label: "Preview", onClick: () => console.log("Preview", paper.id) },
    { label: "Duplicate", onClick: () => console.log("Duplicate", paper.id) },
    { label: "Delete", onClick: () => console.log("Delete", paper.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Question Paper Builder"
        description="Create and manage question papers for online exams"
        breadcrumbs={[
          { label: "Online Exam", href: "/online-exam/create" },
          { label: "Question Paper Builder" },
        ]}
        actions={
          <Button className="gap-2">
            <Plus className="h-4 w-4" />
            New Question Paper
          </Button>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard title="Total Papers" value="12" subtitle="Created this year" icon={FileText} variant="primary" />
        <StatsCard title="Questions Bank" value="450" subtitle="Available questions" icon={HelpCircle} variant="info" />
        <StatsCard title="MCQ Questions" value="320" subtitle="Multiple choice" icon={CheckSquare} variant="success" />
        <StatsCard title="Descriptive" value="130" subtitle="Long answer" icon={ListOrdered} variant="warning" />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Question Papers</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={papersData}
            columns={columns}
            searchPlaceholder="Search question papers..."
            actions={handleActions}
          />
        </CardContent>
      </Card>
    </AppLayout>
  );
}
