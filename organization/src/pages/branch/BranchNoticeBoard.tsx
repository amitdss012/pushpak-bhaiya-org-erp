import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
 import { Plus, Bell, Calendar, Pin, Trash2, Edit, Eye, Users } from "lucide-react";
import { useState } from "react";
 import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

interface Notice {
  id: string;
  title: string;
  content: string;
  branch: string;
   batch?: string;
  priority: "high" | "medium" | "low";
  date: string;
  expiryDate: string;
  isPinned: boolean;
  views: number;
   type: "branch" | "batch";
}

const noticesData: Notice[] = [
   { id: "1", title: "Annual Examination Schedule Released", content: "The annual examination schedule for all courses has been released. Please check the exam portal for detailed timetable.", branch: "All Branches", priority: "high", date: "2024-01-15", expiryDate: "2024-02-15", isPinned: true, views: 1250, type: "branch" },
   { id: "2", title: "Fee Payment Deadline Extended", content: "The last date for fee payment has been extended to January 31st. Late fee will be applicable after this date.", branch: "Main Campus", priority: "high", date: "2024-01-14", expiryDate: "2024-01-31", isPinned: true, views: 890, type: "branch" },
   { id: "3", title: "Republic Day Celebration", content: "All students and staff are invited to attend the Republic Day celebration on January 26th at 8:00 AM in the main auditorium.", branch: "All Branches", priority: "medium", date: "2024-01-13", expiryDate: "2024-01-26", isPinned: false, views: 560, type: "branch" },
   { id: "4", title: "Library Timings Changed", content: "The library will remain open from 8:00 AM to 8:00 PM starting from February 1st.", branch: "North Campus", priority: "low", date: "2024-01-12", expiryDate: "2024-03-01", isPinned: false, views: 320, type: "branch" },
   { id: "5", title: "Practical Lab Session - Batch A", content: "All students of Batch A are required to attend the practical lab session on Monday at 10:00 AM.", branch: "Main Campus", batch: "Batch A - Morning", priority: "high", date: "2024-01-16", expiryDate: "2024-01-20", isPinned: true, views: 180, type: "batch" },
   { id: "6", title: "Project Submission Deadline - Batch B", content: "Final project submission for Batch B is due on January 25th. No extensions will be granted.", branch: "Main Campus", batch: "Batch B - Evening", priority: "high", date: "2024-01-15", expiryDate: "2024-01-25", isPinned: false, views: 145, type: "batch" },
   { id: "7", title: "Extra Classes Scheduled - Batch C", content: "Extra doubt clearing classes scheduled for Batch C on weekends.", branch: "North Campus", batch: "Batch C - Weekend", priority: "medium", date: "2024-01-14", expiryDate: "2024-02-28", isPinned: false, views: 95, type: "batch" },
];
 
 const batches = [
   "All Batches",
   "Batch A - Morning",
   "Batch B - Evening",
   "Batch C - Weekend",
   "Batch D - Online",
 ];

