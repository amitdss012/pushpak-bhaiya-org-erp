import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Plus, Save, Trash2, Settings } from "lucide-react";
import { useState } from "react";

interface GradeScale {
  id: string;
  grade: string;
  minPercentage: number;
  maxPercentage: number;
  gradePoint: number;
  remarks: string;
}

const initialGrades: GradeScale[] = [
  { id: "1", grade: "A+", minPercentage: 90, maxPercentage: 100, gradePoint: 10, remarks: "Outstanding" },
  { id: "2", grade: "A", minPercentage: 80, maxPercentage: 89, gradePoint: 9, remarks: "Excellent" },
  { id: "3", grade: "B+", minPercentage: 70, maxPercentage: 79, gradePoint: 8, remarks: "Very Good" },
  { id: "4", grade: "B", minPercentage: 60, maxPercentage: 69, gradePoint: 7, remarks: "Good" },
  { id: "5", grade: "C+", minPercentage: 50, maxPercentage: 59, gradePoint: 6, remarks: "Above Average" },
  { id: "6", grade: "C", minPercentage: 40, maxPercentage: 49, gradePoint: 5, remarks: "Average" },
  { id: "7", grade: "D", minPercentage: 35, maxPercentage: 39, gradePoint: 4, remarks: "Below Average" },
  { id: "8", grade: "F", minPercentage: 0, maxPercentage: 34, gradePoint: 0, remarks: "Fail" },
];

const getGradeColor = (grade: string) => {
  switch (grade) {
    case "A+": return "bg-success text-success-foreground";
    case "A": return "bg-success/80 text-success-foreground";
    case "B+": return "bg-info text-info-foreground";
    case "B": return "bg-info/80 text-info-foreground";
    case "C+": return "bg-warning text-warning-foreground";
    case "C": return "bg-warning/80 text-warning-foreground";
    case "D": return "bg-orange-500 text-white";
    case "F": return "bg-destructive text-destructive-foreground";
    default: return "bg-muted text-muted-foreground";
  }
};

export default function GradeManagement() {
  const [grades, setGrades] = useState<GradeScale[]>(initialGrades);

  return (
    <AppLayout>
      <PageHeader
        title="Grade Management"
        description="Configure grading scales and grade point systems"
        breadcrumbs={[
          { label: "Exam & Marks", href: "/exam/schedule" },
          { label: "Grade Management" },
        ]}
        actions={
          <Button className="gap-2">
            <Plus className="h-4 w-4" />
            Add Grade Scale
          </Button>
        }
      />

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Settings className="h-5 w-5" />
                Grade Scale Configuration
              </CardTitle>
              <CardDescription>
                Define percentage ranges and corresponding grades
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead className="w-24">Grade</TableHead>
                    <TableHead>Min %</TableHead>
                    <TableHead>Max %</TableHead>
                    <TableHead>Grade Point</TableHead>
                    <TableHead>Remarks</TableHead>
                    <TableHead className="w-20">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {grades.map((grade) => (
                    <TableRow key={grade.id}>
                      <TableCell>
                        <Badge className={getGradeColor(grade.grade)}>
                          {grade.grade}
                        </Badge>
                      </TableCell>
                      <TableCell>
                        <Input 
                          type="number" 
                          defaultValue={grade.minPercentage}
                          className="w-20"
                        />
                      </TableCell>
                      <TableCell>
                        <Input 
                          type="number" 
                          defaultValue={grade.maxPercentage}
                          className="w-20"
                        />
                      </TableCell>
                      <TableCell>
                        <Input 
                          type="number" 
                          defaultValue={grade.gradePoint}
                          className="w-20"
                          step="0.5"
                        />
                      </TableCell>
                      <TableCell>
                        <Input defaultValue={grade.remarks} />
                      </TableCell>
                      <TableCell>
                        <Button variant="ghost" size="icon" className="text-destructive hover:text-destructive">
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>

              <div className="flex justify-end mt-6 pt-4 border-t">
                <Button className="gap-2">
                  <Save className="h-4 w-4" />
                  Save Changes
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Grade Scale Preview</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-2">
                {grades.map((grade) => (
                  <div 
                    key={grade.id}
                    className="flex items-center justify-between p-2 rounded-md border"
                  >
                    <Badge className={getGradeColor(grade.grade)}>
                      {grade.grade}
                    </Badge>
                    <span className="text-sm text-muted-foreground">
                      {grade.minPercentage}% - {grade.maxPercentage}%
                    </span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Quick Settings</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label>Passing Grade</Label>
                <Input defaultValue="D" />
              </div>
              <div className="space-y-2">
                <Label>Minimum Passing Percentage</Label>
                <Input type="number" defaultValue="35" />
              </div>
              <div className="space-y-2">
                <Label>Maximum Grade Point</Label>
                <Input type="number" defaultValue="10" step="0.5" />
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </AppLayout>
  );
}
