import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Badge } from "@/components/ui/badge";
import { Printer, Download, Eye, Search, Users, FileSpreadsheet, Calendar, CheckCircle2, XCircle } from "lucide-react";
import { useState } from "react";

const students = [
  { id: "STU001", name: "Rahul Sharma", class: "10th", section: "A", rollNo: "101", marksEntered: true, percentage: "85%" },
  { id: "STU002", name: "Priya Patel", class: "10th", section: "A", rollNo: "102", marksEntered: true, percentage: "92%" },
  { id: "STU003", name: "Amit Kumar", class: "10th", section: "B", rollNo: "103", marksEntered: false, percentage: "-" },
  { id: "STU004", name: "Sneha Gupta", class: "9th", section: "A", rollNo: "201", marksEntered: true, percentage: "78%" },
  { id: "STU005", name: "Vikram Singh", class: "9th", section: "B", rollNo: "202", marksEntered: true, percentage: "88%" },
  { id: "STU006", name: "Anita Desai", class: "8th", section: "A", rollNo: "301", marksEntered: true, percentage: "91%" },
];

const exams = [
  { id: "1", name: "Annual Examination 2024", date: "March 2024" },
  { id: "2", name: "Mid-Term Examination 2024", date: "October 2023" },
  { id: "3", name: "Unit Test 3", date: "February 2024" },
];

const templates = [
  { id: "1", name: "Annual Marksheet Template" },
  { id: "2", name: "Mid-Term Report Card" },
  { id: "3", name: "Semester Marksheet" },
];

