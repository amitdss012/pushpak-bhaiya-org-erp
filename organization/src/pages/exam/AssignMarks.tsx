import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Save, Upload, Download, Search } from "lucide-react";

const studentsData = [
  { id: "1", name: "Alice Johnson", rollNo: "CS2024001", maxMarks: 100, obtained: null },
  { id: "2", name: "Bob Smith", rollNo: "CS2024002", maxMarks: 100, obtained: 85 },
  { id: "3", name: "Charlie Brown", rollNo: "CS2024003", maxMarks: 100, obtained: 72 },
  { id: "4", name: "Diana Ross", rollNo: "CS2024004", maxMarks: 100, obtained: null },
  { id: "5", name: "Edward Wilson", rollNo: "CS2024005", maxMarks: 100, obtained: 91 },
  { id: "6", name: "Fiona Green", rollNo: "CS2024006", maxMarks: 100, obtained: null },
  { id: "7", name: "George Martin", rollNo: "CS2024007", maxMarks: 100, obtained: 68 },
  { id: "8", name: "Hannah White", rollNo: "CS2024008", maxMarks: 100, obtained: 45 },
];

export default function AssignMarks() {
  return (
    <AppLayout>
      <PageHeader
        title="Assign Marks"
        description="Enter marks for students"
        breadcrumbs={[
          { label: "Exam & Marks", href: "/exam/schedule" },
          { label: "Assign Marks" },
        ]}
        actions={
          <div className="flex gap-2">
            <Button variant="outline" className="gap-2">
              <Upload className="h-4 w-4" />
              Import CSV
            </Button>
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Export
            </Button>
          </div>
        }
      />

      <Card className="mb-6">
        <CardHeader>
          <CardTitle>Select Exam</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid gap-4 md:grid-cols-4">
            <div className="space-y-2">
              <Label>Course</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Select course" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="cs">Computer Science</SelectItem>
                  <SelectItem value="science">Science</SelectItem>
                  <SelectItem value="commerce">Commerce</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Batch</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Select batch" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="2024-a">2024-A</SelectItem>
                  <SelectItem value="2024-b">2024-B</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Exam</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Select exam" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="mid-term">Mid-Term Examination</SelectItem>
                  <SelectItem value="unit-1">Unit Test 1</SelectItem>
                  <SelectItem value="practical">Practical Test</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Subject</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Select subject" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="math">Mathematics</SelectItem>
                  <SelectItem value="physics">Physics</SelectItem>
                  <SelectItem value="chemistry">Chemistry</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <div>
            <CardTitle>Student Marks Entry</CardTitle>
            <p className="text-sm text-muted-foreground mt-1">Mid-Term Examination - Mathematics (Max: 100)</p>
          </div>
          <div className="flex items-center gap-2">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
              <Input placeholder="Search student..." className="pl-9 w-64" />
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="w-12">#</TableHead>
                <TableHead>Student</TableHead>
                <TableHead>Roll No</TableHead>
                <TableHead className="w-32">Max Marks</TableHead>
                <TableHead className="w-40">Obtained Marks</TableHead>
                <TableHead className="w-24">Status</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {studentsData.map((student, index) => (
                <TableRow key={student.id}>
                  <TableCell className="font-medium">{index + 1}</TableCell>
                  <TableCell>
                    <div className="flex items-center gap-3">
                      <Avatar className="h-8 w-8">
                        <AvatarFallback className="text-xs">
                          {student.name.split(" ").map(n => n[0]).join("")}
                        </AvatarFallback>
                      </Avatar>
                      <span className="font-medium">{student.name}</span>
                    </div>
                  </TableCell>
                  <TableCell>{student.rollNo}</TableCell>
                  <TableCell>{student.maxMarks}</TableCell>
                  <TableCell>
                    <Input 
                      type="number" 
                      placeholder="Enter marks"
                      defaultValue={student.obtained || ""}
                      className="w-28"
                      min={0}
                      max={student.maxMarks}
                    />
                  </TableCell>
                  <TableCell>
                    {student.obtained !== null ? (
                      <Badge variant={student.obtained >= 35 ? "default" : "destructive"}>
                        {student.obtained >= 35 ? "Pass" : "Fail"}
                      </Badge>
                    ) : (
                      <Badge variant="secondary">Pending</Badge>
                    )}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>

          <div className="flex justify-between items-center mt-6 pt-4 border-t">
            <div className="text-sm text-muted-foreground">
              Showing 8 students • 5 marked, 3 pending
            </div>
            <Button className="gap-2">
              <Save className="h-4 w-4" />
              Save All Marks
            </Button>
          </div>
        </CardContent>
      </Card>
    </AppLayout>
  );
}
