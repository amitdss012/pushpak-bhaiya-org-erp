import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Plus, Video, Users, Calendar, Clock, Play } from "lucide-react";

interface LiveClass {
  id: string;
  title: string;
  subject: string;
  instructor: string;
  course: string;
  batch: string;
  date: string;
  time: string;
  duration: string;
  platform: string;
  attendees: number;
  totalStudents: number;
  status: "scheduled" | "active" | "completed" | "cancelled";
}

const classesData: LiveClass[] = [
  { id: "1", title: "Introduction to Algorithms", subject: "Computer Science", instructor: "Dr. John Smith", course: "Computer Science", batch: "2024-A", date: "2024-01-30", time: "10:00 AM", duration: "1 hour", platform: "Zoom", attendees: 42, totalStudents: 45, status: "active" },
  { id: "2", title: "Organic Chemistry Basics", subject: "Chemistry", instructor: "Prof. Sarah Johnson", course: "Science", batch: "2024-B", date: "2024-01-30", time: "2:00 PM", duration: "1.5 hours", platform: "Google Meet", attendees: 0, totalStudents: 38, status: "scheduled" },
  { id: "3", title: "Financial Accounting", subject: "Accounting", instructor: "Mr. Michael Brown", course: "Commerce", batch: "2024-A", date: "2024-01-29", time: "11:00 AM", duration: "1 hour", platform: "Zoom", attendees: 35, totalStudents: 40, status: "completed" },
  { id: "4", title: "English Literature", subject: "English", instructor: "Ms. Emily Davis", course: "Arts", batch: "2024-C", date: "2024-01-31", time: "3:00 PM", duration: "1 hour", platform: "Microsoft Teams", attendees: 0, totalStudents: 32, status: "scheduled" },
  { id: "5", title: "Physics Lab Session", subject: "Physics", instructor: "Dr. Robert Wilson", course: "Science", batch: "2024-A", date: "2024-01-28", time: "9:00 AM", duration: "2 hours", platform: "Zoom", attendees: 28, totalStudents: 30, status: "completed" },
];

const columns: Column<LiveClass>[] = [
  {
    key: "title",
    header: "Class",
    sortable: true,
    cell: (liveClass) => (
      <div>
        <p className="font-medium">{liveClass.title}</p>
        <p className="text-xs text-muted-foreground">{liveClass.subject}</p>
      </div>
    ),
  },
  {
    key: "instructor",
    header: "Instructor",
    cell: (liveClass) => (
      <div className="flex items-center gap-2">
        <Avatar className="h-7 w-7">
          <AvatarFallback className="text-xs">
            {liveClass.instructor.split(" ").slice(-1)[0][0]}
          </AvatarFallback>
        </Avatar>
        <span className="text-sm">{liveClass.instructor}</span>
      </div>
    ),
  },
  {
    key: "batch",
    header: "Batch",
    cell: (liveClass) => (
      <div>
        <p className="font-medium">{liveClass.batch}</p>
        <p className="text-xs text-muted-foreground">{liveClass.course}</p>
      </div>
    ),
  },
  {
    key: "date",
    header: "Schedule",
    sortable: true,
    cell: (liveClass) => (
      <div className="flex items-center gap-2">
        <Calendar className="h-4 w-4 text-muted-foreground" />
        <div>
          <p className="text-sm">{new Date(liveClass.date).toLocaleDateString()}</p>
          <p className="text-xs text-muted-foreground">{liveClass.time} ({liveClass.duration})</p>
        </div>
      </div>
    ),
  },
  {
    key: "platform",
    header: "Platform",
    cell: (liveClass) => <Badge variant="secondary">{liveClass.platform}</Badge>,
  },
  {
    key: "attendees",
    header: "Attendance",
    cell: (liveClass) => (
      <div className="flex items-center gap-2">
        <Users className="h-4 w-4 text-muted-foreground" />
        <span>{liveClass.attendees}/{liveClass.totalStudents}</span>
      </div>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (liveClass) => <StatusBadge status={liveClass.status} />,
  },
];

export default function ViewLiveClasses() {
  const handleActions = (liveClass: LiveClass) => {
    const actions = [
      { label: "View Details", onClick: () => console.log("View", liveClass.id) },
    ];
    
    if (liveClass.status === "active") {
      actions.unshift({ label: "Join Class", onClick: () => console.log("Join", liveClass.id) });
    }
    if (liveClass.status === "scheduled") {
      actions.push({ label: "Edit", onClick: () => console.log("Edit", liveClass.id) });
      actions.push({ label: "Cancel", onClick: () => console.log("Cancel", liveClass.id) });
    }
    if (liveClass.status === "completed") {
      actions.push({ label: "View Recording", onClick: () => console.log("Recording", liveClass.id) });
      actions.push({ label: "Attendance Report", onClick: () => console.log("Attendance", liveClass.id) });
    }
    
    return actions;
  };

  return (
    <AppLayout>
      <PageHeader
        title="Live Classes"
        description="View and manage live class sessions"
        breadcrumbs={[
          { label: "Live Class", href: "/live-class/view" },
          { label: "View Classes" },
        ]}
        actions={
          <Button className="gap-2">
            <Plus className="h-4 w-4" />
            Schedule Class
          </Button>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard title="Total Classes" value="24" subtitle="This month" icon={Video} variant="primary" />
        <StatsCard title="Live Now" value="2" subtitle="In progress" icon={Play} variant="success" />
        <StatsCard title="Upcoming" value="8" subtitle="Scheduled" icon={Calendar} variant="info" />
        <StatsCard title="Avg. Attendance" value="87%" subtitle="This week" icon={Users} variant="warning" />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Class Schedule</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={classesData}
            columns={columns}
            searchPlaceholder="Search classes..."
            actions={handleActions}
          />
        </CardContent>
      </Card>
    </AppLayout>
  );
}
