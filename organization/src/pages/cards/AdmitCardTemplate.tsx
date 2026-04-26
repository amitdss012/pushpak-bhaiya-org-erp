import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
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
  LayoutTemplate,
  Type,
  Image,
  QrCode,
  Table,
  GripVertical,
} from "lucide-react";

const savedTemplates = [
  { id: "1", name: "Mid-Term Exam 2024", exam: "Mid-Term", status: "active" },
  { id: "2", name: "Final Exam 2024", exam: "Final", status: "draft" },
  { id: "3", name: "Unit Test Template", exam: "Unit Test", status: "active" },
];

const fieldElements = [
  { icon: Type, label: "Student Name", type: "text" },
  { icon: Type, label: "Roll Number", type: "text" },
  { icon: Type, label: "Class & Section", type: "text" },
  { icon: Type, label: "Exam Name", type: "text" },
  { icon: Type, label: "Exam Date", type: "text" },
  { icon: Image, label: "Student Photo", type: "image" },
  { icon: Image, label: "School Logo", type: "image" },
  { icon: QrCode, label: "QR Code", type: "qr" },
  { icon: Table, label: "Exam Schedule", type: "table" },
  { icon: Type, label: "Instructions", type: "textarea" },
];

export default function AdmitCardTemplate() {
  return (
    <AppLayout>
      <PageHeader
        title="Admit Card Template"
        description="Design admit card templates for examinations"
        breadcrumbs={[
          { label: "ID & Admit Card", href: "/cards/id-template" },
          { label: "Admit Card Template" },
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
                  <SelectItem value="a5">A5 Size</SelectItem>
                  <SelectItem value="letter">Letter</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </CardHeader>
          <CardContent>
            <div className="border-2 border-dashed rounded-lg p-4 min-h-[600px] bg-background">
              {/* Admit Card Preview */}
              <div className="border rounded-lg p-6 bg-card shadow-sm max-w-md mx-auto">
                <div className="text-center border-b pb-4 mb-4">
                  <div className="w-16 h-16 bg-muted rounded-full mx-auto mb-2 flex items-center justify-center">
                    <Image className="h-8 w-8 text-muted-foreground" />
                  </div>
                  <h2 className="font-bold text-lg">School Name Here</h2>
                  <p className="text-xs text-muted-foreground">School Address, City - PIN</p>
                </div>

                <div className="text-center mb-4">
                  <Badge variant="outline" className="text-sm">ADMIT CARD</Badge>
                  <h3 className="font-semibold mt-2">Mid-Term Examination 2024</h3>
                </div>

                <div className="flex gap-4 mb-4">
                  <div className="w-24 h-28 bg-muted rounded border flex items-center justify-center">
                    <Image className="h-8 w-8 text-muted-foreground" />
                  </div>
                  <div className="flex-1 space-y-2 text-sm">
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Name:</span>
                      <span className="font-medium">Student Name</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Roll No:</span>
                      <span className="font-medium">101</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">Class:</span>
                      <span className="font-medium">10th - A</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-muted-foreground">DOB:</span>
                      <span className="font-medium">01/01/2010</span>
                    </div>
                  </div>
                </div>

                <div className="border rounded p-3 mb-4">
                  <h4 className="text-xs font-semibold mb-2">EXAM SCHEDULE</h4>
                  <div className="text-xs space-y-1">
                    <div className="flex justify-between">
                      <span>Mathematics</span>
                      <span>15 Jan, 9:00 AM</span>
                    </div>
                    <div className="flex justify-between">
                      <span>Science</span>
                      <span>16 Jan, 9:00 AM</span>
                    </div>
                    <div className="flex justify-between">
                      <span>English</span>
                      <span>17 Jan, 9:00 AM</span>
                    </div>
                  </div>
                </div>

                <div className="flex justify-between items-end pt-4 border-t">
                  <div className="w-16 h-16 border rounded flex items-center justify-center">
                    <QrCode className="h-8 w-8 text-muted-foreground" />
                  </div>
                  <div className="text-center">
                    <div className="w-24 border-t border-foreground mb-1"></div>
                    <span className="text-xs">Principal's Signature</span>
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Right Panel - Properties & Saved Templates */}
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
                    <SelectItem value="midterm">Mid-Term Exam</SelectItem>
                    <SelectItem value="final">Final Exam</SelectItem>
                    <SelectItem value="unit">Unit Test</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="flex items-center justify-between">
                <Label>Show QR Code</Label>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show Photo</Label>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show Schedule</Label>
                <Switch defaultChecked />
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
