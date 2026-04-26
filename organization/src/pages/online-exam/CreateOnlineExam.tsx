import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Switch } from "@/components/ui/switch";
import { Save, RotateCcw, Monitor, Clock, Shield } from "lucide-react";

export default function CreateOnlineExam() {
  return (
    <AppLayout>
      <PageHeader
        title="Create Online Exam"
        description="Set up a new online examination"
        breadcrumbs={[
          { label: "Online Exam", href: "/online-exam/create" },
          { label: "Create Exam" },
        ]}
      />

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Monitor className="h-5 w-5" />
                Exam Details
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="examTitle">Exam Title *</Label>
                  <Input id="examTitle" placeholder="e.g., Online Mid-Term Test" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="examCode">Exam Code *</Label>
                  <Input id="examCode" placeholder="e.g., OMT-2024-001" />
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
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="description">Description</Label>
                <Textarea 
                  id="description" 
                  placeholder="Enter exam description and instructions..."
                  rows={3}
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Clock className="h-5 w-5" />
                Schedule & Duration
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="startDate">Start Date & Time *</Label>
                  <Input id="startDate" type="datetime-local" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="endDate">End Date & Time *</Label>
                  <Input id="endDate" type="datetime-local" />
                </div>
              </div>

              <div className="grid gap-4 md:grid-cols-3">
                <div className="space-y-2">
                  <Label htmlFor="duration">Duration (minutes) *</Label>
                  <Input id="duration" type="number" placeholder="60" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="totalQuestions">Total Questions *</Label>
                  <Input id="totalQuestions" type="number" placeholder="50" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="totalMarks">Total Marks *</Label>
                  <Input id="totalMarks" type="number" placeholder="100" />
                </div>
              </div>

              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="passingMarks">Passing Marks *</Label>
                  <Input id="passingMarks" type="number" placeholder="35" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="negativeMarking">Negative Marking</Label>
                  <Input id="negativeMarking" type="number" placeholder="0.25" step="0.25" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Shield className="h-5 w-5" />
                Security Settings
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <Label>Shuffle Questions</Label>
                  <p className="text-sm text-muted-foreground">Randomize question order for each student</p>
                </div>
                <Switch defaultChecked />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <Label>Shuffle Options</Label>
                  <p className="text-sm text-muted-foreground">Randomize answer options</p>
                </div>
                <Switch defaultChecked />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <Label>Prevent Tab Switch</Label>
                  <p className="text-sm text-muted-foreground">Warn or submit if student switches tabs</p>
                </div>
                <Switch />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <Label>Full Screen Mode</Label>
                  <p className="text-sm text-muted-foreground">Force full screen during exam</p>
                </div>
                <Switch />
              </div>
              <div className="flex items-center justify-between">
                <div>
                  <Label>Webcam Proctoring</Label>
                  <p className="text-sm text-muted-foreground">Enable webcam monitoring</p>
                </div>
                <Switch />
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle>Question Paper</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label>Question Paper</Label>
                <Select>
                  <SelectTrigger>
                    <SelectValue placeholder="Select question paper" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="qp1">QP-2024-CS-001</SelectItem>
                    <SelectItem value="qp2">QP-2024-CS-002</SelectItem>
                    <SelectItem value="new">Create New</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <Button variant="outline" className="w-full">
                Build Question Paper
              </Button>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Exam Options</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="flex items-center space-x-2">
                <Checkbox id="showResult" defaultChecked />
                <Label htmlFor="showResult" className="font-normal">Show result after submission</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="showAnswers" />
                <Label htmlFor="showAnswers" className="font-normal">Show correct answers</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="allowReview" defaultChecked />
                <Label htmlFor="allowReview" className="font-normal">Allow question review</Label>
              </div>
              <div className="flex items-center space-x-2">
                <Checkbox id="autoSubmit" defaultChecked />
                <Label htmlFor="autoSubmit" className="font-normal">Auto-submit on timeout</Label>
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
