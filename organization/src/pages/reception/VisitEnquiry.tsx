import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Upload, Save, X, UserPlus, Clock, Calendar } from "lucide-react";
import { MapPin, Phone } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useState } from "react";
import { useToast } from "@/hooks/use-toast";

export default function VisitEnquiry() {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    
    // Simulate submission
    setTimeout(() => {
      setIsSubmitting(false);
      toast({
        title: "Visitor Registered",
        description: "Visit enquiry has been successfully recorded.",
      });
    }, 1000);
  };

  return (
    <AppLayout>
      <PageHeader
        title="Visit Enquiry"
        description="Register a new visitor and record their enquiry details"
        breadcrumbs={[
          { label: "Reception", href: "/reception/enquiry" },
          { label: "Visit Enquiry" },
        ]}
      />

      <form onSubmit={handleSubmit}>
        <div className="grid gap-6 lg:grid-cols-3">
          <div className="lg:col-span-2 space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <UserPlus className="h-5 w-5 text-primary" />
                  Visitor Information
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="visitorName">Visitor Name *</Label>
                    <Input id="visitorName" placeholder="Enter full name" required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="phone">Phone Number *</Label>
                    <Input id="phone" placeholder="+91 98765 43210" required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="email">Email Address</Label>
                    <Input id="email" type="email" placeholder="visitor@email.com" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="idType">ID Type</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select ID type" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="aadhar">Aadhar Card</SelectItem>
                        <SelectItem value="pan">PAN Card</SelectItem>
                        <SelectItem value="driving">Driving License</SelectItem>
                        <SelectItem value="passport">Passport</SelectItem>
                        <SelectItem value="voter">Voter ID</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="idNumber">ID Number</Label>
                    <Input id="idNumber" placeholder="Enter ID number" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="company">Organization/Company</Label>
                    <Input id="company" placeholder="Enter organization name" />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="address">Address</Label>
                  <Textarea id="address" placeholder="Enter visitor's address" rows={2} />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Clock className="h-5 w-5 text-primary" />
                  Visit Details
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="visitDate">Visit Date *</Label>
                    <Input id="visitDate" type="date" defaultValue={new Date().toISOString().split('T')[0]} required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="visitTime">Visit Time *</Label>
                    <Input id="visitTime" type="time" defaultValue={new Date().toTimeString().slice(0, 5)} required />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="purpose">Purpose of Visit *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select purpose" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="admission">Admission Enquiry</SelectItem>
                        <SelectItem value="fee">Fee Related</SelectItem>
                        <SelectItem value="meeting">Meeting</SelectItem>
                        <SelectItem value="complaint">Complaint</SelectItem>
                        <SelectItem value="delivery">Delivery</SelectItem>
                        <SelectItem value="interview">Interview</SelectItem>
                        <SelectItem value="other">Other</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="personToMeet">Person to Meet *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select person" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="principal">Principal</SelectItem>
                        <SelectItem value="admin">Admin Officer</SelectItem>
                        <SelectItem value="accounts">Accounts Dept</SelectItem>
                        <SelectItem value="teacher">Class Teacher</SelectItem>
                        <SelectItem value="counselor">Counselor</SelectItem>
                        <SelectItem value="other">Other Staff</SelectItem>
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
                        <SelectItem value="administration">Administration</SelectItem>
                        <SelectItem value="academics">Academics</SelectItem>
                        <SelectItem value="accounts">Accounts</SelectItem>
                        <SelectItem value="hr">Human Resources</SelectItem>
                        <SelectItem value="it">IT Department</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="noOfPersons">Number of Persons</Label>
                    <Input id="noOfPersons" type="number" min="1" defaultValue="1" />
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="enquiryReason">Enquiry Reason</Label>
                    <Textarea id="enquiryReason" placeholder="Describe the reason for enquiry in detail..." rows={2} />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="location">Visitor Location / City</Label>
                    <Input id="location" placeholder="Enter city or area" />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="remarks">Remarks / Notes</Label>
                  <Textarea id="remarks" placeholder="Any additional information about the visit..." rows={3} />
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Phone className="h-5 w-5 text-primary" />
                  Follow-up Details
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label htmlFor="followUpDate">Follow-up Call Date</Label>
                    <Input id="followUpDate" type="date" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="followUpTime">Preferred Time</Label>
                    <Input id="followUpTime" type="time" />
                  </div>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="followUpNotes">Follow-up Notes</Label>
                  <Textarea id="followUpNotes" placeholder="Any notes for the follow-up call..." rows={2} />
                </div>
              </CardContent>
            </Card>
          </div>

          <div className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle>Visitor Photo</CardTitle>
              </CardHeader>
              <CardContent className="flex flex-col items-center gap-4">
                <Avatar className="h-32 w-32">
                  <AvatarFallback className="bg-muted text-muted-foreground">
                    <Upload className="h-10 w-10" />
                  </AvatarFallback>
                </Avatar>
                <Button variant="outline" size="sm" className="gap-2">
                  <Upload className="h-4 w-4" />
                  Capture / Upload Photo
                </Button>
                <p className="text-xs text-muted-foreground text-center">
                  Take a photo using webcam or upload from device
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>Quick Actions</CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                <div className="flex items-center justify-between p-3 rounded-lg bg-muted/50">
                  <div className="flex items-center gap-2">
                    <Calendar className="h-4 w-4 text-primary" />
                    <span className="text-sm">Today's Date</span>
                  </div>
                  <Badge variant="secondary">
                    {new Date().toLocaleDateString("en-US", {
                      month: "short",
                      day: "numeric",
                      year: "numeric",
                    })}
                  </Badge>
                </div>
                <div className="flex items-center justify-between p-3 rounded-lg bg-muted/50">
                  <div className="flex items-center gap-2">
                    <Clock className="h-4 w-4 text-primary" />
                    <span className="text-sm">Check-in Time</span>
                  </div>
                  <Badge variant="secondary">
                    {new Date().toLocaleTimeString("en-US", {
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </Badge>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <CardTitle>ID Document</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="border-2 border-dashed rounded-lg p-6 text-center hover:border-primary/50 transition-colors cursor-pointer">
                  <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
                  <p className="text-sm text-muted-foreground">
                    Upload ID proof
                  </p>
                  <p className="text-xs text-muted-foreground mt-1">
                    JPG, PNG up to 5MB
                  </p>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>

        <div className="flex items-center justify-end gap-4 mt-6 pt-6 border-t">
          <Button type="button" variant="outline" onClick={() => navigate("/reception/visitors")} className="gap-2">
            <X className="h-4 w-4" />
            Cancel
          </Button>
          <Button type="submit" disabled={isSubmitting} className="gap-2">
            <Save className="h-4 w-4" />
            {isSubmitting ? "Registering..." : "Register Visitor"}
          </Button>
        </div>
      </form>
    </AppLayout>
  );
}
