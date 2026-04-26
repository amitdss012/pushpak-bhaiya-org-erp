import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Badge } from "@/components/ui/badge";
import { DataTable, Column } from "@/components/ui/DataTable";
import { BookOpen, Users, Link2, CheckCircle } from "lucide-react";
import { useState } from "react";

interface CourseAssignment {
  id: string;
  course: string;
  courseCode: string;
  batch: string;
  subjects: string[];
  instructors: string[];
  status: "assigned" | "pending";
}

const assignmentsData: CourseAssignment[] = [
  { id: "1", course: "Computer Science", courseCode: "CS101", batch: "CS-2024-A", subjects: ["Data Structures", "Algorithms", "Database Systems", "Web Development"], instructors: ["Dr. Smith", "Prof. Johnson"], status: "assigned" },
  { id: "2", course: "Computer Science", courseCode: "CS101", batch: "CS-2024-B", subjects: ["Data Structures", "Algorithms", "Database Systems", "Web Development"], instructors: ["Prof. Johnson", "Dr. Patel"], status: "assigned" },
  { id: "3", course: "Commerce", courseCode: "COM101", batch: "COM-2024-A", subjects: ["Accounting", "Economics", "Business Studies", "Statistics"], instructors: ["Dr. Sharma", "Prof. Gupta"], status: "assigned" },
  { id: "4", course: "Engineering", courseCode: "ENG101", batch: "ENG-2024-A", subjects: ["Mathematics", "Physics", "Chemistry", "Engineering Drawing"], instructors: ["Prof. Kumar"], status: "pending" },
];

const availableCourses = [
  { id: "cs", name: "Computer Science", code: "CS101" },
  { id: "com", name: "Commerce", code: "COM101" },
  { id: "eng", name: "Engineering", code: "ENG101" },
  { id: "arts", name: "Arts", code: "ART101" },
  { id: "sci", name: "Science", code: "SCI101" },
];

const availableBatches = [
  { id: "csa", name: "CS-2024-A", course: "Computer Science" },
  { id: "csb", name: "CS-2024-B", course: "Computer Science" },
  { id: "coma", name: "COM-2024-A", course: "Commerce" },
  { id: "enga", name: "ENG-2024-A", course: "Engineering" },
];

const availableSubjects = [
  "Data Structures", "Algorithms", "Database Systems", "Web Development",
  "Operating Systems", "Computer Networks", "Software Engineering", "Machine Learning"
];

const columns: Column<CourseAssignment>[] = [
  {
    key: "course",
    header: "Course",
    cell: (assignment) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <BookOpen className="h-5 w-5 text-primary" />
        </div>
        <div>
          <p className="font-medium">{assignment.course}</p>
          <p className="text-xs text-muted-foreground">{assignment.courseCode}</p>
        </div>
      </div>
    ),
  },
  {
    key: "batch",
    header: "Batch",
    cell: (assignment) => (
      <div className="flex items-center gap-2">
        <Users className="h-4 w-4 text-muted-foreground" />
        <Badge variant="outline">{assignment.batch}</Badge>
      </div>
    ),
  },
  {
    key: "subjects",
    header: "Subjects",
    cell: (assignment) => (
      <div className="flex flex-wrap gap-1 max-w-[200px]">
        {assignment.subjects.slice(0, 2).map((subject) => (
          <Badge key={subject} variant="secondary" className="text-xs">{subject}</Badge>
        ))}
        {assignment.subjects.length > 2 && (
          <Badge variant="secondary" className="text-xs">+{assignment.subjects.length - 2}</Badge>
        )}
      </div>
    ),
  },
  {
    key: "instructors",
    header: "Instructors",
    cell: (assignment) => (
      <div className="text-sm">
        {assignment.instructors.join(", ")}
      </div>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (assignment) => (
      <Badge variant={assignment.status === "assigned" ? "default" : "secondary"}>
        {assignment.status === "assigned" ? (
          <><CheckCircle className="h-3 w-3 mr-1" /> Assigned</>
        ) : (
          "Pending"
        )}
      </Badge>
    ),
  },
];