export default function BranchNoticeBoard() {
  const [isDialogOpen, setIsDialogOpen] = useState(false);
   const [noticeType, setNoticeType] = useState<"branch" | "batch">("branch");
 
   const branchNotices = noticesData.filter(n => n.type === "branch");
   const batchNotices = noticesData.filter(n => n.type === "batch");

  const getPriorityColor = (priority: string) => {
    switch (priority) {
      case "high": return "destructive";
      case "medium": return "default";
      case "low": return "secondary";
      default: return "secondary";
    }
  };

  return (
    <AppLayout>
      <PageHeader
        title="Notice Board"
        description="Manage and publish notices across branches"
        breadcrumbs={[
          { label: "Branch Management", href: "/branch/view" },
          { label: "Notice Board" },
        ]}
        actions={
          <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
            <DialogTrigger asChild>
              <Button className="gap-2">
                <Plus className="h-4 w-4" />
                Create Notice
              </Button>
            </DialogTrigger>
            <DialogContent className="max-w-2xl">
              <DialogHeader>
                <DialogTitle>Create New Notice</DialogTitle>
              </DialogHeader>
              <div className="space-y-4 mt-4">
                <div className="space-y-2">
                  <Label htmlFor="title">Notice Title *</Label>
                  <Input id="title" placeholder="Enter notice title" />
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                     <Label>Notice Type</Label>
                     <Select onValueChange={(val) => setNoticeType(val as "branch" | "batch")}>
                       <SelectTrigger>
                         <SelectValue placeholder="Select notice type" />
                       </SelectTrigger>
                       <SelectContent>
                         <SelectItem value="branch">Branch Notice</SelectItem>
                         <SelectItem value="batch">Batch Notice</SelectItem>
                       </SelectContent>
                     </Select>
                   </div>
                   <div className="space-y-2">
                     <Label>Target {noticeType === "branch" ? "Branch" : "Batch"}</Label>
                    <Select>
                      <SelectTrigger>
                         <SelectValue placeholder={`Select ${noticeType}`} />
                      </SelectTrigger>
                      <SelectContent>
                         {noticeType === "branch" ? (
                           <>
                             <SelectItem value="all">All Branches</SelectItem>
                             <SelectItem value="main">Main Campus</SelectItem>
                             <SelectItem value="north">North Campus</SelectItem>
                             <SelectItem value="south">South Campus</SelectItem>
                           </>
                         ) : (
                           batches.map((batch) => (
                             <SelectItem key={batch} value={batch.toLowerCase().replace(/\s/g, '-')}>
                               {batch}
                             </SelectItem>
                           ))
                         )}
                      </SelectContent>
                    </Select>
                  </div>
                 </div>
                 <div className="space-y-2">
                   <Label>Priority</Label>
                    <Select>
                      <SelectTrigger>
                        <SelectValue placeholder="Select priority" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="high">High Priority</SelectItem>
                        <SelectItem value="medium">Medium Priority</SelectItem>
                        <SelectItem value="low">Low Priority</SelectItem>
                      </SelectContent>
                    </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="content">Notice Content *</Label>
                  <Textarea id="content" placeholder="Enter notice content..." rows={5} />
                </div>
                <div className="grid gap-4 md:grid-cols-2">
                  <div className="space-y-2">
                    <Label>Publish Date</Label>
                    <Input type="date" />
                  </div>
                  <div className="space-y-2">
                    <Label>Expiry Date</Label>
                    <Input type="date" />
                  </div>
                </div>
                <div className="flex justify-end gap-3 pt-4">
                  <Button variant="outline" onClick={() => setIsDialogOpen(false)}>Cancel</Button>
                  <Button onClick={() => setIsDialogOpen(false)}>Publish Notice</Button>
                </div>
              </div>
            </DialogContent>
          </Dialog>
        }
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
                <Bell className="h-5 w-5 text-primary" />
              </div>
              <div>
                <p className="text-2xl font-bold">{noticesData.length}</p>
                <p className="text-sm text-muted-foreground">Active Notices</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-destructive/10 flex items-center justify-center">
                <Pin className="h-5 w-5 text-destructive" />
              </div>
              <div>
                <p className="text-2xl font-bold">{noticesData.filter(n => n.isPinned).length}</p>
                <p className="text-sm text-muted-foreground">Pinned Notices</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-warning/10 flex items-center justify-center">
                <Calendar className="h-5 w-5 text-warning" />
              </div>
              <div>
                <p className="text-2xl font-bold">2</p>
                <p className="text-sm text-muted-foreground">Expiring Soon</p>
              </div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="h-10 w-10 rounded-lg bg-success/10 flex items-center justify-center">
                <Eye className="h-5 w-5 text-success" />
              </div>
              <div>
                <p className="text-2xl font-bold">{noticesData.reduce((sum, n) => sum + n.views, 0).toLocaleString()}</p>
                <p className="text-sm text-muted-foreground">Total Views</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

       <Tabs defaultValue="branch" className="w-full">
         <TabsList className="mb-4">
           <TabsTrigger value="branch" className="gap-2">
             <Bell className="h-4 w-4" />
             Branch Notices ({branchNotices.length})
           </TabsTrigger>
           <TabsTrigger value="batch" className="gap-2">
             <Users className="h-4 w-4" />
             Batch Notices ({batchNotices.length})
           </TabsTrigger>
         </TabsList>
         
         <TabsContent value="branch" className="space-y-4">
           {branchNotices.map((notice) => (
             <Card key={notice.id} className={notice.isPinned ? "border-primary/50" : ""}>
               <CardHeader className="pb-2">
                 <div className="flex items-start justify-between">
                   <div className="flex items-center gap-2">
                     {notice.isPinned && <Pin className="h-4 w-4 text-primary" />}
                     <CardTitle className="text-lg">{notice.title}</CardTitle>
                   </div>
                   <div className="flex items-center gap-2">
                     <Badge variant={getPriorityColor(notice.priority) as "destructive" | "default" | "secondary"}>
                       {notice.priority}
                     </Badge>
                     <Badge variant="outline">{notice.branch}</Badge>
                   </div>
                 </div>
               </CardHeader>
               <CardContent>
                 <p className="text-muted-foreground mb-4">{notice.content}</p>
                 <div className="flex items-center justify-between">
                   <div className="flex items-center gap-4 text-sm text-muted-foreground">
                     <span className="flex items-center gap-1">
                       <Calendar className="h-4 w-4" />
                       Published: {notice.date}
                     </span>
                     <span>Expires: {notice.expiryDate}</span>
                     <span className="flex items-center gap-1">
                       <Eye className="h-4 w-4" />
                       {notice.views} views
                     </span>
                   </div>
                   <div className="flex items-center gap-2">
                     <Button variant="ghost" size="icon">
                       <Edit className="h-4 w-4" />
                     </Button>
                     <Button variant="ghost" size="icon">
                       <Trash2 className="h-4 w-4 text-destructive" />
                     </Button>
                   </div>
                 </div>
               </CardContent>
             </Card>
           ))}
         </TabsContent>
         
         <TabsContent value="batch" className="space-y-4">
           {batchNotices.map((notice) => (
             <Card key={notice.id} className={notice.isPinned ? "border-primary/50" : ""}>
               <CardHeader className="pb-2">
                 <div className="flex items-start justify-between">
                   <div className="flex items-center gap-2">
                     {notice.isPinned && <Pin className="h-4 w-4 text-primary" />}
                     <CardTitle className="text-lg">{notice.title}</CardTitle>
                   </div>
                   <div className="flex items-center gap-2">
                     <Badge variant={getPriorityColor(notice.priority) as "destructive" | "default" | "secondary"}>
                       {notice.priority}
                     </Badge>
                     <Badge variant="outline">{notice.batch}</Badge>
                     <Badge variant="secondary">{notice.branch}</Badge>
                   </div>
                 </div>
               </CardHeader>
               <CardContent>
                 <p className="text-muted-foreground mb-4">{notice.content}</p>
                 <div className="flex items-center justify-between">
                   <div className="flex items-center gap-4 text-sm text-muted-foreground">
                     <span className="flex items-center gap-1">
                       <Calendar className="h-4 w-4" />
                       Published: {notice.date}
                     </span>
                     <span>Expires: {notice.expiryDate}</span>
                     <span className="flex items-center gap-1">
                       <Eye className="h-4 w-4" />
                       {notice.views} views
                     </span>
                   </div>
                   <div className="flex items-center gap-2">
                     <Button variant="ghost" size="icon">
                       <Edit className="h-4 w-4" />
                     </Button>
                     <Button variant="ghost" size="icon">
                       <Trash2 className="h-4 w-4 text-destructive" />
                     </Button>
                   </div>
                 </div>
               </CardContent>
             </Card>
           ))}
         </TabsContent>
       </Tabs>
    </AppLayout>
  );
}
