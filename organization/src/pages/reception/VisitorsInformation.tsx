import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Users, UserPlus, Clock, LogOut, Eye, Download, Printer, MapPin, Phone } from "lucide-react";
import { useNavigate } from "react-router-dom";

interface Visitor {
  id: string;
  name: string;
  phone: string;
  email: string;
  purpose: string;
  personToMeet: string;
  department: string;
  checkIn: string;
  checkOut: string | null;
  status: "active" | "completed" | "pending";
  idType: string;
  idNumber: string;
  enquiryReason: string;
  location: string;
  followUpDate: string | null;
}

const visitorsData: Visitor[] = [
  {
    id: "V001",
    name: "Rajesh Kumar",
    phone: "+91 98765 43210",
    email: "rajesh.k@email.com",
    purpose: "Admission Enquiry",
    personToMeet: "Principal",
    department: "Administration",
    checkIn: "2024-01-24 09:30",
    checkOut: "2024-01-24 10:45",
    status: "completed",
    idType: "Aadhar Card",
    idNumber: "XXXX-XXXX-1234",
    enquiryReason: "Looking for admission in Class 10 for son",
    location: "Mumbai, Maharashtra",
    followUpDate: "2024-01-28",
  },
  {
    id: "V002",
    name: "Priya Sharma",
    phone: "+91 98765 43211",
    email: "priya.s@email.com",
    purpose: "Fee Related",
    personToMeet: "Accounts Dept",
    department: "Accounts",
    checkIn: "2024-01-24 10:00",
    checkOut: null,
    status: "active",
    idType: "PAN Card",
    idNumber: "ABCDE1234F",
    enquiryReason: "Fee discount enquiry for scholarship",
    location: "Pune, Maharashtra",
    followUpDate: "2024-01-26",
  },
  {
    id: "V003",
    name: "Amit Patel",
    phone: "+91 98765 43212",
    email: "amit.p@email.com",
    purpose: "Meeting",
    personToMeet: "Admin Officer",
    department: "Administration",
    checkIn: "2024-01-24 11:15",
    checkOut: null,
    status: "active",
    idType: "Driving License",
    idNumber: "DL-XXXX-1234",
    enquiryReason: "Discussion about school infrastructure project",
    location: "Delhi",
    followUpDate: null,
  },
  {
    id: "V004",
    name: "Sunita Verma",
    phone: "+91 98765 43213",
    email: "sunita.v@email.com",
    purpose: "Complaint",
    personToMeet: "Counselor",
    department: "Academics",
    checkIn: "2024-01-24 09:00",
    checkOut: "2024-01-24 09:45",
    status: "completed",
    idType: "Voter ID",
    idNumber: "ABC1234567",
    enquiryReason: "Complaint regarding student behavior issue",
    location: "Thane, Maharashtra",
    followUpDate: "2024-01-30",
  },
  {
    id: "V005",
    name: "Vikram Singh",
    phone: "+91 98765 43214",
    email: "vikram.s@email.com",
    purpose: "Delivery",
    personToMeet: "Other Staff",
    department: "Administration",
    checkIn: "2024-01-24 12:00",
    checkOut: "2024-01-24 12:15",
    status: "completed",
    idType: "Aadhar Card",
    idNumber: "XXXX-XXXX-5678",
    enquiryReason: "Stationery delivery for office",
    location: "Navi Mumbai",
    followUpDate: null,
  },
  {
    id: "V006",
    name: "Meera Joshi",
    phone: "+91 98765 43215",
    email: "meera.j@email.com",
    purpose: "Interview",
    personToMeet: "HR Department",
    department: "Human Resources",
    checkIn: "2024-01-24 14:00",
    checkOut: null,
    status: "pending",
    idType: "Passport",
    idNumber: "J1234567",
    enquiryReason: "Teacher position interview",
    location: "Bangalore, Karnataka",
    followUpDate: "2024-01-25",
  },
];

