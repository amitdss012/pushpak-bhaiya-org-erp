import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
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
  Award,
  GripVertical,
  Stamp,
} from "lucide-react";

const savedTemplates = [
  { id: "1", name: "Character Certificate", type: "Character", status: "active" },
  { id: "2", name: "Transfer Certificate", type: "Transfer", status: "active" },
  { id: "3", name: "Bonafide Certificate", type: "Bonafide", status: "draft" },
  { id: "4", name: "Merit Certificate", type: "Merit", status: "active" },
];

const fieldElements = [
  { icon: Type, label: "Student Name", type: "text" },
  { icon: Type, label: "Father's Name", type: "text" },
  { icon: Type, label: "Date of Birth", type: "text" },
  { icon: Type, label: "Class & Section", type: "text" },
  { icon: Type, label: "Admission No", type: "text" },
  { icon: Type, label: "Issue Date", type: "text" },
  { icon: Type, label: "Certificate No", type: "text" },
  { icon: Image, label: "Student Photo", type: "image" },
  { icon: Image, label: "School Logo", type: "image" },
  { icon: QrCode, label: "QR Code", type: "qr" },
  { icon: Stamp, label: "School Seal", type: "seal" },
  { icon: Type, label: "Certificate Body", type: "textarea" },
];

const certificateTypes = [
  { value: "character", label: "Character Certificate" },
  { value: "transfer", label: "Transfer Certificate (TC)" },
  { value: "bonafide", label: "Bonafide Certificate" },
  { value: "merit", label: "Merit Certificate" },
  { value: "participation", label: "Participation Certificate" },
  { value: "achievement", label: "Achievement Certificate" },
  { value: "sports", label: "Sports Certificate" },
];

export default function CertificateTemplate() {
  return (
    <AppLayout>
      <PageHeader
        title="Certificate Template"
        description="Design and customize certificate templates"
        breadcrumbs={[
          { label: "Certificate & Marksheet", href: "/certificate/template" },
          { label: "Certificate Template" },
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
            <div className="border-2 border-dashed rounded-lg p-4 min-h-[700px] bg-background">
              {/* Certificate Preview */}
              <div className="border-4 border-double border-primary/30 rounded-lg p-8 bg-gradient-to-b from-card to-muted/20 shadow-sm">
                <div className="text-center mb-6">
                  <div className="flex justify-center mb-4">
                    <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center">
                      <Award className="h-10 w-10 text-muted-foreground" />
                    </div>
                  </div>
                  <h1 className="text-2xl font-bold text-primary">SCHOOL NAME</h1>
                  <p className="text-sm text-muted-foreground">School Address, City, State - PIN</p>
                  <p className="text-xs text-muted-foreground">Phone: +91 XXXXXXXXXX | Email: school@example.com</p>
                </div>

                <div className="text-center mb-8">
                  <div className="inline-block border-b-2 border-primary pb-1">
                    <h2 className="text-xl font-semibold tracking-wider">CHARACTER CERTIFICATE</h2>
                  </div>
                  <p className="text-sm text-muted-foreground mt-2">Certificate No: CC/2024/001</p>
                </div>

                <div className="text-justify leading-relaxed mb-8 px-4">
                  <p className="mb-4">
                    This is to certify that <strong className="text-primary">Student Name</strong>, 
                    Son/Daughter of <strong>Father's Name</strong>, 
                    Date of Birth <strong>01/01/2010</strong>, 
                    was a bonafide student of this institution.
                  </p>
                  <p className="mb-4">
                    He/She was studying in <strong>Class 10th, Section A</strong> during the academic session 
                    <strong> 2023-24</strong> bearing Admission Number <strong>ADM/2020/001</strong>.
                  </p>
                  <p>
                    During his/her stay in this institution, his/her character and conduct were found to be 
                    <strong> Good</strong>. We wish him/her success in all future endeavors.
                  </p>
                </div>

                <div className="flex justify-between items-end px-4">
                  <div className="text-center">
                    <div className="w-20 h-20 border rounded flex items-center justify-center mb-2">
                      <QrCode className="h-12 w-12 text-muted-foreground" />
                    </div>
                    <p className="text-xs text-muted-foreground">Scan to verify</p>
                  </div>

                  <div className="text-center">
                    <p className="text-sm mb-1">Date: _______________</p>
                    <p className="text-xs text-muted-foreground">Issue Date</p>
                  </div>

                  <div className="text-center">
                    <div className="w-16 h-16 border rounded-full flex items-center justify-center mb-2 mx-auto">
                      <Stamp className="h-8 w-8 text-muted-foreground" />
                    </div>
                    <div className="w-28 border-t border-foreground mb-1"></div>
                    <p className="text-xs">Principal's Signature</p>
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
                <Label>Certificate Type</Label>
                <Select>
                  <SelectTrigger>
                    <SelectValue placeholder="Select type" />
                  </SelectTrigger>
                  <SelectContent>
                    {certificateTypes.map((type) => (
                      <SelectItem key={type.value} value={type.value}>
                        {type.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label>Certificate Body</Label>
                <Textarea 
                  placeholder="Enter certificate text with placeholders like {student_name}, {father_name}, etc."
                  rows={4}
                />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show QR Code</Label>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show Photo</Label>
                <Switch />
              </div>

              <div className="flex items-center justify-between">
                <Label>Show School Seal</Label>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between">
                <Label>Decorative Border</Label>
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
                    <p className="text-xs text-muted-foreground">{template.type}</p>
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
