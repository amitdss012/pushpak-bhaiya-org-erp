import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useToast } from "@/hooks/use-toast";
import { Calendar, Save, Plus, Edit, Trash2, CheckCircle } from "lucide-react";
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
}

const sampleSessions: SessionYear[] = [
  {
    id: "1",
    sessionName: "Session 2024-2025",
    startYear: "2024",
    endYear: "2025",
    startDate: "2024-04-01",
    endDate: "2025-03-31",
    status: "active",
    description: "Current active session",
  },
];

const AddSessionYear = () => {
  const { toast } = useToast();
  const [sessions, setSessions] = useState<SessionYear[]>(sampleSessions);
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isEditMode, setIsEditMode] = useState(false);
  const [formData, setFormData] = useState<Partial<SessionYear>>({});

  const handleYearChange = (field: string, value: string) => {
    setFormData((prev) => {
      const updated = { ...prev, [field]: value };
      if (updated.startYear && updated.endYear) {
        updated.sessionName = `Session ${updated.startYear}-${updated.endYear}`;
      }
      return updated;
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (isEditMode) {
      setSessions(prev => prev.map(s => s.id === formData.id ? { ...s, ...formData } as SessionYear : s));
      toast({ title: "Updated", description: "Session year updated successfully" });
    } else {
      const newSession: SessionYear = {
        ...(formData as SessionYear),
        id: Math.random().toString(36).substr(2, 9),
      };
      setSessions(prev => [newSession, ...prev]);
      toast({ title: "Success", description: "Session year created successfully" });
    }
    setIsModalOpen(false);
    setFormData({});
  };

  const columns = [
    { key: "sessionName", header: "Session Name", sortable: true },
    { key: "startYear", header: "Range", cell: (item: SessionYear) => `${item.startYear} - ${item.endYear}` },
    { key: "startDate", header: "Start Date", cell: (item: SessionYear) => format(new Date(item.startDate), "dd MMM yyyy") },
    { key: "status", header: "Status", cell: (item: SessionYear) => (
      <Badge variant={item.status === "active" ? "default" : "secondary"}>
        {item.status}
      </Badge>
    )}
  ];

  const currentYear = new Date().getFullYear();
  const yearOptions = Array.from({ length: 10 }, (_, i) => currentYear - 5 + i);

  return (
    <AppLayout>
      <div className="container mx-auto p-6">
        <PageHeader
          title="Session Management"
          description="Create and manage academic session years"
          breadcrumbs={[
            { label: "Session Year", href: "/session/all" },
            { label: "Add & Manage" },
          ]}
          actions={
            <Button onClick={() => { setFormData({ status: "active" }); setIsEditMode(false); setIsModalOpen(true); }}>
              <Plus className="mr-2 h-4 w-4" />
              New Session Year
            </Button>
          }
        />

        <div className="mt-6">
          <DataTable
            columns={columns}
            data={sessions}
            searchPlaceholder="Search sessions..."
            actions={(item) => [
              { label: "Edit Session", onClick: () => { setFormData(item); setIsEditMode(true); setIsModalOpen(true); } },
              { label: "Delete", onClick: () => setSessions(prev => prev.filter(s => s.id !== item.id)), destructive: true }
            ]}
          />
        </div>
      </div>

      <Dialog open={isModalOpen} onOpenChange={setIsModalOpen}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>{isEditMode ? "Edit Session Year" : "Create Session Year"}</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleSubmit} className="space-y-4 py-4">
            <div className="space-y-2">
              <Label>Session Name *</Label>
              <Input value={formData.sessionName || ""} onChange={e => setFormData({...formData, sessionName: e.target.value})} required placeholder="e.g. Session 2024-2025" />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Start Year</Label>
                <Select value={formData.startYear} onValueChange={v => handleYearChange("startYear", v)}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {yearOptions.map(y => <SelectItem key={y} value={y.toString()}>{y}</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
              <div className="space-y-2">
                <Label>End Year</Label>
                <Select value={formData.endYear} onValueChange={v => handleYearChange("endYear", v)}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {yearOptions.map(y => <SelectItem key={y} value={y.toString()}>{y}</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label>Start Date</Label>
                <Input type="date" value={formData.startDate || ""} onChange={e => setFormData({...formData, startDate: e.target.value})} required />
              </div>
              <div className="space-y-2">
                <Label>End Date</Label>
                <Input type="date" value={formData.endDate || ""} onChange={e => setFormData({...formData, endDate: e.target.value})} required />
              </div>
            </div>
            <div className="space-y-2">
              <Label>Status</Label>
              <Select value={formData.status} onValueChange={v => setFormData({...formData, status: v as any})}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="active">Active</SelectItem>
                  <SelectItem value="upcoming">Upcoming</SelectItem>
                  <SelectItem value="closed">Closed</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <DialogFooter className="mt-4">
              <Button type="button" variant="outline" onClick={() => setIsModalOpen(false)}>Cancel</Button>
              <Button type="submit"><Save className="mr-2 h-4 w-4" /> {isEditMode ? "Save Changes" : "Create Session"}</Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>
    </AppLayout>
  );
};

export default AddSessionYear;