export default function AssignCourseToBatch() {
  const [selectedCourse, setSelectedCourse] = useState("");
  const [selectedBatch, setSelectedBatch] = useState("");
  const [selectedSubjects, setSelectedSubjects] = useState<string[]>([]);
  const [newSubject, setNewSubject] = useState("");
  const [subjectsList, setSubjectsList] = useState(availableSubjects);

  const handleActions = (assignment: CourseAssignment) => [
    { label: "View Details", onClick: () => console.log("View", assignment.id) },
    { label: "Edit Assignment", onClick: () => console.log("Edit", assignment.id) },
    { label: "Remove Assignment", onClick: () => console.log("Remove", assignment.id), destructive: true },
  ];

  const toggleSubject = (subject: string) => {
    setSelectedSubjects((prev) =>
      prev.includes(subject) ? prev.filter((s) => s !== subject) : [...prev, subject]
    );
  };

  const addSubject = () => {
    if (newSubject.trim() && !subjectsList.includes(newSubject.trim())) {
      setSubjectsList((prev) => [...prev, newSubject.trim()]);
      setSelectedSubjects((prev) => [...prev, newSubject.trim()]);
      setNewSubject("");
    }
  };

  return (
    <AppLayout>
      <PageHeader
        title="Assign Course to Batch"
        description="Link courses with batches and assign subjects"
        breadcrumbs={[
          { label: "Course Management", href: "/course/view" },
          { label: "Assign Course to Batch" },
        ]}
      />

      <div className="grid gap-6 lg:grid-cols-3 mb-6">
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Link2 className="h-5 w-5" />
              New Assignment
            </CardTitle>
            <CardDescription>Assign a course to a batch with selected subjects</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="grid gap-4 md:grid-cols-3">
              <div className="space-y-2">
                <Label>Select Branch *</Label>
                <Select>
                  <SelectTrigger>
                    <SelectValue placeholder="Choose a branch" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="main">Main Branch</SelectItem>
                    <SelectItem value="north">North Campus</SelectItem>
                    <SelectItem value="south">South Campus</SelectItem>
                    <SelectItem value="east">East Campus</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Select Course *</Label>
                <Select value={selectedCourse} onValueChange={setSelectedCourse}>
                  <SelectTrigger>
                    <SelectValue placeholder="Choose a course" />
                  </SelectTrigger>
                  <SelectContent>
                    {availableCourses.map((course) => (
                      <SelectItem key={course.id} value={course.id}>
                        {course.name} ({course.code})
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>Select Batch *</Label>
                <Select value={selectedBatch} onValueChange={setSelectedBatch}>
                  <SelectTrigger>
                    <SelectValue placeholder="Choose a batch" />
                  </SelectTrigger>
                  <SelectContent>
                    {availableBatches.map((batch) => (
                      <SelectItem key={batch.id} value={batch.id}>
                        {batch.name} - {batch.course}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
            </div>

            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <Label>Select Subjects</Label>
                <div className="flex gap-2 max-w-xs">
                  <Input 
                    placeholder="New subject name" 
                    value={newSubject}
                    onChange={(e) => setNewSubject(e.target.value)}
                    className="h-8"
                  />
                  <Button size="sm" variant="outline" onClick={addSubject} className="h-8">
                    Create Subject
                  </Button>
                </div>
              </div>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-3 p-4 border rounded-lg">
                {subjectsList.map((subject) => (
                  <div key={subject} className="flex items-center space-x-2">
                    <Checkbox
                      id={subject}
                      checked={selectedSubjects.includes(subject)}
                      onCheckedChange={() => toggleSubject(subject)}
                    />
                    <label htmlFor={subject} className="text-sm cursor-pointer line-clamp-1">
                      {subject}
                    </label>
                  </div>
                ))}
              </div>
            </div>

            {selectedSubjects.length > 0 && (
              <div className="flex flex-wrap gap-2">
                <span className="text-sm text-muted-foreground">Selected:</span>
                {selectedSubjects.map((subject) => (
                  <Badge key={subject} variant="secondary">{subject}</Badge>
                ))}
              </div>
            )}

            <div className="flex justify-end gap-3 pt-4">
              <Button variant="outline">Cancel</Button>
              <Button disabled={!selectedCourse || !selectedBatch}>
                <Link2 className="h-4 w-4 mr-2" />
                Assign Course
              </Button>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Quick Stats</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
              <span className="text-sm">Total Assignments</span>
              <span className="font-bold">{assignmentsData.length}</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
              <span className="text-sm">Active Assignments</span>
              <span className="font-bold text-success">{assignmentsData.filter(a => a.status === "assigned").length}</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
              <span className="text-sm">Pending Assignments</span>
              <span className="font-bold text-warning">{assignmentsData.filter(a => a.status === "pending").length}</span>
            </div>
            <div className="flex items-center justify-between p-3 bg-muted rounded-lg">
              <span className="text-sm">Total Batches</span>
              <span className="font-bold">{availableBatches.length}</span>
            </div>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Current Assignments</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={assignmentsData}
            columns={columns}
            searchPlaceholder="Search assignments..."
            actions={handleActions}
          />
        </CardContent>
      </Card>
    </AppLayout>
  );
}
