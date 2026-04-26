import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatsCard } from "@/components/ui/StatsCard";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Plus, MessageSquare, UserPlus, Clock, CheckCircle, Phone, Mail } from "lucide-react";
import { useState } from "react";

interface Enquiry {
  id: string;
  date: string;
  name: string;
  phone: string;
  email: string;
  course: string;
  source: string;
  assignedTo: string;
  followUpDate: string;
  status: "new" | "contacted" | "interested" | "converted" | "closed";
  priority: "high" | "medium" | "low";
}

const enquiriesData: Enquiry[] = [
  { id: "1", date: "2024-01-15", name: "Rahul Sharma", phone: "+91 98765 43210", email: "rahul@example.com", course: "Computer Science", source: "Walk-in", assignedTo: "John Doe", followUpDate: "2024-01-18", status: "new", priority: "high" },
  { id: "2", date: "2024-01-15", name: "Priya Patel", phone: "+91 87654 32109", email: "priya@example.com", course: "Commerce", source: "Website", assignedTo: "Jane Smith", followUpDate: "2024-01-17", status: "contacted", priority: "medium" },
  { id: "3", date: "2024-01-14", name: "Amit Kumar", phone: "+91 76543 21098", email: "amit@example.com", course: "Engineering", source: "Referral", assignedTo: "John Doe", followUpDate: "2024-01-16", status: "interested", priority: "high" },
  { id: "4", date: "2024-01-14", name: "Sneha Gupta", phone: "+91 65432 10987", email: "sneha@example.com", course: "Medical", source: "Social Media", assignedTo: "Mike Johnson", followUpDate: "2024-01-19", status: "converted", priority: "medium" },
  { id: "5", date: "2024-01-13", name: "Vikram Singh", phone: "+91 54321 09876", email: "vikram@example.com", course: "Arts", source: "Walk-in", assignedTo: "Jane Smith", followUpDate: "2024-01-15", status: "closed", priority: "low" },
];

const columns: Column<Enquiry>[] = [
  {
    key: "date",
    header: "Date",
    sortable: true,
  },
  {
    key: "name",
    header: "Enquirer",
    cell: (enquiry) => (
      <div>
        <p className="font-medium">{enquiry.name}</p>
        <div className="flex items-center gap-2 text-xs text-muted-foreground">
          <Phone className="h-3 w-3" />
          {enquiry.phone}
        </div>
      </div>
    ),
  },
  {
    key: "course",
    header: "Course Interest",
    cell: (enquiry) => <Badge variant="outline">{enquiry.course}</Badge>,
  },
  {
    key: "source",
    header: "Source",
    cell: (enquiry) => <Badge variant="secondary">{enquiry.source}</Badge>,
  },
  {
    key: "assignedTo",
    header: "Assigned To",
  },
  {
    key: "followUpDate",
    header: "Follow-up",
    sortable: true,
    cell: (enquiry) => (
      <span className={new Date(enquiry.followUpDate) < new Date() ? "text-destructive" : ""}>
        {enquiry.followUpDate}
      </span>
    ),
  },
  {
    key: "priority",
    header: "Priority",
    cell: (enquiry) => (
      <Badge variant={enquiry.priority === "high" ? "destructive" : enquiry.priority === "medium" ? "default" : "secondary"}>
        {enquiry.priority}
      </Badge>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (enquiry) => <StatusBadge status={enquiry.status} />,
  },
];

export default function BranchEnquiry() {
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  const handleActions = (enquiry: Enquiry) => [
    { label: "View Details", onClick: () => console.log("View", enquiry.id) },
    { label: "Add Follow-up", onClick: () => console.log("Follow-up", enquiry.id) },
    { label: "Convert to Admission", onClick: () => console.log("Convert", enquiry.id) },
    { label: "Mark as Closed", onClick: () => console.log("Close", enquiry.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Branch Enquiries"
        description="Manage all walk-in and phone enquiries"
        breadcrumbs={[
          { label: "Enquiry Management", href: "/enquiry/branch" },
          { label: "Branch Enquiry" },
        ]}
        actions={
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button className="gap-2">
                <Plus className="h-4 w-4" />
                New Enquiry
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl">
              <DialogHeader>
                <DialogTitle>Add New Enquiry</DialogTitle>
              </DialogHeader>
              <div className="space-y-4 mt-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Full Name *</Label>
                    <Input placeholder="Enter full name" />
                  </div>
                  <div className="space-y-2">
                    <Label>Phone Number *</Label>
                    <Input placeholder="+91 XXXXX XXXXX" />
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Email Address</Label>
                    <Input type="email" placeholder="email@example.com" />
                  </div>
                  <div className="space-y-2">
                    <Label>Course Interest *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select course" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="cs">Computer Science</SelectItem>
                        <SelectItem value="commerce">Commerce</SelectItem>
                        <SelectItem value="engineering">Engineering</SelectItem>
                        <SelectItem value="medical">Medical</SelectItem>
                        <SelectItem value="arts">Arts</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-3">
                  <div className="space-y-2">
                    <Label>Source</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select source" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="walkin">Walk-in</SelectItem>
                        <SelectItem value="phone">Phone Call</SelectItem>
                        <SelectItem value="referral">Referral</SelectItem>
                        <SelectItem value="website">Website</SelectItem>
                        <SelectItem value="social">Social Media</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Assigned To</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select staff" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="john">John Doe</SelectItem>
                        <SelectItem value="jane">Jane Smith</SelectItem>
                        <SelectItem value="mike">Mike Johnson</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Priority</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select priority" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="high">High</SelectItem>
                        <SelectItem value="medium">Medium</SelectItem>
                        <SelectItem value="low">Low</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="space-y-2">
                  <Label>Notes</Label>
                  <Textarea placeholder="Add any additional notes..." rows={3} />
                </div>
                <div className="flex justify-end gap-3 pt-4">
                  <Button variant="outline" onClick={() => setIsDialogOpen(false)}>Cancel</Button>
                  <Button onClick={() => setIsDialogOpen(false)}>Save Enquiry</Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        }
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <StatsCard
          title="Total Enquiries"
          value={enquiriesData.length}
          subtitle="This month"
          icon={MessageSquare}
          trend={{ value: 15, isPositive: true }}
        />
        <StatsCard
          title="New Enquiries"
          value={enquiriesData.filter(e => e.status === "new").length}
          subtitle="Pending contact"
          icon={UserPlus}
        />
        <StatsCard
          title="Follow-ups Due"
          value={enquiriesData.filter(e => new Date(e.followUpDate) <= new Date()).length}
          subtitle="Today"
          icon={Clock}
        />
        <StatsCard
          title="Converted"
          value={enquiriesData.filter(e => e.status === "converted").length}
          subtitle="This month"
          icon={CheckCircle}
          trend={{ value: 25, isPositive: true }}
        />
      </div>

      <DataTable
        data={enquiriesData}
        columns={columns}
        searchPlaceholder="Search enquiries..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
