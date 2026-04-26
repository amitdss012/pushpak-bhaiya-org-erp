import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Save, RotateCcw } from "lucide-react";

export default function CreateExam() {
  return (
    <AppLayout>
      <PageHeader
        title="Create Exam"
        description="Schedule a new examination"
        breadcrumbs={[
          { label: "Exam & Marks", href: "/exam/schedule" },
          { label: "Create Exam" },
        ]}
      />

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Exam Details</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="examName">Exam Name *</Label>
                  <Input id="examName" placeholder="e.g., Mid-Term Examination" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="examType">Exam Type *</Label>
                  <Select>
                    <SelectTrigger id="examType">
                      <SelectValue placeholder="Select type" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="unit-test">Unit Test</SelectItem>
                      <SelectItem value="mid-term">Mid-Term</SelectItem>
                      <SelectItem value="final">Final Exam</SelectItem>
                      <SelectItem value="practical">Practical</SelectItem>
                      <SelectItem value="viva">Viva/Oral</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="course">Course *</Label>
                  <Select>
                    <SelectTrigger id="course">
                      <SelectValue placeholder="Select course" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="cs">Computer Science</SelectItem>
                      <SelectItem value="science">Science</SelectItem>
                      <SelectItem value="commerce">Commerce</SelectItem>
                      <SelectItem value="arts">Arts</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="batch">Batch *</Label>
                  <Select>
                    <SelectTrigger id="batch">
                      <SelectValue placeholder="Select batch" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="2024-a">2024-A</SelectItem>
                      <SelectItem value="2024-b">2024-B</SelectItem>
                      <SelectItem value="2024-c">2024-C</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="grid gap-4 md:grid-cols-3">
                <div className="space-y-2">
                  <Label htmlFor="examDate">Exam Date *</Label>
                  <Input id="examDate" type="date" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="startTime">Start Time *</Label>
                  <Input id="startTime" type="time" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="duration">Duration (minutes) *</Label>
                  <Input id="duration" type="number" placeholder="120" />
                </div>
              </div>

              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="totalMarks">Total Marks *</Label>
                  <Input id="totalMarks" type="number" placeholder="100" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="passingMarks">Passing Marks *</Label>
                  <Input id="passingMarks" type="number" placeholder="35" />
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="instructions">Exam Instructions</Label>
                <Textarea 
                  id="instructions" 
                  placeholder="Enter instructions for students..."
                  rows={4}
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Venue & Supervision</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="venue">Exam Venue</Label>
                  <Select>
                    <SelectTrigger id="venue">
                      <SelectValue placeholder="Select venue" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="hall-a">Examination Hall A</SelectItem>
                      <SelectItem value="hall-b">Examination Hall B</SelectItem>
                      <SelectItem value="lab-1">Computer Lab 1</SelectItem>
                      <SelectItem value="classroom">Classroom 101</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="supervisor">Supervisor</Label>
                  <Select>
                    <SelectTrigger id="supervisor">
                      <SelectValue placeholder="Select supervisor" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="john">John Smith</SelectItem>
                      <SelectItem value="sarah">Sarah Johnson</SelectItem>
                      <SelectItem value="michael">Michael Brown</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Settings</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center space-x-2">
                <Checkbox id="hallTicket" />
                <Label htmlFor="hallTicket" className="font-normal">Generate Hall Tickets</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="seating" />
                <Label htmlFor="seating" className="font-normal">Auto-generate Seating Plan</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="notify" defaultChecked />
                <Label htmlFor="notify" className="font-normal">Notify Students via SMS/Email</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="grading" />
                <Label htmlFor="grading" className="font-normal">Enable Grade Calculation</Label>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Actions</CardTitle>
            </CardHeader>
            <CardContent className="space-y-3">
              <Button className="w-full gap-2">
                <Save className="h-4 w-4" />
                Create Exam
              </Button>
              <Button variant="outline" className="w-full gap-2">
                <RotateCcw className="h-4 w-4" />
                Reset Form
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    </AppLayout>
  );
}
