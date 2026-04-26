import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Search, Eye, Download, Calendar, Clock, CheckCircle, XCircle } from "lucide-react";
import { format } from "date-fns";

interface AttendanceRecord {
  id: string;
  employeeId: string;
  employeeName: string;
  department: string;
  date: string;
  punchInTime: string;
  punchOutTime: string;
  punchInPhoto: string;
  punchOutPhoto: string;
  status: "present" | "absent" | "half-day" | "on-leave";
  workingHours: number;
}

// Sample data - replace with actual API data
const sampleAttendanceRecords: AttendanceRecord[] = [
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
    status: "present",
    workingHours: 9,
  },
  {
    id: "2",
    employeeId: "EMP002",
    employeeName: "Sarah Smith",
    department: "HR",
    date: "2024-03-25",
    punchInTime: "2024-03-25 09:15:00",
    punchOutTime: "2024-03-25 18:15:00",
    punchInPhoto: "/photos/punch-in-2.jpg",
    punchOutPhoto: "/photos/punch-out-2.jpg",
    status: "present",
    workingHours: 9,
  },
  {
    id: "3",
    employeeId: "EMP003",
    employeeName: "Mike Johnson",
    department: "Sales",
    date: "2024-03-25",
    punchInTime: "2024-03-25 09:30:00",
    punchOutTime: "",
    punchInPhoto: "/photos/punch-in-3.jpg",
    punchOutPhoto: "",
    status: "half-day",
    workingHours: 4.5,
  },
  {
    id: "4",
    employeeId: "EMP004",
    employeeName: "Emily Davis",
    department: "IT",
    date: "2024-03-25",
    punchInTime: "",
    punchOutTime: "",
    punchInPhoto: "",
    punchOutPhoto: "",
    status: "absent",
    workingHours: 0,
  },
];