export default function GenerateMarksheets() {
  const [selectedStudents, setSelectedStudents] = useState<string[]>([]);
  const [searchTerm, setSearchTerm] = useState("");

  const filteredStudents = students.filter(
    (s) =>
      s.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      s.id.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const toggleStudent = (id: string) => {
    setSelectedStudents((prev) =>
      prev.includes(id) ? prev.filter((s) => s !== id) : [...prev, id]
    );
  };

  const toggleAll = () => {
    const eligibleStudents = filteredStudents.filter(s => s.marksEntered);
    if (selectedStudents.length === eligibleStudents.length) {
      setSelectedStudents([]);
    } else {
      setSelectedStudents(eligibleStudents.map((s) => s.id));
    }
  };

  return (
    <AppLayout>
      <PageHeader
        title="Generate Marksheets"
        description="Generate and print marksheets for students"
        breadcrumbs={[
          { label: "Certificate & Marksheet", href: "/certificate/template" },
          { label: "Generate Marksheets" },
        ]}
      />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Filters */}
        <Card className="lg:col-span-1">
          <CardHeader>
            <CardTitle className="text-lg">Exam & Options</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>Select Examination</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Choose examination" />
                </SelectTrigger>
                <SelectContent>
                  {exams.map((exam) => (
                    <SelectItem key={exam.id} value={exam.id}>
                      <div>
                        <div>{exam.name}</div>
                        <div className="text-xs text-muted-foreground">{exam.date}</div>
                      </div>
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label>Select Template</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Choose template" />
                </SelectTrigger>
                <SelectContent>
                  {templates.map((t) => (
                    <SelectItem key={t.id} value={t.id}>
                      {t.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label>Class</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="All Classes" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Classes</SelectItem>
                  <SelectItem value="8th">8th</SelectItem>
                  <SelectItem value="9th">9th</SelectItem>
                  <SelectItem value="10th">10th</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label>Section</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="All Sections" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Sections</SelectItem>
                  <SelectItem value="A">Section A</SelectItem>
                  <SelectItem value="B">Section B</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="space-y-2">
              <Label>Marks Status Filter</Label>
              <Select defaultValue="all">
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Students</SelectItem>
                  <SelectItem value="entered">Marks Entered Only</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="pt-4 border-t space-y-3">
              <div className="flex items-center gap-2 text-sm">
                <Users className="h-4 w-4 text-muted-foreground" />
                <span>Selected: {selectedStudents.length} students</span>
              </div>
              <div className="flex items-center gap-2 text-sm">
                <FileSpreadsheet className="h-4 w-4 text-muted-foreground" />
                <span>Marksheets to generate: {selectedStudents.length}</span>
              </div>
              <div className="flex items-center gap-2 text-sm">
                <Calendar className="h-4 w-4 text-muted-foreground" />
                <span>Exam: Annual 2024</span>
              </div>
            </div>

            <div className="flex flex-col gap-2 pt-4">
              <Button className="w-full" disabled={selectedStudents.length === 0}>
                <Eye className="h-4 w-4 mr-2" />
                Preview Marksheets
              </Button>
              <Button variant="outline" className="w-full" disabled={selectedStudents.length === 0}>
                <Printer className="h-4 w-4 mr-2" />
                Print Marksheets
              </Button>
              <Button variant="outline" className="w-full" disabled={selectedStudents.length === 0}>
                <Download className="h-4 w-4 mr-2" />
                Download PDF
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Student Selection */}
        <Card className="lg:col-span-2">
          <CardHeader>
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
              <CardTitle className="text-lg">Select Students</CardTitle>
              <div className="relative w-full sm:w-64">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search students..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-9"
                />
              </div>
            </div>
          </CardHeader>
          <CardContent>
            <div className="border rounded-lg overflow-hidden">
              <table className="w-full">
                <thead className="bg-muted/50">
                  <tr>
                    <th className="p-3 text-left">
                      <Checkbox
                        checked={selectedStudents.length === filteredStudents.filter(s => s.marksEntered).length && filteredStudents.filter(s => s.marksEntered).length > 0}
                        onCheckedChange={toggleAll}
                      />
                    </th>
                    <th className="p-3 text-left text-sm font-medium">Student ID</th>
                    <th className="p-3 text-left text-sm font-medium">Name</th>
                    <th className="p-3 text-left text-sm font-medium">Class</th>
                    <th className="p-3 text-left text-sm font-medium">Roll No</th>
                    <th className="p-3 text-left text-sm font-medium">Marks Status</th>
                    <th className="p-3 text-left text-sm font-medium">Percentage</th>
                  </tr>
                </thead>
                <tbody className="divide-y">
                  {filteredStudents.map((student) => (
                    <tr key={student.id} className={`hover:bg-muted/30 ${!student.marksEntered ? 'opacity-50' : ''}`}>
                      <td className="p-3">
                        <Checkbox
                          checked={selectedStudents.includes(student.id)}
                          onCheckedChange={() => toggleStudent(student.id)}
                          disabled={!student.marksEntered}
                        />
                      </td>
                      <td className="p-3 text-sm font-mono">{student.id}</td>
                      <td className="p-3 text-sm font-medium">{student.name}</td>
                      <td className="p-3 text-sm">{student.class} - {student.section}</td>
                      <td className="p-3 text-sm">{student.rollNo}</td>
                      <td className="p-3">
                        {student.marksEntered ? (
                          <Badge className="bg-green-500/10 text-green-600 border-green-200">
                            <CheckCircle2 className="h-3 w-3 mr-1" />
                            Entered
                          </Badge>
                        ) : (
                          <Badge className="bg-red-500/10 text-red-600 border-red-200">
                            <XCircle className="h-3 w-3 mr-1" />
                            Pending
                          </Badge>
                        )}
                      </td>
                      <td className="p-3 text-sm font-medium">{student.percentage}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {filteredStudents.length === 0 && (
              <div className="text-center py-8 text-muted-foreground">
                No students found matching your search
              </div>
            )}

            <div className="mt-4 p-3 bg-blue-500/10 border border-blue-200 rounded-lg">
              <p className="text-sm text-blue-700">
                <strong>Note:</strong> Students with pending marks entry cannot be selected for marksheet generation. Please ensure all marks are entered first.
              </p>
            </div>
          </CardContent>
        </Card>
      </div>
    </AppLayout>
  );
}
