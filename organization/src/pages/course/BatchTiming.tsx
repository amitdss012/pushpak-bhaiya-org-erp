import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Clock, Plus, Edit, Trash2, Calendar } from "lucide-react";
import { useState } from "react";

interface TimingSlot {
  id: string;
  batch: string;
  course: string;
  day: string;
  startTime: string;
  endTime: string;
  subject: string;
  instructor: string;
  room: string;
}

const timingData: TimingSlot[] = [
  { id: "1", batch: "CS-2024-A", course: "Computer Science", day: "Monday", startTime: "09:00", endTime: "10:30", subject: "Data Structures", instructor: "Dr. Smith", room: "Lab 101" },
  { id: "2", batch: "CS-2024-A", course: "Computer Science", day: "Monday", startTime: "10:45", endTime: "12:15", subject: "Algorithms", instructor: "Prof. Johnson", room: "Room 202" },
  { id: "3", batch: "CS-2024-A", course: "Computer Science", day: "Tuesday", startTime: "09:00", endTime: "10:30", subject: "Database Systems", instructor: "Dr. Patel", room: "Lab 102" },
  { id: "4", batch: "CS-2024-A", course: "Computer Science", day: "Tuesday", startTime: "10:45", endTime: "12:15", subject: "Web Development", instructor: "Prof. Kumar", room: "Lab 103" },
  { id: "5", batch: "CS-2024-A", course: "Computer Science", day: "Wednesday", startTime: "09:00", endTime: "10:30", subject: "Operating Systems", instructor: "Dr. Smith", room: "Room 201" },
  { id: "6", batch: "CS-2024-A", course: "Computer Science", day: "Wednesday", startTime: "10:45", endTime: "12:15", subject: "Computer Networks", instructor: "Prof. Johnson", room: "Room 203" },
  { id: "7", batch: "CS-2024-A", course: "Computer Science", day: "Thursday", startTime: "09:00", endTime: "10:30", subject: "Data Structures Lab", instructor: "Dr. Smith", room: "Lab 101" },
  { id: "8", batch: "CS-2024-A", course: "Computer Science", day: "Friday", startTime: "09:00", endTime: "10:30", subject: "Project Work", instructor: "Dr. Patel", room: "Lab 104" },
];

const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
const timeSlots = [
  { start: "09:00", end: "10:30" },
  { start: "10:45", end: "12:15" },
  { start: "13:00", end: "14:30" },
  { start: "14:45", end: "16:15" },
  { start: "16:30", end: "18:00" },
];