const AttendanceReport = () => {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedDate, setSelectedDate] = useState(format(new Date(), "yyyy-MM-dd"));
  const [attendanceRecords] = useState<AttendanceRecord[]>(sampleAttendanceRecords);

  // Calculate summary statistics
  const totalPresent = attendanceRecords.filter(r => r.status === "present").length;
  const totalAbsent = attendanceRecords.filter(r => r.status === "absent").length;
  const totalHalfDay = attendanceRecords.filter(r => r.status === "half-day").length;
  const totalEmployees = attendanceRecords.length;

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "present":
        return <CheckCircle className="h-4 w-4 text-green-600" />;
      case "absent":
        return <XCircle className="h-4 w-4 text-red-600" />;
      case "half-day":
        return <Clock className="h-4 w-4 text-yellow-600" />;
      default:
        return null;
    }
  };

  const getStatusBadgeClass = (status: string) => {
    switch (status) {
      case "present":
        return "bg-green-100 text-green-800";
      case "absent":
        return "bg-red-100 text-red-800";
      case "half-day":
        return "bg-yellow-100 text-yellow-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const columns = [
    {
      key: "employeeId" as keyof AttendanceRecord,
      header: "Employee ID",
    },
    {
      key: "employeeName" as keyof AttendanceRecord,
      header: "Employee Name",
      cell: (item: AttendanceRecord) => (
        <div className="font-medium">{item.employeeName}</div>
      ),
    },
    {
      key: "department" as keyof AttendanceRecord,
      header: "Department",
    },
    {
      key: "punchInTime" as keyof AttendanceRecord,
      header: "Punch In",
      cell: (item: AttendanceRecord) =>
        item.punchInTime ? (
          <div className="flex items-center gap-2">
            <CheckCircle className="h-4 w-4 text-green-600" />
            <span>{format(new Date(item.punchInTime), "hh:mm a")}</span>
          </div>
        ) : (
          <span className="text-muted-foreground">-</span>
        ),
    },
    {
      key: "punchOutTime" as keyof AttendanceRecord,
      header: "Punch Out",
      cell: (item: AttendanceRecord) =>
        item.punchOutTime ? (
          <div className="flex items-center gap-2">
            <CheckCircle className="h-4 w-4 text-green-600" />
            <span>{format(new Date(item.punchOutTime), "hh:mm a")}</span>
          </div>
        ) : (
          <span className="text-muted-foreground">-</span>
        ),
    },
    {
      key: "workingHours" as keyof AttendanceRecord,
      header: "Working Hours",
      cell: (item: AttendanceRecord) => (
        <span className="font-semibold">{item.workingHours > 0 ? `${item.workingHours} hrs` : "-"}</span>
      ),
    },
    {
      key: "status" as keyof AttendanceRecord,
      header: "Status",
      cell: (item: AttendanceRecord) => (
        <div className="flex items-center gap-2">
          {getStatusIcon(item.status)}
          <Badge className={getStatusBadgeClass(item.status)}>
            {item.status.charAt(0).toUpperCase() + item.status.slice(1)}
          </Badge>
        </div>
      ),
    },
    {
      key: "actions",
      header: "Actions",
      cell: (item: AttendanceRecord) => (
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
              View Full Details
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      ),
    },
  ];

  const filteredRecords = attendanceRecords.filter((record) => {
    const matchesSearch =
      record.employeeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      record.employeeId.toLowerCase().includes(searchTerm.toLowerCase()) ||
      record.department.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesDate = record.date === selectedDate;
    
    return matchesSearch && matchesDate;
  });

  return (
    <AppLayout>
      <div className="container mx-auto p-6">
        <PageHeader
          title="Attendance Report"
          description="View and analyze employee attendance records"
          breadcrumbs={[
            { label: "Attendance", href: "/attendance/report" },
            { label: "Attendance Report" },
          ]}
          actions={
            <Button variant="outline">
              <Download className="mr-2 h-4 w-4" />
              Export Report
            </Button>
          }
        />

        {/* Summary Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Employees</CardTitle>
              <Calendar className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{totalEmployees}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Total employees
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Present Today</CardTitle>
              <CheckCircle className="h-4 w-4 text-green-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-green-600">{totalPresent}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Present employees
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Absent Today</CardTitle>
              <XCircle className="h-4 w-4 text-red-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-red-600">{totalAbsent}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Absent employees
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Half Day</CardTitle>
              <Clock className="h-4 w-4 text-yellow-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-yellow-600">{totalHalfDay}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Half-day employees
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Filters and Table */}
        <div className="mt-6 space-y-4">
          <Card>
            <CardHeader>
              <CardTitle>Filter Attendance Records</CardTitle>
            </CardHeader>
            <CardContent>
              <Tabs defaultValue="today" className="space-y-4">
                <TabsList>
                  <TabsTrigger value="today">Today</TabsTrigger>
                  <TabsTrigger value="yesterday">Yesterday</TabsTrigger>
                  <TabsTrigger value="custom">Custom Date</TabsTrigger>
                </TabsList>

                <TabsContent value="custom" className="space-y-4">
                  <div className="flex items-center gap-4">
                    <Input
                      type="date"
                      value={selectedDate}
                      onChange={(e) => setSelectedDate(e.target.value)}
                      className="w-[200px]"
                    />
                  </div>
                </TabsContent>

                <div className="flex items-center gap-2 mt-4">
                  <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      placeholder="Search by employee name, ID, or department..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      className="pl-10"
                    />
                  </div>
                </div>

                <TabsContent value="today" className="space-y-4">
                  <DataTable
                    columns={columns}
                    data={filteredRecords}
                    searchable={false}
                    emptyMessage="No attendance records found for today"
                  />
                </TabsContent>

                <TabsContent value="yesterday" className="space-y-4">
                  <DataTable
                    columns={columns}
                    data={filteredRecords}
                    searchable={false}
                    emptyMessage="No attendance records found for yesterday"
                  />
                </TabsContent>

                <TabsContent value="custom" className="space-y-4">
                  <DataTable
                    columns={columns}
                    data={filteredRecords}
                    searchable={false}
                    emptyMessage="No attendance records found for selected date"
                  />
                </TabsContent>
              </Tabs>
            </CardContent>
          </Card>
        </div>
      </div>
    </AppLayout>
  );
};

export default AttendanceReport;
