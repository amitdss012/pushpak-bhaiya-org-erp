import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useToast } from "@/hooks/use-toast";
import { Plus, Eye, Edit, Trash2, Calendar, CheckCircle, Info, Clock, AlertTriangle } from "lucide-react";
import { format } from "date-fns";

interface SessionYear {
  id: string;
  sessionName: string;
  startYear: string;
  endYear: string;
  startDate: string;
  endDate: string;
  status: "active" | "inactive" | "upcoming" | "closed";
  description: string;
  createdDate: string;
}

const sampleSessionYears: SessionYear[] = [
  {
    id: "1",
    sessionName: "Session 2024-2025",
    startYear: "2024",
    endYear: "2025",
    startDate: "2024-04-01",
    endDate: "2025-03-31",
    status: "active",
    description: "Current academic session for the year 2024-25",
    createdDate: "2024-01-15",
  },
  {
    id: "2",
    sessionName: "Session 2023-2024",
    startYear: "2023",
    endYear: "2024",
    startDate: "2023-04-01",
    endDate: "2024-03-31",
    status: "closed",
    description: "Previous academic session completed",
    createdDate: "2023-01-10",
  },
];

const AllSessionYears = () => {
  const { toast } = useToast();
  const [sessionYears, setSessionYears] = useState<SessionYear[]>(sampleSessionYears);
  const [selectedSession, setSelectedSession] = useState<SessionYear | null>(null);
  const [isViewModalOpen, setIsViewModalOpen] = useState(false);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [isCreateModalOpen, setIsCreateModalOpen] = useState(false);
  const [formData, setFormData] = useState<Partial<SessionYear>>({});

  const handleDelete = (id: string) => {
    setSessionYears(prev => prev.filter(s => s.id !== id));
    toast({
      title: "Session Deleted",
      description: "The session year has been removed successfully.",
      variant: "destructive",
    });
  };

  const handleEdit = (session: SessionYear) => {
    setSelectedSession(session);
    setFormData(session);
    setIsEditModalOpen(true);
  };

  const handleView = (session: SessionYear) => {
    setSelectedSession(session);
    setIsViewModalOpen(true);
  };

  const handleUpdate = (e: React.FormEvent) => {
    e.preventDefault();
    setSessionYears(prev =>
      prev.map(s => (s.id === formData.id ? { ...s, ...formData } as SessionYear : s))
    );
    setIsEditModalOpen(false);
    toast({
      title: "Success",
      description: "Session details updated successfully!",
    });
  };

  const handleCreate = (e: React.FormEvent) => {
    e.preventDefault();
    const newSession: SessionYear = {
      ...(formData as SessionYear),
      id: Math.random().toString(36).substr(2, 9),
      createdDate: new Date().toISOString().split("T")[0],
    };
    setSessionYears(prev => [newSession, ...prev]);
    setIsCreateModalOpen(false);
    setFormData({});
    toast({
      title: "Success",
      description: "Academic session created successfully!",
    });
  };

  const handleMakeCurrent = (id: string) => {
    setSessionYears(prev =>
      prev.map(s => ({
        ...s,
        status: s.id === id ? "active" : s.status === "active" ? "closed" : s.status
      }))
    );
    toast({
      title: "Status Updated",
      description: "The selected session is now set as Active.",
    });
  };

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "active": return <Badge className="bg-green-100 text-green-800 border-green-200"><CheckCircle className="mr-1 h-3 w-3" /> Active</Badge>;
      case "closed": return <Badge variant="secondary" className="bg-red-50 text-red-700 border-red-100"><Clock className="mr-1 h-3 w-3" /> Closed</Badge>;
      case "upcoming": return <Badge variant="outline" className="text-blue-600 border-blue-200"><Calendar className="mr-1 h-3 w-3" /> Upcoming</Badge>;
      default: return <Badge variant="outline">{status}</Badge>;
    }
  };

  const columns = [
    { key: "sessionName", header: "Session Name", sortable: true },
    { key: "startYear", header: "Range", cell: (item: SessionYear) => `${item.startYear} - ${item.endYear}` },
    { key: "startDate", header: "Start Date", cell: (item: SessionYear) => format(new Date(item.startDate), "dd MMM yyyy") },
    { key: "endDate", header: "End Date", cell: (item: SessionYear) => format(new Date(item.endDate), "dd MMM yyyy") },
    { key: "status", header: "Status", cell: (item: SessionYear) => getStatusBadge(item.status) },
  ];

  const handleActions = (item: SessionYear) => [
    { label: "View Details", onClick: () => handleView(item) },
    { label: "Edit Session", onClick: () => handleEdit(item) },
    ...(item.status !== "active" ? [{ label: "Make Current", onClick: () => handleMakeCurrent(item.id) }] : []),
    { label: "Delete", onClick: () => handleDelete(item.id), destructive: true }
  ];

  return (
    <AppLayout>
      <div className="container mx-auto p-6">
        <PageHeader
          title="Session Management"
          description="Manage and view academic session years"
          breadcrumbs={[{ label: "Session Year", href: "/session/all" }, { label: "All Sessions" }]}
          actions={
            <Button onClick={() => { setFormData({ status: "upcoming" }); setIsCreateModalOpen(true); }}>
              <Plus className="mr-2 h-4 w-4" />
              Add New Session
            </Button>
          }
        />

        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Total Sessions</CardTitle>
              <Calendar className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{sessionYears.length}</div>
            </CardContent>
          </Card>
          <Card className="border-l-4 border-l-green-500">
            <CardHeader className="flex flex-row items-center justify-between pb-2">
              <CardTitle className="text-sm font-medium">Active Session</CardTitle>
              <CheckCircle className="h-4 w-4 text-green-500" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-green-600">
                 {sessionYears.find(s => s.status === "active")?.sessionName || "None"}
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="mt-8">
          <DataTable
            columns={columns}
            data={sessionYears}
            searchPlaceholder="Search sessions by name or year..."
            actions={handleActions}
          />
        </div>
      </div>

      {/* View Modal */}
      <Dialog open={isViewModalOpen} onOpenChange={setIsViewModalOpen}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Session Details</DialogTitle>
          </DialogHeader>
          {selectedSession && (
            <div className="space-y-4 py-4">
              <div className="flex justify-between items-center border-b pb-2">
                 <span className="text-2xl font-bold">{selectedSession.sessionName}</span>
                 {getStatusBadge(selectedSession.status)}
              </div>
              <div className="grid grid-cols-2 gap-4">
                 <div>
                    <Label className="text-muted-foreground text-xs uppercase">Period</Label>
                    <p className="font-medium text-sm">{format(new Date(selectedSession.startDate), "MMM dd, yyyy")} to {format(new Date(selectedSession.endDate), "MMM dd, yyyy")}</p>
                 </div>
                 <div>
                    <Label className="text-muted-foreground text-xs uppercase">Year Span</Label>
                    <p className="font-medium text-sm">{selectedSession.startYear} - {selectedSession.endYear}</p>
                 </div>
              </div>
              <div className="bg-muted/50 p-3 rounded-lg flex gap-3">
                 <Info className="h-5 w-5 text-primary shrink-0" />
                 <p className="text-sm text-muted-foreground italic">"{selectedSession.description || "No additional description provided for this academic session."}"</p>
              </div>
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsViewModalOpen(false)}>Close</Button>
            <Button onClick={() => { setIsViewModalOpen(false); handleEdit(selectedSession!); }}>Edit Session</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Create/Edit Modal */}
      <Dialog open={isCreateModalOpen || isEditModalOpen} onOpenChange={(open) => { if(!open) { setIsCreateModalOpen(false); setIsEditModalOpen(false); } }}>
        <DialogContent className="max-w-lg">
          <DialogHeader>
            <DialogTitle>{isCreateModalOpen ? "New Session Year" : "Update Session"}</DialogTitle>
          </DialogHeader>
          <form onSubmit={isCreateModalOpen ? handleCreate : handleUpdate} className="space-y-4 py-2">
            <div className="space-y-2">
              <Label htmlFor="sessionName">Session Name *</Label>
              <Input
                id="sessionName"
                value={formData.sessionName || ""}
                onChange={(e) => setFormData({ ...formData, sessionName: e.target.value })}
                placeholder="e.g. Session 2024-2025"
                required
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Start Year</Label>
                <Input value={formData.startYear || ""} onChange={e => setFormData({...formData, startYear: e.target.value})} type="number" />
              </div>
              <div className="space-y-2">
                <Label>End Year</Label>
                <Input value={formData.endYear || ""} onChange={e => setFormData({...formData, endYear: e.target.value})} type="number" />
              </div>
              <div className="space-y-2">
                <Label>Start Date</Label>
                <Input value={formData.startDate || ""} onChange={e => setFormData({...formData, startDate: e.target.value})} type="date" required />
              </div>
              <div className="space-y-2">
                <Label>End Date</Label>
                <Input value={formData.endDate || ""} onChange={e => setFormData({...formData, endDate: e.target.value})} type="date" required />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Status</Label>
              <Select value={formData.status} onValueChange={val => setFormData({...formData, status: val as any})}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="active">Active</SelectItem>
                  <SelectItem value="inactive">Inactive</SelectItem>
                  <SelectItem value="upcoming">Upcoming</SelectItem>
                  <SelectItem value="closed">Closed</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Description</Label>
              <textarea
                className="w-full min-h-[80px] rounded-md border border-input bg-background px-3 py-2 text-sm focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
                value={formData.description || ""}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              />
            </div>
            {formData.status === "active" && (
                <div className="flex items-center gap-2 text-xs bg-yellow-50 text-yellow-700 p-2 rounded border border-yellow-100">
                    <AlertTriangle className="h-4 w-4" />
                    Note: Setting this as Active will automatically close any other active sessions.
                </div>
            )}
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => { setIsCreateModalOpen(false); setIsEditModalOpen(false); }}>Cancel</Button>
              <Button type="submit">{isCreateModalOpen ? "Create Session" : "Update Session"}</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </AppLayout>
  );
};

export default AllSessionYears;