const columns: Column<Visitor>[] = [
  {
    key: "name",
    header: "Visitor",
    sortable: true,
    cell: (visitor) => (
      <div className="flex items-center gap-3">
        <Avatar className="h-9 w-9">
          <AvatarFallback className="bg-primary/10 text-primary text-sm">
            {visitor.name.split(" ").map((n) => n[0]).join("")}
          </AvatarFallback>
        </Avatar>
        <div>
          <p className="font-medium">{visitor.name}</p>
          <p className="text-xs text-muted-foreground">{visitor.id}</p>
        </div>
      </div>
    ),
  },
  {
    key: "phone",
    header: "Contact",
    cell: (visitor) => (
      <div>
        <p className="text-sm">{visitor.phone}</p>
        <p className="text-xs text-muted-foreground">{visitor.email}</p>
      </div>
    ),
  },
  {
    key: "purpose",
    header: "Purpose",
    sortable: true,
    cell: (visitor) => (
      <Badge variant="secondary">{visitor.purpose}</Badge>
    ),
  },
  {
    key: "location",
    header: "Location",
    sortable: true,
    cell: (visitor) => (
      <div className="flex items-center gap-1.5">
        <MapPin className="h-3.5 w-3.5 text-muted-foreground" />
        <span className="text-sm">{visitor.location}</span>
      </div>
    ),
  },
  {
    key: "personToMeet",
    header: "Person to Meet",
    sortable: true,
  },
  {
    key: "checkIn",
    header: "Check-in",
    sortable: true,
    cell: (visitor) => (
      <div className="flex items-center gap-2">
        <Clock className="h-3.5 w-3.5 text-muted-foreground" />
        <span className="text-sm">
          {new Date(visitor.checkIn).toLocaleTimeString("en-US", {
            hour: "2-digit",
            minute: "2-digit",
          })}
        </span>
      </div>
    ),
  },
  {
    key: "checkOut",
    header: "Check-out",
    cell: (visitor) => (
      visitor.checkOut ? (
        <div className="flex items-center gap-2">
          <LogOut className="h-3.5 w-3.5 text-muted-foreground" />
          <span className="text-sm">
            {new Date(visitor.checkOut).toLocaleTimeString("en-US", {
              hour: "2-digit",
              minute: "2-digit",
            })}
          </span>
        </div>
      ) : (
        <span className="text-xs text-muted-foreground">--</span>
      )
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (visitor) => <StatusBadge status={visitor.status} />,
  },
  {
    key: "followUpDate",
    header: "Follow-up",
    sortable: true,
    cell: (visitor) => (
      visitor.followUpDate ? (
        <div className="flex items-center gap-1.5">
          <Phone className="h-3.5 w-3.5 text-primary" />
          <span className="text-sm">
            {new Date(visitor.followUpDate).toLocaleDateString("en-US", {
              month: "short",
              day: "numeric",
            })}
          </span>
        </div>
      ) : (
        <span className="text-xs text-muted-foreground">--</span>
      )
    ),
  },
];

export default function VisitorsInformation() {
  const navigate = useNavigate();
  const [selectedVisitor, setSelectedVisitor] = useState<Visitor | null>(null);
  const [isCheckoutDialogOpen, setIsCheckoutDialogOpen] = useState(false);
  const [isViewDialogOpen, setIsViewDialogOpen] = useState(false);

  const activeVisitors = visitorsData.filter((v) => v.status === "active").length;
  const completedToday = visitorsData.filter((v) => v.status === "completed").length;
  const totalToday = visitorsData.length;

  const handleCheckout = (visitor: Visitor) => {
    setSelectedVisitor(visitor);
    setIsCheckoutDialogOpen(true);
  };

  const handleView = (visitor: Visitor) => {
    setSelectedVisitor(visitor);
    setIsViewDialogOpen(true);
  };

  const handleActions = (visitor: Visitor) => [
    { label: "View Details", onClick: () => handleView(visitor) },
    ...(visitor.status === "active"
      ? [{ label: "Check Out", onClick: () => handleCheckout(visitor) }]
      : []),
    { label: "Print Pass", onClick: () => console.log("Print", visitor.id) },
    { label: "Edit", onClick: () => console.log("Edit", visitor.id) },
    { label: "Delete", onClick: () => console.log("Delete", visitor.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="Visitors Information"
        description="View and manage all visitor records"
        breadcrumbs={[
          { label: "Reception", href: "/reception/visitors" },
          { label: "Visitors Information" },
        ]}
        actions={
          <>
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Export
            </Button>
            <Button variant="outline" className="gap-2">
              <Printer className="h-4 w-4" />
              Print Report
            </Button>
            <Button onClick={() => navigate("/reception/enquiry")} className="gap-2">
              <UserPlus className="h-4 w-4" />
              New Visitor
            </Button>
          </>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard
          title="Total Visitors Today"
          value={totalToday}
          subtitle="All registered visits"
          icon={Users}
          variant="primary"
        />
        <StatsCard
          title="Currently Inside"
          value={activeVisitors}
          subtitle="Active visitors"
          icon={UserPlus}
          variant="info"
        />
        <StatsCard
          title="Checked Out"
          value={completedToday}
          subtitle="Completed visits"
          icon={LogOut}
          variant="success"
        />
        <StatsCard
          title="Avg. Visit Duration"
          value="45 min"
          subtitle="Today's average"
          icon={Clock}
          variant="warning"
        />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Today's Visitors</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={visitorsData}
            columns={columns}
            selectable
            searchPlaceholder="Search visitors by name, phone, or purpose..."
            actions={handleActions}
          />
        </CardContent>
      </Card>

      {/* Checkout Dialog */}
      <Dialog open={isCheckoutDialogOpen} onOpenChange={setIsCheckoutDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Visitor Check-out</DialogTitle>
          </DialogHeader>
          {selectedVisitor && (
            <div className="space-y-4">
              <div className="flex items-center gap-3 p-4 rounded-lg bg-muted/50">
                <Avatar className="h-12 w-12">
                  <AvatarFallback className="bg-primary/10 text-primary">
                    {selectedVisitor.name.split(" ").map((n) => n[0]).join("")}
                  </AvatarFallback>
                </Avatar>
                <div>
                  <p className="font-medium">{selectedVisitor.name}</p>
                  <p className="text-sm text-muted-foreground">
                    {selectedVisitor.id} • {selectedVisitor.purpose}
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <p className="text-muted-foreground">Check-in Time</p>
                  <p className="font-medium">
                    {new Date(selectedVisitor.checkIn).toLocaleTimeString("en-US", {
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </p>
                </div>
                <div>
                  <p className="text-muted-foreground">Check-out Time</p>
                  <p className="font-medium">
                    {new Date().toLocaleTimeString("en-US", {
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </p>
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="checkoutRemarks">Remarks (Optional)</Label>
                <Textarea
                  id="checkoutRemarks"
                  placeholder="Any notes about the visit..."
                  rows={2}
                />
              </div>
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsCheckoutDialogOpen(false)}>
              Cancel
            </Button>
            <Button onClick={() => setIsCheckoutDialogOpen(false)}>
              Confirm Check-out
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* View Details Dialog */}
      <Dialog open={isViewDialogOpen} onOpenChange={setIsViewDialogOpen}>
        <DialogContent className="sm:max-w-lg">
          <DialogHeader>
            <DialogTitle>Visitor Details</DialogTitle>
          </DialogHeader>
          {selectedVisitor && (
            <div className="space-y-4">
              <div className="flex items-center gap-4 p-4 rounded-lg bg-muted/50">
                <Avatar className="h-16 w-16">
                  <AvatarFallback className="bg-primary/10 text-primary text-xl">
                    {selectedVisitor.name.split(" ").map((n) => n[0]).join("")}
                  </AvatarFallback>
                </Avatar>
                <div>
                  <p className="text-lg font-medium">{selectedVisitor.name}</p>
                  <p className="text-sm text-muted-foreground">{selectedVisitor.phone}</p>
                  <p className="text-sm text-muted-foreground">{selectedVisitor.email}</p>
                </div>
                <StatusBadge status={selectedVisitor.status} className="ml-auto" />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Visitor ID</p>
                  <p className="font-medium">{selectedVisitor.id}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Purpose</p>
                  <p className="font-medium">{selectedVisitor.purpose}</p>
                </div>
                <div className="space-y-1 col-span-2">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Enquiry Reason</p>
                  <p className="font-medium">{selectedVisitor.enquiryReason}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Location</p>
                  <p className="font-medium flex items-center gap-1.5">
                    <MapPin className="h-3.5 w-3.5 text-muted-foreground" />
                    {selectedVisitor.location}
                  </p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Follow-up Date</p>
                  <p className="font-medium flex items-center gap-1.5">
                    {selectedVisitor.followUpDate ? (
                      <>
                        <Phone className="h-3.5 w-3.5 text-primary" />
                        {new Date(selectedVisitor.followUpDate).toLocaleDateString("en-US", {
                          month: "short",
                          day: "numeric",
                          year: "numeric",
                        })}
                      </>
                    ) : (
                      <span className="text-muted-foreground">Not scheduled</span>
                    )}
                  </p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Person to Meet</p>
                  <p className="font-medium">{selectedVisitor.personToMeet}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Department</p>
                  <p className="font-medium">{selectedVisitor.department}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">ID Type</p>
                  <p className="font-medium">{selectedVisitor.idType}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">ID Number</p>
                  <p className="font-medium">{selectedVisitor.idNumber}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Check-in</p>
                  <p className="font-medium">
                    {new Date(selectedVisitor.checkIn).toLocaleString("en-US", {
                      month: "short",
                      day: "numeric",
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Check-out</p>
                  <p className="font-medium">
                    {selectedVisitor.checkOut
                      ? new Date(selectedVisitor.checkOut).toLocaleString("en-US", {
                          month: "short",
                          day: "numeric",
                          hour: "2-digit",
                          minute: "2-digit",
                        })
                      : "Not checked out"}
                  </p>
                </div>
              </div>
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" className="gap-2">
              <Printer className="h-4 w-4" />
              Print Pass
            </Button>
            <Button onClick={() => setIsViewDialogOpen(false)}>Close</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AppLayout>
  );
}
