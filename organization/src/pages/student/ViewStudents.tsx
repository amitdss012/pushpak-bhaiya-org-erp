import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Plus, Download, Upload } from "lucide-react";
import { useNavigate } from "react-router-dom";

interface Student {
  id: string;
  name: string;
  rollNo: string;
  email: string;
  phone: string;
  course: string;
  batch: string;
  status: "active" | "inactive" | "pending";
  admissionDate: string;
  avatar?: string;
}

const studentsData: Student[] = [
  {
    id: "1",
    name: "John Doe",
    rollNo: "STU001",
    email: "john.doe@email.com",
    phone: "+91 98765 43210",
    course: "Computer Science",
    batch: "2024-A",
    status: "active",
    admissionDate: "2024-01-15",
  },
  {
    id: "2",
    name: "Sarah Smith",
    rollNo: "STU002",
    email: "sarah.smith@email.com",
    phone: "+91 98765 43211",
    course: "Commerce",
    batch: "2024-B",
    status: "active",
    admissionDate: "2024-01-18",
  },
  {
    id: "3",
    name: "Mike Johnson",
    rollNo: "STU003",
    email: "mike.j@email.com",
    phone: "+91 98765 43212",
    course: "Arts",
    batch: "2024-A",
    status: "pending",
    admissionDate: "2024-01-20",
  },
  {
    id: "4",
    name: "Emily Brown",
    rollNo: "STU004",
    email: "emily.b@email.com",
    phone: "+91 98765 43213",
    course: "Science",
    batch: "2024-C",
    status: "active",
    admissionDate: "2024-01-22",
  },
  {
    id: "5",
    name: "David Wilson",
    rollNo: "STU005",
    email: "david.w@email.com",
    phone: "+91 98765 43214",
    course: "Engineering",
    batch: "2024-A",
    status: "inactive",
    admissionDate: "2024-01-10",
  },
  {
    id: "6",
    name: "Lisa Anderson",
    rollNo: "STU006",
    email: "lisa.a@email.com",
    phone: "+91 98765 43215",
    course: "Medical",
    batch: "2024-B",
    status: "active",
    admissionDate: "2024-01-25",
  },
  {
    id: "7",
    name: "James Taylor",
    rollNo: "STU007",
    email: "james.t@email.com",
    phone: "+91 98765 43216",
    course: "Computer Science",
    batch: "2024-C",
    status: "active",
    admissionDate: "2024-01-28",
  },
  {
    id: "8",
    name: "Emma Martinez",
    rollNo: "STU008",
    email: "emma.m@email.com",
    phone: "+91 98765 43217",
    course: "Commerce",
    batch: "2024-A",
    status: "pending",
    admissionDate: "2024-02-01",
  },
];

const columns: Column<Student>[] = [
  {
    key: "name",
    header: "Student",
    sortable: true,
    cell: (student) => (
      <div className="flex items-center gap-3">
        <Avatar className="h-9 w-9">
          <AvatarImage src={student.avatar} />
          <AvatarFallback className="bg-primary/10 text-primary text-sm">
            {student.name.split(" ").map((n) => n[0]).join("")}
          </AvatarFallback>
        </Avatar>
        <div>
          <p className="font-medium">{student.name}</p>
          <p className="text-xs text-muted-foreground">{student.rollNo}</p>
        </div>
      </div>
    ),
  },
  {
    key: "email",
    header: "Contact",
    cell: (student) => (
      <div>
        <p className="text-sm">{student.email}</p>
        <p className="text-xs text-muted-foreground">{student.phone}</p>
      </div>
    ),
  },
  {
    key: "course",
    header: "Course",
    sortable: true,
  },
  {
    key: "batch",
    header: "Batch",
    sortable: true,
  },
  {
    key: "admissionDate",
    header: "Admission Date",
    sortable: true,
    cell: (student) => (
      <span className="text-sm">
        {new Date(student.admissionDate).toLocaleDateString("en-US", {
          year: "numeric",
          month: "short",
          day: "numeric",
        })}
      </span>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (student) => <StatusBadge status={student.status} />,
  },
];

export default function ViewStudents() {
  const navigate = useNavigate();

  const handleActions = (student: Student) => [
    { label: "View Details", onClick: () => console.log("View", student.id) },
    { label: "Edit", onClick: () => console.log("Edit", student.id) },
    { label: "Fee Details", onClick: () => console.log("Fee", student.id) },
    { label: "Delete", onClick: () => console.log("Delete", student.id), destructive: true },
  ];

  return (
    <AppLayout>
      <PageHeader
        title="View Students"
        description="Manage and view all enrolled students"
        breadcrumbs={[
          { label: "Student Management", href: "/student/view" },
          { label: "View Students" },
        ]}
        actions={
          <>
            <Button variant="outline" className="gap-2">
              <Upload className="h-4 w-4" />
              Import
            </Button>
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Export
            </Button>
            <Button onClick={() => navigate("/student/add")} className="gap-2">
              <Plus className="h-4 w-4" />
              Add Student
            </Button>
          </>
        }
      />

      <DataTable
        data={studentsData}
        columns={columns}
        selectable
        searchPlaceholder="Search students..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
