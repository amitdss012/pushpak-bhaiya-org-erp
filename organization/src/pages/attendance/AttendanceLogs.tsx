import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Search, Eye, Download, Filter, Calendar, Clock } from "lucide-react";
import { format, subDays } from "date-fns";

interface AttendanceLog {
  id: string;
  employeeId: string;
  employeeName: string;
  department: string;
  date: string;
  punchInTime: string;
  punchOutTime: string;
  punchInPhoto: string;
  punchOutPhoto: string;
  lateArrival: boolean;
  earlyDeparture: boolean;
  overtime: number;
  remarks: string;
}

// Sample data - replace with actual API data
const sampleAttendanceLogs: AttendanceLog[] = [
  {
    id: "1",
    employeeId: "EMP001",
    employeeName: "John Doe",
    department: "IT",
    date: "2024-03-25",
    punchInTime: "2024-03-25 09:00:00",
    punchOutTime: "2024-03-25 18:00:00",
    punchInPhoto: "/photos/punch-in-1.jpg",
    punchOutPhoto: "/photos/punch-out-1.jpg",
    lateArrival: false,
    earlyDeparture: false,
    overtime: 0,
    remarks: "On time",
  },
  {
    id: "2",
    employeeId: "EMP002",
    employeeName: "Sarah Smith",
    department: "HR",
    date: "2024-03-25",
    punchInTime: "2024-03-25 09:45:00",
    punchOutTime: "2024-03-25 18:30:00",
    punchInPhoto: "/photos/punch-in-2.jpg",
    punchOutPhoto: "/photos/punch-out-2.jpg",
    lateArrival: true,
    earlyDeparture: false,
    overtime: 0.5,
    remarks: "Late arrival by 45 minutes",
  },
  {
    id: "3",
    employeeId: "EMP003",
    employeeName: "Mike Johnson",
    department: "Sales",
    date: "2024-03-24",
    punchInTime: "2024-03-24 08:30:00",
    punchOutTime: "2024-03-24 20:00:00",
    punchInPhoto: "/photos/punch-in-3.jpg",
    punchOutPhoto: "/photos/punch-out-3.jpg",
    lateArrival: false,
    earlyDeparture: false,
    overtime: 2,
    remarks: "Overtime work approved",
  },
  {
    id: "4",
    employeeId: "EMP004",
    employeeName: "Emily Davis",
    department: "IT",
    date: "2024-03-24",
    punchInTime: "2024-03-24 09:00:00",
    punchOutTime: "2024-03-24 17:00:00",
    punchInPhoto: "/photos/punch-in-4.jpg",
    punchOutPhoto: "/photos/punch-out-4.jpg",
    lateArrival: false,
    earlyDeparture: true,
    overtime: 0,
    remarks: "Early departure approved",
  },
];

