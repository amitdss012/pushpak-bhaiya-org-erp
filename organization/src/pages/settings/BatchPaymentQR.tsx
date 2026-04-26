import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { QrCode, Download, Printer, School, Users } from "lucide-react";

const BatchPaymentQR = () => {
  const batches = [
    { id: 1, name: "Class 10 - A", students: 45, course: "CBSE", qrGenerated: true },
    { id: 2, name: "Class 10 - B", students: 42, course: "CBSE", qrGenerated: true },
    { id: 3, name: "Class 11 - Science", students: 38, course: "Science", qrGenerated: false },
    { id: 4, name: "Class 11 - Commerce", students: 35, course: "Commerce", qrGenerated: false },
    { id: 5, name: "Class 12 - Science", students: 40, course: "Science", qrGenerated: true },
  ];

  return (
    <AppLayout>
      <div className="space-y-6">
        <PageHeader
          title="Batch Payment QR"
          description="Generate batch-specific payment QR codes for fee collection"
          breadcrumbs={[
            { label: "Settings", href: "/settings/general" },
            { label: "Batch Payment QR" },
          ]}
        />

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Configuration */}
          <Card className="lg:col-span-2">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <School className="h-5 w-5" />
                Batch QR Configuration
              </CardTitle>
              <CardDescription>
                Configure QR codes for specific batches or generate in bulk
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label>Select Course</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="All Courses" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">All Courses</SelectItem>
                      <SelectItem value="cbse">CBSE</SelectItem>
                      <SelectItem value="science">Science</SelectItem>
                      <SelectItem value="commerce">Commerce</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-2">
                  <Label>Fee Type</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="Select fee type" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="tuition">Tuition Fee</SelectItem>
                      <SelectItem value="exam">Exam Fee</SelectItem>
                      <SelectItem value="transport">Transport Fee</SelectItem>
                      <SelectItem value="library">Library Fee</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </div>

              <div className="space-y-2">
                <Label>UPI ID Template</Label>
                <Input placeholder="school_{batch_id}@upi" />
                <p className="text-xs text-muted-foreground">
                  Use {"{batch_id}"} as placeholder for batch identifier
                </p>
              </div>

              <div className="flex items-center justify-between p-4 border rounded-lg">
                <div>
                  <p className="font-medium">Include Batch Name in QR</p>
                  <p className="text-sm text-muted-foreground">Add batch name as payment reference</p>
                </div>
                <Switch defaultChecked />
              </div>

              <div className="flex items-center justify-between p-4 border rounded-lg">
                <div>
                  <p className="font-medium">Auto-generate for New Batches</p>
                  <p className="text-sm text-muted-foreground">Automatically create QR when new batch is added</p>
                </div>
                <Switch />
              </div>

              {/* Batch Selection Table */}
              <div className="border rounded-lg">
                <div className="p-4 border-b bg-muted/50">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-2">
                      <Checkbox id="select-all" />
                      <Label htmlFor="select-all" className="font-medium">Select All Batches</Label>
                    </div>
                    <Badge variant="secondary">
                      {batches.length} Batches
                    </Badge>
                  </div>
                </div>
                <div className="divide-y">
                  {batches.map((batch) => (
                    <div key={batch.id} className="flex items-center justify-between p-4">
                      <div className="flex items-center gap-4">
                        <Checkbox id={`batch-${batch.id}`} />
                        <div>
                          <p className="font-medium">{batch.name}</p>
                          <p className="text-sm text-muted-foreground">
                            {batch.course} • {batch.students} students
                          </p>
                        </div>
                      </div>
                      <div className="flex items-center gap-2">
                        {batch.qrGenerated ? (
                          <>
                            <Badge variant="default" className="gap-1">
                              <QrCode className="h-3 w-3" />
                              Generated
                            </Badge>
                            <Button variant="ghost" size="icon">
                              <Download className="h-4 w-4" />
                            </Button>
                          </>
                        ) : (
                          <Badge variant="secondary">Pending</Badge>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <div className="flex gap-2">
                <Button>
                  <QrCode className="h-4 w-4 mr-2" />
                  Generate Selected
                </Button>
                <Button variant="outline">
                  <Printer className="h-4 w-4 mr-2" />
                  Print All QR Codes
                </Button>
              </div>
            </CardContent>
          </Card>

          {/* Stats & Actions */}
          <div className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Users className="h-5 w-5" />
                  Quick Stats
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex justify-between items-center">
                  <span className="text-muted-foreground">Total Batches</span>
                  <span className="font-semibold">{batches.length}</span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-muted-foreground">QR Generated</span>
                  <span className="font-semibold text-primary">
                    {batches.filter(b => b.qrGenerated).length}
                  </span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-muted-foreground">Pending</span>
                  <span className="font-semibold text-orange-600">
                    {batches.filter(b => !b.qrGenerated).length}
                  </span>
                </div>
                <div className="flex justify-between items-center">
                  <span className="text-muted-foreground">Total Students</span>
                  <span className="font-semibold">
                    {batches.reduce((sum, b) => sum + b.students, 0)}
                  </span>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Bulk Actions</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2">
                <Button variant="outline" className="w-full justify-start">
                  <Download className="h-4 w-4 mr-2" />
                  Download All as ZIP
                </Button>
                <Button variant="outline" className="w-full justify-start">
                  <Printer className="h-4 w-4 mr-2" />
                  Print Batch Labels
                </Button>
                <Button variant="outline" className="w-full justify-start text-destructive">
                  Reset All QR Codes
                </Button>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </AppLayout>
  );
};

export default BatchPaymentQR;
