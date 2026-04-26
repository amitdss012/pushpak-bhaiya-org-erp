import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import {
  Plus,
  Save,
  Eye,
  Trash2,
  Copy,
  Type,
  Image,
  QrCode,
  Table,
  GripVertical,
  Stamp,
  BarChart3,
} from "lucide-react";

const savedTemplates = [
  { id: "1", name: "Annual Marksheet 2024", exam: "Annual", status: "active" },
  { id: "2", name: "Mid-Term Report Card", exam: "Mid-Term", status: "active" },
  { id: "3", name: "Semester Marksheet", exam: "Semester", status: "draft" },
];

const fieldElements = [
  { icon: Type, label: "Student Name", type: "text" },
  { icon: Type, label: "Roll Number", type: "text" },
  { icon: Type, label: "Class & Section", type: "text" },
  { icon: Type, label: "Admission No", type: "text" },
  { icon: Type, label: "DOB", type: "text" },
  { icon: Image, label: "Student Photo", type: "image" },
  { icon: Image, label: "School Logo", type: "image" },
  { icon: Table, label: "Marks Table", type: "table" },
  { icon: BarChart3, label: "Grade Summary", type: "chart" },
  { icon: Type, label: "Total Marks", type: "text" },
  { icon: Type, label: "Percentage", type: "text" },
  { icon: Type, label: "Grade", type: "text" },
  { icon: Type, label: "Rank", type: "text" },
  { icon: QrCode, label: "QR Code", type: "qr" },
  { icon: Stamp, label: "School Seal", type: "seal" },
  { icon: Type, label: "Remarks", type: "textarea" },
];