const AttendanceLogs = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedDepartment, setSelectedDepartment] = useState("all");
  const [dateRange, setDateRange] = useState({
    from: format(subDays(new Date(), 7), "yyyy-MM-dd"),
    to: format(new Date(), "yyyy-MM-dd"),
  });

  const filteredLogs = sampleAttendanceLogs.filter((log) => {
    const matchesSearch =
      log.employeeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      log.employeeId.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesDepartment =
      selectedDepartment === "all" || log.department === selectedDepartment;
    
    const logDate = new Date(log.date);
    const fromDate = new Date(dateRange.from);
    const toDate = new Date(dateRange.to);
    toDate.setHours(23, 59, 59, 999);
    
    const matchesDate = logDate >= fromDate && logDate <= toDate;
    
    return matchesSearch && matchesDepartment && matchesDate;
  });

  const columns = [
    {
      key: "employeeId" as keyof AttendanceLog,
      header: "Employee ID",
    },
    {
      key: "employeeName" as keyof AttendanceLog,
      header: "Employee Name",
      cell: (item: AttendanceLog) => (
        <div className="font-medium">{item.employeeName}</div>
      ),
    },
    {
      key: "department" as keyof AttendanceLog,
      header: "Department",
    },
    {
      key: "date" as keyof AttendanceLog,
      header: "Date",
      cell: (item: AttendanceLog) => format(new Date(item.date), "dd MMM yyyy"),
    },
    {
      key: "punchInTime" as keyof AttendanceLog,
      header: "Punch In",
      cell: (item: AttendanceLog) => (
        <div className="flex items-center gap-2">
          <Clock className="h-4 w-4 text-muted-foreground" />
          <span>{format(new Date(item.punchInTime), "hh:mm a")}</span>
          {item.lateArrival && (
            <Badge variant="destructive" className="text-xs">Late</Badge>
          )}
        </div>
      ),
    },
    {
      key: "punchOutTime" as keyof AttendanceLog,
      header: "Punch Out",
      cell: (item: AttendanceLog) => (
        <div className="flex items-center gap-2">
          <Clock className="h-4 w-4 text-muted-foreground" />
          <span>{format(new Date(item.punchOutTime), "hh:mm a")}</span>
          {item.earlyDeparture && (
            <Badge variant="secondary" className="text-xs">Early</Badge>
          )}
        </div>
      ),
    },
    {
      key: "overtime" as keyof AttendanceLog,
      header: "Overtime",
      cell: (item: AttendanceLog) => (
        <span className={item.overtime > 0 ? "text-green-600 font-semibold" : "text-muted-foreground"}>
          {item.overtime > 0 ? `+${item.overtime} hrs` : "-"}
        </span>
      ),
    },
    {
      key: "remarks" as keyof AttendanceLog,
      header: "Remarks",
      cell: (item: AttendanceLog) => (
        <span className="text-sm text-muted-foreground max-w-[200px] truncate">
          {item.remarks || "-"}
        </span>
      ),
    },
    {
      key: "actions",
      header: "Actions",
      cell: (item: AttendanceLog) => (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-8 w-8 p-0">
              <Eye className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>View Details</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem>
              View Punch In Photo
            </DropdownMenuItem>
            <DropdownMenuItem>
              View Punch Out Photo
            </DropdownMenuItem>
            <DropdownMenuItem>
              View Full Log Details
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      ),
    },
  ];

  return (
    <AppLayout>
      <div className="container mx-auto p-6">
        <PageHeader
          title="Attendance Logs"
          description="View detailed attendance logs and history"
          breadcrumbs={[
            { label: "Attendance", href: "/attendance/logs" },
            { label: "Attendance Logs" },
          ]}
          actions={
            <Button variant="outline">
              <Download className="mr-2 h-4 w-4" />
              Export Logs
            </Button>
          }
        />

        {/* Filters */}
        <Card className="mt-6">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Filter className="h-5 w-5" />
              Filter Attendance Logs
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
              {/* Search */}
              <div className="md:col-span-2 space-y-2">
                <Label htmlFor="search">Search Employee</Label>
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="search"
                    placeholder="Search by name or employee ID..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="pl-10"
                  />
                </div>
              </div>

              {/* Department Filter */}
              <div className="space-y-2">
                <Label htmlFor="department">Department</Label>
                <Select value={selectedDepartment} onValueChange={setSelectedDepartment}>
                  <SelectTrigger id="department">
                    <SelectValue placeholder="All Departments" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Departments</SelectItem>
                    <SelectItem value="IT">IT</SelectItem>
                    <SelectItem value="HR">HR</SelectItem>
                    <SelectItem value="Sales">Sales</SelectItem>
                    <SelectItem value="Finance">Finance</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Date Range */}
              <div className="space-y-2">
                <Label htmlFor="dateRange">Date Range</Label>
                <div className="flex items-center gap-2">
                  <Input
                    id="dateRange"
                    type="date"
                    value={dateRange.from}
                    onChange={(e) => setDateRange({ ...dateRange, from: e.target.value })}
                    className="flex-1"
                  />
                  <span className="text-muted-foreground">to</span>
                  <Input
                    type="date"
                    value={dateRange.to}
                    onChange={(e) => setDateRange({ ...dateRange, to: e.target.value })}
                    className="flex-1"
                  />
                </div>
              </div>
            </div>

            <div className="flex items-center justify-between mt-4 pt-4 border-t">
              <p className="text-sm text-muted-foreground">
                Showing {filteredLogs.length} of {sampleAttendanceLogs.length} records
              </p>
              <Button variant="outline" size="sm">
                <Calendar className="mr-2 h-4 w-4" />
                Clear Filters
              </Button>
            </div>
          </CardContent>
        </Card>

        {/* Data Table */}
        <Card className="mt-6">
          <CardHeader>
            <CardTitle>Detailed Attendance Logs</CardTitle>
          </CardHeader>
          <CardContent>
            <DataTable
              columns={columns}
              data={filteredLogs}
              searchable={false}
              emptyMessage="No attendance logs found for the selected criteria"
            />
          </CardContent>
        </Card>
      </div>
    </AppLayout>
  );
};

export default AttendanceLogs;
