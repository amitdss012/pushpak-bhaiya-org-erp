import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { User, GraduationCap, Users, FileText, CreditCard, Upload, CheckCircle } from "lucide-react";

export default function StudentAdmissionForm() {
  return (
    <AppLayout>
      <PageHeader
        title="Student Admission Form"
        description="Complete admission application form"
        breadcrumbs={[
          { label: "Student Management", href: "/student/view" },
          { label: "Admission Form" },
        ]}
      />

      <Card className="mb-6">
        <CardContent className="p-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <Badge variant="outline" className="text-lg px-4 py-1">Application No: APP2024006</Badge>
              <Badge variant="secondary">Draft</Badge>
            </div>
            <div className="text-sm text-muted-foreground">
              Started: January 15, 2024
            </div>
          </div>
        </CardContent>
      </Card>

      <Tabs defaultValue="personal" className="space-y-6">
        <TabsList className="grid w-full max-w-3xl grid-cols-5">
          <TabsTrigger value="personal" className="gap-2">
            <User className="h-4 w-4" />
            Personal
          </TabsTrigger>
          <TabsTrigger value="academic" className="gap-2">
            <GraduationCap className="h-4 w-4" />
            Academic
          </TabsTrigger>
          <TabsTrigger value="guardian" className="gap-2">
            <Users className="h-4 w-4" />
            Guardian
          </TabsTrigger>
          <TabsTrigger value="documents" className="gap-2">
            <FileText className="h-4 w-4" />
            Documents
          </TabsTrigger>
          <TabsTrigger value="payment" className="gap-2">
            <CreditCard className="h-4 w-4" />
            Payment
          </TabsTrigger>
        </TabsList>

        <TabsContent value="personal">
          <Card>
            <CardHeader>
              <CardTitle>Personal Information</CardTitle>
              <CardDescription>Enter the applicant's personal details</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="flex gap-6">
                <div className="space-y-4 flex-1">
                  <div className="grid gap-4 md:grid-cols-3">
                    <div className="space-y-2">
                      <Label>First Name *</Label>
                      <Input placeholder="First name" />
                    </div>
                    <div className="space-y-2">
                      <Label>Middle Name</Label>
                      <Input placeholder="Middle name" />
                    </div>
                    <div className="space-y-2">
                      <Label>Last Name *</Label>
                      <Input placeholder="Last name" />
                    </div>
                  </div>
                  <div className="grid gap-4 md:grid-cols-3">
                    <div className="space-y-2">
                      <Label>Date of Birth *</Label>
                      <Input type="date" />
                    </div>
                    <div className="space-y-2">
                      <Label>Gender *</Label>
                      <Select>
                        <SelectTrigger>
                          <SelectValue placeholder="Select gender" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="male">Male</SelectItem>
                          <SelectItem value="female">Female</SelectItem>
                          <SelectItem value="other">Other</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="space-y-2">
                      <Label>Blood Group</Label>
                      <Select>
                        <SelectTrigger>
                          <SelectValue placeholder="Select blood group" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="aplus">A+</SelectItem>
                          <SelectItem value="aminus">A-</SelectItem>
                          <SelectItem value="bplus">B+</SelectItem>
                          <SelectItem value="bminus">B-</SelectItem>
                          <SelectItem value="oplus">O+</SelectItem>
                          <SelectItem value="ominus">O-</SelectItem>
                          <SelectItem value="abplus">AB+</SelectItem>
                          <SelectItem value="abminus">AB-</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                  <div className="grid gap-4 md:grid-cols-3">
                    <div className="space-y-2">
                      <Label>Nationality *</Label>
                      <Select>
                        <SelectTrigger>
                          <SelectValue placeholder="Select nationality" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="indian">Indian</SelectItem>
                          <SelectItem value="other">Other</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                    <div className="space-y-2">
                      <Label>Religion</Label>
                      <Input placeholder="Religion" />
                    </div>
                    <div className="space-y-2">
                      <Label>Category</Label>
                      <Select>
                        <SelectTrigger>
                          <SelectValue placeholder="Select category" />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value="general">General</SelectItem>
                          <SelectItem value="obc">OBC</SelectItem>
                          <SelectItem value="sc">SC</SelectItem>
                          <SelectItem value="st">ST</SelectItem>
                          <SelectItem value="ews">EWS</SelectItem>
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                  <div className="grid gap-4 md:grid-cols-3">
                    <div className="space-y-2">
                      <Label>Aadhar Number</Label>
                      <Input placeholder="XXXX XXXX XXXX" />
                    </div>
                    <div className="space-y-2">
                      <Label>APAAR Number</Label>
                      <Input placeholder="Enter APAAR Number" />
                    </div>
                    <div className="space-y-2">
                      <Label>Date of Admission</Label>
                      <Input type="date" />
                    </div>
                  </div>
                </div>
                <div className="w-48">
                  <Label className="mb-2 block">Photo *</Label>
                  <div className="border-2 border-dashed border-border rounded-lg p-6 text-center h-48 flex flex-col items-center justify-center">
                    <Upload className="h-8 w-8 text-muted-foreground mb-2" />
                    <p className="text-xs text-muted-foreground mb-2">Upload photo</p>
                    <Button variant="outline" size="sm">Choose</Button>
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <h4 className="font-medium">Contact Information</h4>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Email Address *</Label>
                    <Input type="email" placeholder="email@example.com" />
                  </div>
                  <div className="space-y-2">
                    <Label>Mobile Number *</Label>
                    <Input placeholder="+91 XXXXX XXXXX" />
                  </div>
                  <div className="space-y-2">
                    <Label>Alternate Number</Label>
                    <Input placeholder="+91 XXXXX XXXXX" />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label>Permanent Address *</Label>
                  <Textarea placeholder="Enter full address" rows={3} />
                </div>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>City *</Label>
                    <Input placeholder="City" />
                  </div>
                  <div className="space-y-2">
                    <Label>State *</Label>
                    <Input placeholder="State" />
                  </div>
                  <div className="space-y-2">
                    <Label>Pincode *</Label>
                    <Input placeholder="Pincode" />
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="academic">
          <Card>
            <CardHeader>
              <CardTitle>Academic Information</CardTitle>
              <CardDescription>Enter course selection and previous education details</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-4">
                <h4 className="font-medium">Course Selection</h4>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Course *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select course" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="cs">Computer Science</SelectItem>
                        <SelectItem value="commerce">Commerce</SelectItem>
                        <SelectItem value="engineering">Engineering</SelectItem>
                        <SelectItem value="arts">Arts</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Batch *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select batch" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="morning">Morning Batch</SelectItem>
                        <SelectItem value="evening">Evening Batch</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Academic Year</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select year" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="2024-25">2024-25</SelectItem>
                        <SelectItem value="2025-26">2025-26</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <h4 className="font-medium">Previous Education - 10th Standard</h4>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>School Name *</Label>
                    <Input placeholder="Previous school name" />
                  </div>
                  <div className="space-y-2">
                    <Label>Board *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select board" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="cbse">CBSE</SelectItem>
                        <SelectItem value="icse">ICSE</SelectItem>
                        <SelectItem value="state">State Board</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Year of Passing *</Label>
                    <Input type="number" placeholder="e.g., 2022" />
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Percentage/CGPA *</Label>
                    <Input placeholder="e.g., 85% or 8.5" />
                  </div>
                  <div className="space-y-2">
                    <Label>Roll Number</Label>
                    <Input placeholder="Roll number" />
                  </div>
                  <div className="space-y-2">
                    <Label>Subjects</Label>
                    <Input placeholder="Main subjects" />
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <h4 className="font-medium">Previous Education - 12th Standard</h4>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>School/College Name</Label>
                    <Input placeholder="School/College name" />
                  </div>
                  <div className="space-y-2">
                    <Label>Board</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select board" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="cbse">CBSE</SelectItem>
                        <SelectItem value="icse">ISC</SelectItem>
                        <SelectItem value="state">State Board</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Year of Passing</Label>
                    <Input type="number" placeholder="e.g., 2024" />
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Percentage/CGPA</Label>
                    <Input placeholder="e.g., 85% or 8.5" />
                  </div>
                  <div className="space-y-2">
                    <Label>Stream</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select stream" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="science">Science</SelectItem>
                        <SelectItem value="commerce">Commerce</SelectItem>
                        <SelectItem value="arts">Arts</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Subjects</Label>
                    <Input placeholder="Main subjects" />
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="guardian">
          <Card>
            <CardHeader>
              <CardTitle>Guardian Information</CardTitle>
              <CardDescription>Enter parent/guardian details</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-4">
                <h4 className="font-medium">Father's Details</h4>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Father's Name *</Label>
                    <Input placeholder="Father's full name" />
                  </div>
                  <div className="space-y-2">
                    <Label>Occupation</Label>
                    <Input placeholder="Occupation" />
                  </div>
                  <div className="space-y-2">
                    <Label>Mobile Number</Label>
                    <Input placeholder="+91 XXXXX XXXXX" />
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Email Address</Label>
                    <Input type="email" placeholder="email@example.com" />
                  </div>
                  <div className="space-y-2">
                    <Label>Annual Income</Label>
                    <Input placeholder="e.g., 500000" />
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <h4 className="font-medium">Mother's Details</h4>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Mother's Name *</Label>
                    <Input placeholder="Mother's full name" />
                  </div>
                  <div className="space-y-2">
                    <Label>Occupation</Label>
                    <Input placeholder="Occupation" />
                  </div>
                  <div className="space-y-2">
                    <Label>Mobile Number</Label>
                    <Input placeholder="+91 XXXXX XXXXX" />
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <h4 className="font-medium">Local Guardian (If different from parents)</h4>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Guardian Name</Label>
                    <Input placeholder="Guardian's full name" />
                  </div>
                  <div className="space-y-2">
                    <Label>Relationship</Label>
                    <Input placeholder="e.g., Uncle, Aunt" />
                  </div>
                  <div className="space-y-2">
                    <Label>Mobile Number</Label>
                    <Input placeholder="+91 XXXXX XXXXX" />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label>Address</Label>
                  <Textarea placeholder="Guardian's address" rows={2} />
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="documents">
          <Card>
            <CardHeader>
              <CardTitle>Document Upload</CardTitle>
              <CardDescription>Upload required documents for admission</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid gap-6 md:grid-cols-2">
                {[
                  { name: "10th Marksheet", required: true, uploaded: true },
                  { name: "12th Marksheet", required: true, uploaded: false },
                  { name: "Transfer Certificate", required: true, uploaded: false },
                  { name: "Aadhar Card", required: true, uploaded: true },
                  { name: "APAAR Card", required: true, uploaded: false },
                  { name: "Caste Certificate", required: false, uploaded: false },
                ].map((doc) => (
                  <div key={doc.name} className="flex items-center justify-between p-4 border rounded-lg">
                    <div className="flex items-center gap-3">
                      {doc.uploaded ? (
                        <CheckCircle className="h-5 w-5 text-success" />
                      ) : (
                        <FileText className="h-5 w-5 text-muted-foreground" />
                      )}
                      <div>
                        <p className="font-medium">{doc.name}</p>
                        <p className="text-xs text-muted-foreground">
                          {doc.required ? "Required" : "Optional"}
                        </p>
                      </div>
                    </div>
                    <Button variant={doc.uploaded ? "outline" : "default"} size="sm">
                      {doc.uploaded ? "Replace" : "Upload"}
                    </Button>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="payment">
          <Card>
            <CardHeader>
              <CardTitle>Fee Payment</CardTitle>
              <CardDescription>Review and pay admission fees</CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              <div className="space-y-4">
                <h4 className="font-medium">Fee Breakdown</h4>
                <div className="border rounded-lg overflow-hidden">
                  <table className="w-full">
                    <thead className="bg-muted">
                      <tr>
                        <th className="p-3 text-left">Fee Type</th>
                        <th className="p-3 text-right">Amount</th>
                      </tr>
                    </thead>
                    <tbody>
                      <tr className="border-t">
                        <td className="p-3">Admission Fee</td>
                        <td className="p-3 text-right">₹5,000</td>
                      </tr>
                      <tr className="border-t">
                        <td className="p-3">Tuition Fee (First Semester)</td>
                        <td className="p-3 text-right">₹25,000</td>
                      </tr>
                      <tr className="border-t">
                        <td className="p-3">Library Fee</td>
                        <td className="p-3 text-right">₹2,000</td>
                      </tr>
                      <tr className="border-t">
                        <td className="p-3">Lab Fee</td>
                        <td className="p-3 text-right">₹3,000</td>
                      </tr>
                      <tr className="border-t bg-muted font-medium">
                        <td className="p-3">Total Amount</td>
                        <td className="p-3 text-right">₹35,000</td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </div>

              <div className="space-y-4">
                <h4 className="font-medium">Payment Method</h4>
                <div className="grid gap-3 md:grid-cols-3">
                  <Card className="cursor-pointer border-2 hover:border-primary transition-colors">
                    <CardContent className="p-4 text-center">
                      <CreditCard className="h-6 w-6 mx-auto mb-2 text-primary" />
                      <p className="font-medium text-sm">Credit/Debit Card</p>
                    </CardContent>
                  </Card>
                  <Card className="cursor-pointer border-2 border-primary">
                    <CardContent className="p-4 text-center">
                      <svg className="h-6 w-6 mx-auto mb-2 text-primary" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z" />
                      </svg>
                      <p className="font-medium text-sm">UPI Payment</p>
                    </CardContent>
                  </Card>
                  <Card className="cursor-pointer border-2 hover:border-primary transition-colors">
                    <CardContent className="p-4 text-center">
                      <svg className="h-6 w-6 mx-auto mb-2 text-primary" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M4 4h16v16H4z" />
                      </svg>
                      <p className="font-medium text-sm">Net Banking</p>
                    </CardContent>
                  </Card>
                </div>
              </div>

              <div className="flex items-center gap-2">
                <Checkbox id="terms" />
                <label htmlFor="terms" className="text-sm">
                  I agree to the terms and conditions and confirm that all information provided is accurate.
                </label>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      <div className="flex justify-between mt-6">
        <Button variant="outline">Save as Draft</Button>
        <div className="flex gap-3">
          <Button variant="outline">Previous</Button>
          <Button>Continue</Button>
        </div>
      </div>
    </AppLayout>
  );
}