export default function MarksheetTemplate() {
  return (
    <AppLayout>
      <PageHeader
        title="Marksheet Template"
        description="Design and customize marksheet templates"
        breadcrumbs={[
          { label: "Certificate & Marksheet", href: "/certificate/template" },
          { label: "Marksheet Template" },
        ]}
        actions={
          <div className="flex gap-2">
            <Button variant="outline">
              <Eye className="h-4 w-4 mr-2" />
              Preview
            </Button>
            <Button>
              <Save className="h-4 w-4 mr-2" />
              Save Template
            </Button>
          </div>
        }
      />

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Left Panel - Elements */}
        <Card className="lg:col-span-1">
          <CardHeader>
            <CardTitle className="text-lg">Elements</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2">
            {fieldElements.map((element, index) => (
              <div
                key={index}
                className="flex items-center gap-3 p-3 border rounded-lg cursor-move hover:bg-muted/50 transition-colors"
              >
                <GripVertical className="h-4 w-4 text-muted-foreground" />
                <element.icon className="h-4 w-4 text-primary" />
                <span className="text-sm">{element.label}</span>
              </div>
            ))}
            <p className="text-xs text-muted-foreground pt-2">
              Drag elements to the canvas to add them to your template
            </p>
          </CardContent>
        </Card>

        {/* Center - Canvas */}
        <Card className="lg:col-span-2">
          <CardHeader>
            <div className="flex items-center justify-between">
              <CardTitle className="text-lg">Template Canvas</CardTitle>
              <Select defaultValue="a4">
                <SelectTrigger className="w-32">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="a4">A4 Size</SelectItem>
                  <SelectItem value="letter">Letter</SelectItem>
                  <SelectItem value="legal">Legal</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </CardHeader>
          <CardContent>
            <div className="border-2 border-dashed rounded-lg p-4 min-h-[800px] bg-background">
              {/* Marksheet Preview */}
              <div className="border rounded-lg p-6 bg-card shadow-sm">
                {/* Header */}
                <div className="text-center border-b pb-4 mb-4">
                  <div className="flex justify-center mb-2">
                    <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center">
                      <Image className="h-8 w-8 text-muted-foreground" />
                    </div>
                  </div>
                  <h1 className="text-xl font-bold">SCHOOL NAME</h1>
                  <p className="text-xs text-muted-foreground">Affiliated to CBSE, New Delhi</p>
                  <p className="text-xs text-muted-foreground">School Address, City - PIN</p>
                  <div className="mt-2 inline-block border px-4 py-1 rounded">
                    <span className="font-semibold text-sm">ANNUAL EXAMINATION - 2024</span>
                  </div>
                </div>

                {/* Student Info */}
                <div className="flex gap-4 mb-4">
                  <div className="w-24 h-28 bg-muted rounded border flex items-center justify-center flex-shrink-0">
                    <Image className="h-8 w-8 text-muted-foreground" />
                  </div>
                  <div className="flex-1 grid grid-cols-2 gap-2 text-sm">
                    <div>
                      <span className="text-muted-foreground">Name:</span>
                      <span className="ml-2 font-medium">Student Name</span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Roll No:</span>
                      <span className="ml-2 font-medium">101</span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Class:</span>
                      <span className="ml-2 font-medium">10th - A</span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Adm. No:</span>
                      <span className="ml-2 font-medium">ADM/2020/001</span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">DOB:</span>
                      <span className="ml-2 font-medium">01/01/2010</span>
                    </div>
                    <div>
                      <span className="text-muted-foreground">Father:</span>
                      <span className="ml-2 font-medium">Father's Name</span>
                    </div>
                  </div>
                </div>

                {/* Marks Table */}
                <div className="border rounded mb-4 overflow-hidden">
                  <table className="w-full text-sm">
                    <thead className="bg-muted/50">
                      <tr>
                        <th className="p-2 text-left border-r">Subject</th>
                        <th className="p-2 text-center border-r w-16">Max</th>
                        <th className="p-2 text-center border-r w-16">Obt.</th>
                        <th className="p-2 text-center w-16">Grade</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y">
                      <tr>
                        <td className="p-2 border-r">English</td>
                        <td className="p-2 text-center border-r">100</td>
                        <td className="p-2 text-center border-r">85</td>
                        <td className="p-2 text-center">A</td>
                      </tr>
                      <tr>
                        <td className="p-2 border-r">Mathematics</td>
                        <td className="p-2 text-center border-r">100</td>
                        <td className="p-2 text-center border-r">92</td>
                        <td className="p-2 text-center">A+</td>
                      </tr>
                      <tr>
                        <td className="p-2 border-r">Science</td>
                        <td className="p-2 text-center border-r">100</td>
                        <td className="p-2 text-center border-r">88</td>
                        <td className="p-2 text-center">A</td>
                      </tr>
                      <tr>
                        <td className="p-2 border-r">Social Science</td>
                        <td className="p-2 text-center border-r">100</td>
                        <td className="p-2 text-center border-r">78</td>
                        <td className="p-2 text-center">B+</td>
                      </tr>
                      <tr>
                        <td className="p-2 border-r">Hindi</td>
                        <td className="p-2 text-center border-r">100</td>
                        <td className="p-2 text-center border-r">82</td>
                        <td className="p-2 text-center">A</td>
                      </tr>
                      <tr className="bg-muted/30 font-semibold">
                        <td className="p-2 border-r">Total</td>
                        <td className="p-2 text-center border-r">500</td>
                        <td className="p-2 text-center border-r">425</td>
                        <td className="p-2 text-center">A</td>
                      </tr>
                    </tbody>
                  </table>
                </div>

                {/* Summary */}
                <div className="grid grid-cols-4 gap-4 mb-4 text-center">
                  <div className="border rounded p-2">
                    <p className="text-xs text-muted-foreground">Percentage</p>
                    <p className="font-bold text-lg">85%</p>
                  </div>
                  <div className="border rounded p-2">
                    <p className="text-xs text-muted-foreground">Grade</p>
                    <p className="font-bold text-lg">A</p>
                  </div>
                  <div className="border rounded p-2">
                    <p className="text-xs text-muted-foreground">Rank</p>
                    <p className="font-bold text-lg">5</p>
                  </div>
                  <div className="border rounded p-2">
                    <p className="text-xs text-muted-foreground">Result</p>
                    <p className="font-bold text-lg text-green-600">PASS</p>
                  </div>
                </div>

                {/* Footer */}
                <div className="flex justify-between items-end pt-4 border-t">
                  <div className="text-center">
                    <div className="w-16 h-16 border rounded flex items-center justify-center mb-1">
                      <QrCode className="h-10 w-10 text-muted-foreground" />
                    </div>
                    <p className="text-xs text-muted-foreground">Verify</p>
                  </div>
                  <div className="text-center">
                    <div className="w-24 border-t border-foreground mb-1"></div>
                    <p className="text-xs">Class Teacher</p>
                  </div>
                  <div className="text-center">
                    <div className="w-12 h-12 border rounded-full flex items-center justify-center mb-1 mx-auto">
                      <Stamp className="h-6 w-6 text-muted-foreground" />
                    </div>
                    <p className="text-xs">School Seal</p>
                  </div>
                  <div className="text-center">
                    <div className="w-24 border-t border-foreground mb-1"></div>
                    <p className="text-xs">Principal</p>
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Right Panel */}
        <div className="lg:col-span-1 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Properties</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label>Template Name</Label>
                <Input placeholder="Enter template name" />
              </div>

              <div className="space-y-2">
                <Label>Exam Type</Label>
                <Select>
                  <SelectTrigger>
                    <SelectValue placeholder="Select exam" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="annual">Annual Exam</SelectItem>
                    <SelectItem value="midterm">Mid-Term Exam</SelectItem>
                    <SelectItem value="semester">Semester Exam</SelectItem>
                    <SelectItem value="unit">Unit Test</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="flex items-center justify-between">
                <Label>Show Photo</Label>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show Rank</Label>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show QR Code</Label>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show Grade Summary</Label>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show Attendance</Label>
                <Switch />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center justify-between">
                <CardTitle className="text-lg">Saved Templates</CardTitle>
                <Button size="sm" variant="ghost">
                  <Plus className="h-4 w-4" />
                </Button>
              </div>
            </CardHeader>
            <CardContent className="space-y-2">
              {savedTemplates.map((template) => (
                <div
                  key={template.id}
                  className="flex items-center justify-between p-3 border rounded-lg hover:bg-muted/50"
                >
                  <div>
                    <p className="text-sm font-medium">{template.name}</p>
                    <p className="text-xs text-muted-foreground">{template.exam}</p>
                  </div>
                  <div className="flex items-center gap-1">
                    <Badge variant={template.status === "active" ? "default" : "secondary"}>
                      {template.status}
                    </Badge>
                    <Button size="icon" variant="ghost" className="h-7 w-7">
                      <Copy className="h-3 w-3" />
                    </Button>
                    <Button size="icon" variant="ghost" className="h-7 w-7 text-destructive">
                      <Trash2 className="h-3 w-3" />
                    </Button>
                  </div>
                </div>
              ))}
            </CardContent>
          </Card>
        </div>
      </div>
    </AppLayout>
  );
}
