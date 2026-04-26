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
import { Printer, Download, Eye, Search, Users, CreditCard } from "lucide-react";
import { useState } from "react";

const students = [
  { id: "STU001", name: "Rahul Sharma", class: "10th", section: "A", rollNo: "101", photo: true },
  { id: "STU002", name: "Priya Patel", class: "10th", section: "A", rollNo: "102", photo: true },
  { id: "STU003", name: "Amit Kumar", class: "10th", section: "B", rollNo: "103", photo: false },
  { id: "STU004", name: "Sneha Gupta", class: "9th", section: "A", rollNo: "201", photo: true },
  { id: "STU005", name: "Vikram Singh", class: "9th", section: "B", rollNo: "202", photo: true },
  { id: "STU006", name: "Anita Desai", class: "8th", section: "A", rollNo: "301", photo: true },
];

const templates = [
  { id: "1", name: "Standard Blue Template", type: "Portrait" },
  { id: "2", name: "Modern Green Template", type: "Landscape" },
  { id: "3", name: "Classic Red Template", type: "Portrait" },
];

export default function GenerateIDCards() {
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
    if (selectedStudents.length === filteredStudents.length) {
      setSelectedStudents([]);
    } else {
      setSelectedStudents(filteredStudents.map((s) => s.id));
    }
  };

  return (
    <AppLayout>
      <PageHeader
        title="Generate ID Cards"
        description="Select students and generate ID cards in bulk"
        breadcrumbs={[
          { label: "ID & Admit Card", href: "/cards/id-template" },
          { label: "Generate ID Cards" },
        ]}
      />

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Filters */}
        <Card className="lg:col-span-1">
          <CardHeader>
            <CardTitle className="text-lg">Filters & Options</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label>Select Template</Label>
              <Select>
                <SelectTrigger>
                  <SelectValue placeholder="Choose template" />
                </SelectTrigger>
                <SelectContent>
                  {templates.map((t) => (
                    <SelectItem key={t.id} value={t.id}>
                      {t.name} ({t.type})
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
              <Label>Academic Year</Label>
              <Select defaultValue="2024-25">
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="2024-25">2024-25</SelectItem>
                  <SelectItem value="2023-24">2023-24</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="pt-4 border-t space-y-3">
              <div className="flex items-center gap-2 text-sm">
                <Users className="h-4 w-4 text-muted-foreground" />
                <span>Selected: {selectedStudents.length} students</span>
              </div>
              <div className="flex items-center gap-2 text-sm">
                <CreditCard className="h-4 w-4 text-muted-foreground" />
                <span>Cards to generate: {selectedStudents.length}</span>
              </div>
            </div>

            <div className="flex flex-col gap-2 pt-4">
              <Button className="w-full" disabled={selectedStudents.length === 0}>
                <Eye className="h-4 w-4 mr-2" />
                Preview Cards
              </Button>
              <Button variant="outline" className="w-full" disabled={selectedStudents.length === 0}>
                <Printer className="h-4 w-4 mr-2" />
                Print Cards
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
                        checked={selectedStudents.length === filteredStudents.length && filteredStudents.length > 0}
                        onCheckedChange={toggleAll}
                      />
                    </th>
                    <th className="p-3 text-left text-sm font-medium">Student ID</th>
                    <th className="p-3 text-left text-sm font-medium">Name</th>
                    <th className="p-3 text-left text-sm font-medium">Class</th>
                    <th className="p-3 text-left text-sm font-medium">Roll No</th>
                    <th className="p-3 text-left text-sm font-medium">Photo</th>
                  </tr>
                </thead>
                <tbody className="divide-y">
                  {filteredStudents.map((student) => (
                    <tr key={student.id} className="hover:bg-muted/30">
                      <td className="p-3">
                        <Checkbox
                          checked={selectedStudents.includes(student.id)}
                          onCheckedChange={() => toggleStudent(student.id)}
                        />
                      </td>
                      <td className="p-3 text-sm font-mono">{student.id}</td>
                      <td className="p-3 text-sm font-medium">{student.name}</td>
                      <td className="p-3 text-sm">{student.class} - {student.section}</td>
                      <td className="p-3 text-sm">{student.rollNo}</td>
                      <td className="p-3">
                        <Badge variant={student.photo ? "default" : "destructive"}>
                          {student.photo ? "Available" : "Missing"}
                        </Badge>
                      </td>
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
          </CardContent>
        </Card>
      </div>
    </AppLayout>
  );
}