export default function BatchTiming() {
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [selectedBatch, setSelectedBatch] = useState("CS-2024-A");

  const getSlotForDayTime = (day: string, start: string, end: string) => {
    return timingData.find(
      (slot) => slot.batch === selectedBatch && slot.day === day && slot.startTime === start && slot.endTime === end
    );
  };

  return (
    <AppLayout>
      <PageHeader
        title="Batch Timing"
        description="Manage batch schedules and timetables"
        breadcrumbs={[
          { label: "Course Management", href: "/course/view" },
          { label: "Batch Timing" },
        ]}
        actions={
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button className="gap-2">
                <Plus className="h-4 w-4" />
                Add Time Slot
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-lg">
              <DialogHeader>
                <DialogTitle>Add Time Slot</DialogTitle>
              </DialogHeader>
              <div className="space-y-4 mt-4">
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Day *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select day" />
                      </SelectTrigger>
                      <SelectContent>
                        {days.map((day) => (
                          <SelectItem key={day} value={day.toLowerCase()}>{day}</SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Subject *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select subject" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="ds">Data Structures</SelectItem>
                        <SelectItem value="algo">Algorithms</SelectItem>
                        <SelectItem value="db">Database Systems</SelectItem>
                        <SelectItem value="web">Web Development</SelectItem>
                        <SelectItem value="os">Operating Systems</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Start Time *</Label>
                    <Input type="time" defaultValue="09:00" />
                  </div>
                  <div className="space-y-2">
                    <Label>End Time *</Label>
                    <Input type="time" defaultValue="10:30" />
                  </div>
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Instructor *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select instructor" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="smith">Dr. Smith</SelectItem>
                        <SelectItem value="johnson">Prof. Johnson</SelectItem>
                        <SelectItem value="patel">Dr. Patel</SelectItem>
                        <SelectItem value="kumar">Prof. Kumar</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label>Room/Lab *</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select room" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="lab101">Lab 101</SelectItem>
                        <SelectItem value="lab102">Lab 102</SelectItem>
                        <SelectItem value="room201">Room 201</SelectItem>
                        <SelectItem value="room202">Room 202</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
                <div className="flex justify-end gap-3 pt-4">
                  <Button variant="outline" onClick={() => setIsDialogOpen(false)}>Cancel</Button>
                  <Button onClick={() => setIsDialogOpen(false)}>Add Slot</Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        }
      />

      <Card className="mb-6">
        <CardContent className="p-4">
          <div className="flex flex-wrap items-center gap-4">
            <div className="space-y-1">
              <Label>Select Branch</Label>
              <Select defaultValue="main">
                <SelectTrigger className="w-48">
                  <SelectValue placeholder="Select branch" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="main">Main Branch</SelectItem>
                  <SelectItem value="north">North Campus</SelectItem>
                  <SelectItem value="south">South Campus</SelectItem>
                  <SelectItem value="east">East Campus</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-1">
              <Label>Select Batch</Label>
              <Select value={selectedBatch} onValueChange={setSelectedBatch}>
                <SelectTrigger className="w-64">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="CS-2024-A">CS-2024-A (Computer Science)</SelectItem>
                  <SelectItem value="CS-2024-B">CS-2024-B (Computer Science)</SelectItem>
                  <SelectItem value="COM-2024-A">COM-2024-A (Commerce)</SelectItem>
                  <SelectItem value="ENG-2024-A">ENG-2024-A (Engineering)</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="flex gap-2 ml-auto">
              <Button variant="outline" className="gap-2">
                <Calendar className="h-4 w-4" />
                Export Schedule
              </Button>
            </div>
          </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Clock className="h-5 w-5" />
            Weekly Timetable - {selectedBatch}
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full border-collapse">
              <thead>
                <tr>
                  <th className="border border-border p-3 bg-muted text-left font-medium">Time</th>
                  {days.map((day) => (
                    <th key={day} className="border border-border p-3 bg-muted text-left font-medium">{day}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {timeSlots.map((slot) => (
                  <tr key={slot.start}>
                    <td className="border border-border p-3 bg-muted/50">
                      <span className="font-medium text-sm">{slot.start}</span>
                      <span className="text-muted-foreground text-sm"> - {slot.end}</span>
                    </td>
                    {days.map((day) => {
                      const timing = getSlotForDayTime(day, slot.start, slot.end);
                      return (
                        <td key={day} className="border border-border p-2 min-w-[150px]">
                          {timing ? (
                            <div className="bg-primary/10 rounded-lg p-2 relative group">
                              <p className="font-medium text-sm text-primary">{timing.subject}</p>
                              <p className="text-xs text-muted-foreground">{timing.instructor}</p>
                              <Badge variant="outline" className="mt-1 text-xs">{timing.room}</Badge>
                              <div className="absolute top-1 right-1 hidden group-hover:flex gap-1">
                                <Button variant="ghost" size="icon" className="h-6 w-6">
                                  <Edit className="h-3 w-3" />
                                </Button>
                                <Button variant="ghost" size="icon" className="h-6 w-6 text-destructive">
                                  <Trash2 className="h-3 w-3" />
                                </Button>
                              </div>
                            </div>
                          ) : (
                            <div className="h-20 flex items-center justify-center text-muted-foreground text-sm">
                              -
                            </div>
                          )}
                        </td>
                      );
                    })}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </AppLayout>
  );
}
