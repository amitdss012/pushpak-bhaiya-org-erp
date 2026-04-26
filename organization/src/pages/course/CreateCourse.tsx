import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { BookOpen, Clock, IndianRupee, Settings, Upload } from "lucide-react";

export default function CreateCourse() {
  return (
    <AppLayout>
      <PageHeader
        title="Create Course"
        description="Add a new course to your institution"
        breadcrumbs={[
          { label: "Course Management", href: "/course/view" },
          { label: "Create Course" },
        ]}
      />

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <BookOpen className="h-5 w-5" />
                Course Information
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="courseName">Course Name *</Label>
                  <Input id="courseName" placeholder="e.g., Computer Science" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="courseCode">Course Code *</Label>
                  <Input id="courseCode" placeholder="e.g., CS101" />
                </div>
              </div>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="courseType">Course Type</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="Select type" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="degree">Degree</SelectItem>
                      <SelectItem value="diploma">Diploma</SelectItem>
                      <SelectItem value="certificate">Certificate</SelectItem>
                      <SelectItem value="professional">Professional</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="department">Department</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="Select department" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="science">Science</SelectItem>
                      <SelectItem value="commerce">Commerce</SelectItem>
                      <SelectItem value="arts">Arts</SelectItem>
                      <SelectItem value="engineering">Engineering</SelectItem>
                      <SelectItem value="medical">Medical</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="description">Course Description</Label>
                <Textarea id="description" placeholder="Brief description of the course..." rows={4} />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Clock className="h-5 w-5" />
                Duration & Schedule
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-3">
                <div className="space-y-2">
                  <Label htmlFor="duration">Duration *</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="Select duration" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="3months">3 Months</SelectItem>
                      <SelectItem value="6months">6 Months</SelectItem>
                      <SelectItem value="1year">1 Year</SelectItem>
                      <SelectItem value="2years">2 Years</SelectItem>
                      <SelectItem value="3years">3 Years</SelectItem>
                      <SelectItem value="4years">4 Years</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="semesters">Semesters</Label>
                  <Input id="semesters" type="number" placeholder="e.g., 8" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="credits">Total Credits</Label>
                  <Input id="credits" type="number" placeholder="e.g., 180" />
                </div>
              </div>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="startMonth">Typical Start Month</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="Select month" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="january">January</SelectItem>
                      <SelectItem value="april">April</SelectItem>
                      <SelectItem value="july">July</SelectItem>
                      <SelectItem value="october">October</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="hoursPerWeek">Hours Per Week</Label>
                  <Input id="hoursPerWeek" type="number" placeholder="e.g., 25" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <IndianRupee className="h-5 w-5" />
                Fee Structure
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="annualFee">Annual Fee *</Label>
                  <Input id="annualFee" type="number" placeholder="e.g., 50000" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="admissionFee">Admission Fee</Label>
                  <Input id="admissionFee" type="number" placeholder="e.g., 5000" />
                </div>
              </div>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="examFee">Exam Fee (Per Semester)</Label>
                  <Input id="examFee" type="number" placeholder="e.g., 2000" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="labFee">Lab Fee (If Applicable)</Label>
                  <Input id="labFee" type="number" placeholder="e.g., 3000" />
                </div>
              </div>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="reExamFee">Re-Exam Fee</Label>
                  <Input id="reExamFee" type="number" placeholder="e.g., 500" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="reAdmissionFee">Re-Admission Fee</Label>
                  <Input id="reAdmissionFee" type="number" placeholder="e.g., 2500" />
                </div>
              </div>
              <div className="space-y-2">
                <Label>Fee Payment Options</Label>
                <div className="flex flex-wrap gap-4">
                  <div className="flex items-center gap-2">
                    <Switch id="yearly" defaultChecked />
                    <Label htmlFor="yearly">Yearly</Label>
                  </div>
                  <div className="flex items-center gap-2">
                    <Switch id="semester" defaultChecked />
                    <Label htmlFor="semester">Semester-wise</Label>
                  </div>
                  <div className="flex items-center gap-2">
                    <Switch id="monthly" />
                    <Label htmlFor="monthly">Monthly</Label>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <BookOpen className="h-5 w-5" />
                Course Subjects
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-3">
                <Label>Select Subjects</Label>
                <div className="grid grid-cols-2 gap-2">
                  {["Mathematics", "Physics", "Chemistry", "Biology", "English", "History", "Geography", "Computer Info"].map((subject) => (
                    <div key={subject} className="flex items-center gap-2">
                      <Switch id={subject} />
                      <Label htmlFor={subject} className="text-sm font-normal cursor-pointer">{subject}</Label>
                    </div>
                  ))}
                </div>
              </div>
              <div className="space-y-2 pt-2 border-t">
                <Label htmlFor="otherSubjects">Other Subjects</Label>
                <Textarea id="otherSubjects" placeholder="Enter other subjects separated by commas" rows={2} />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Settings className="h-5 w-5" />
                Course Settings
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <Label>Active Status</Label>
                  <p className="text-xs text-muted-foreground">Enable/disable course</p>
                </div>
                <Switch defaultChecked />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <Label>Allow Enrollment</Label>
                  <p className="text-xs text-muted-foreground">Accept new students</p>
                </div>
                <Switch defaultChecked />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <Label>Online Available</Label>
                  <p className="text-xs text-muted-foreground">Show on website</p>
                </div>
                <Switch defaultChecked />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <Label>Certificate Course</Label>
                  <p className="text-xs text-muted-foreground">Issue completion certificate</p>
                </div>
                <Switch />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Eligibility Criteria</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="minQualification">Minimum Qualification</Label>
                <Select>
                  <SelectTrigger>
                    <SelectValue placeholder="Select qualification" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="10th">10th Pass</SelectItem>
                    <SelectItem value="12th">12th Pass</SelectItem>
                    <SelectItem value="graduate">Graduate</SelectItem>
                    <SelectItem value="postgraduate">Post Graduate</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label htmlFor="minMarks">Minimum Marks (%)</Label>
                <Input id="minMarks" type="number" placeholder="e.g., 50" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="minAge">Minimum Age</Label>
                <Input id="minAge" type="number" placeholder="e.g., 17" />
              </div>
              <div className="space-y-2">
                <Label htmlFor="maxAge">Maximum Age</Label>
                <Input id="maxAge" type="number" placeholder="e.g., 25" />
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      <div className="flex justify-end gap-3 mt-6">
        <Button variant="outline">Cancel</Button>
        <Button variant="outline">Save as Draft</Button>
        <Button>Create Course</Button>
      </div>
    </AppLayout>
  );
}
