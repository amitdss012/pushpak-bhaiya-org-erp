import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Checkbox } from "@/components/ui/checkbox";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";
import { useToast } from "@/hooks/use-toast";
import { Plus, Search, Eye, Edit, Trash2, Shield, Mail, Phone, UserCheck, X } from "lucide-react";
import { Link } from "react-router-dom";

interface User {
  id: string;
  userId: string;
  name: string;
  email: string;
  phone: string;
  role: string;
  department: string;
  status: "active" | "inactive" | "suspended";
  lastLogin: string;
  createdDate: string;
}

// Sample data - replace with actual API data
const sampleUsers: User[] = [
  {
    id: "1",
    userId: "USR001",
    name: "John Doe",
    email: "john.doe@example.com",
    phone: "+91 9876543210",
    role: "Admin",
    department: "IT",
    status: "active",
    lastLogin: "2024-03-25 10:30:00",
    createdDate: "2024-01-15",
  },
  {
    id: "2",
    userId: "USR002",
    name: "Sarah Smith",
    email: "sarah.smith@example.com",
    phone: "+91 9876543211",
    role: "Manager",
    department: "HR",
    status: "active",
    lastLogin: "2024-03-25 09:15:00",
    createdDate: "2024-01-20",
  },
  {
    id: "3",
    userId: "USR003",
    name: "Mike Johnson",
    email: "mike.johnson@example.com",
    phone: "+91 9876543212",
    role: "Employee",
    department: "Sales",
    status: "active",
    lastLogin: "2024-03-24 18:45:00",
    createdDate: "2024-02-01",
  },
  {
    id: "4",
    userId: "USR004",
    name: "Emily Davis",
    email: "emily.davis@example.com",
    phone: "+91 9876543213",
    role: "Employee",
    department: "IT",
    status: "inactive",
    lastLogin: "2024-03-20 14:30:00",
    createdDate: "2024-02-10",
  },
];

const AllUsers = () => {
  const { toast } = useToast();
  const [searchTerm, setSearchTerm] = useState("");
  const [filterRole, setFilterRole] = useState("all");
  const [filterStatus, setFilterStatus] = useState("all");
  const [users] = useState<User[]>(sampleUsers);

  // Dialog states
  const [isViewDialogOpen, setIsViewDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [isRolesDialogOpen, setIsRolesDialogOpen] = useState(false);
  const [selectedUser, setSelectedUser] = useState<User | null>(null);

  const handleDelete = (id: string) => {
    toast({
      title: "User Deleted",
      description: "The user has been removed successfully.",
      variant: "destructive",
    });
  };

  const getStatusBadgeClass = (status: string) => {
    switch (status) {
      case "active":
        return "bg-green-100 text-green-800";
      case "inactive":
        return "bg-gray-100 text-gray-800";
      case "suspended":
        return "bg-red-100 text-red-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const getRoleBadgeClass = (role: string) => {
    switch (role) {
      case "Admin":
        return "bg-purple-100 text-purple-800";
      case "Manager":
        return "bg-blue-100 text-blue-800";
      case "Employee":
        return "bg-gray-100 text-gray-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const columns = [
    {
      key: "userId" as keyof User,
      header: "User ID",
    },
    {
      key: "name" as keyof User,
      header: "Name",
      cell: (item: User) => (
        <div className="font-medium">{item.name}</div>
      ),
    },
    {
      key: "email" as keyof User,
      header: "Email",
      cell: (item: User) => (
        <div className="flex items-center gap-2">
          <Mail className="h-4 w-4 text-muted-foreground" />
          <span>{item.email}</span>
        </div>
      ),
    },
    {
      key: "phone" as keyof User,
      header: "Phone",
      cell: (item: User) => (
        <div className="flex items-center gap-2">
          <Phone className="h-4 w-4 text-muted-foreground" />
          <span>{item.phone}</span>
        </div>
      ),
    },
    {
      key: "role" as keyof User,
      header: "Role",
      cell: (item: User) => (
        <Badge className={getRoleBadgeClass(item.role)}>
          <Shield className="mr-1 h-3 w-3" />
          {item.role}
        </Badge>
      ),
    },
    {
      key: "department" as keyof User,
      header: "Department",
    },
    {
      key: "status" as keyof User,
      header: "Status",
      cell: (item: User) => (
        <Badge className={getStatusBadgeClass(item.status)}>
          <UserCheck className="mr-1 h-3 w-3" />
          {item.status.charAt(0).toUpperCase() + item.status.slice(1)}
        </Badge>
      ),
    },
    {
      key: "actions",
      header: "Actions",
      cell: (item: User) => (
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="h-8 w-8 p-0">
              <Eye className="h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>Actions</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={() => {
              setSelectedUser(item);
              setIsViewDialogOpen(true);
            }}>
              <Eye className="mr-2 h-4 w-4" />
              View Details
            </DropdownMenuItem>
            <DropdownMenuItem onClick={() => {
              setSelectedUser(item);
              setIsEditDialogOpen(true);
            }}>
              <Edit className="mr-2 h-4 w-4" />
              Edit User
            </DropdownMenuItem>
            <DropdownMenuItem onClick={() => {
              setSelectedUser(item);
              setIsRolesDialogOpen(true);
            }}>
              <Shield className="mr-2 h-4 w-4" />
              Manage Roles
            </DropdownMenuItem>
            <DropdownMenuSeparator />
            <DropdownMenuItem
              onClick={() => handleDelete(item.id)}
              className="text-red-600 cursor-pointer"
            >
              <Trash2 className="mr-2 h-4 w-4" />
              Delete User
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      ),
    },
  ];

  const filteredUsers = users.filter((user) => {
    const matchesSearch =
      user.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.userId.toLowerCase().includes(searchTerm.toLowerCase());

    const matchesRole = filterRole === "all" || user.role === filterRole;
    const matchesStatus = filterStatus === "all" || user.status === filterStatus;

    return matchesSearch && matchesRole && matchesStatus;
  });

  // Calculate statistics
  const totalUsers = users.length;
  const activeUsers = users.filter(u => u.status === "active").length;
  const inactiveUsers = users.filter(u => u.status === "inactive").length;
  const adminUsers = users.filter(u => u.role === "Admin").length;

  return (
    <AppLayout>
      <div className="container mx-auto p-6">
        <PageHeader
          title="All Users"
          description="Manage and view all system users"
          breadcrumbs={[
            { label: "User Management", href: "/user/all" },
            { label: "All Users" },
          ]}
          actions={
            <Button onClick={() => toast({ title: "Add User", description: "Feature coming soon" })}>
              <Plus className="mr-2 h-4 w-4" />
              Add New User
            </Button>
          }
        />

        {/* Statistics Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Users</CardTitle>
              <Shield className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{totalUsers}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Total registered users
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Active Users</CardTitle>
              <UserCheck className="h-4 w-4 text-green-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-green-600">{activeUsers}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Currently active
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Inactive Users</CardTitle>
              <UserCheck className="h-4 w-4 text-gray-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-gray-600">{inactiveUsers}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Currently inactive
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Admin Users</CardTitle>
              <Shield className="h-4 w-4 text-purple-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-purple-600">{adminUsers}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Administrator accounts
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Filters and Table */}
        <Card className="mt-6">
          <CardHeader>
            <CardTitle>Filter Users</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
              {/* Search */}
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search by name, email, or user ID..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>

              {/* Role Filter */}
              <Select value={filterRole} onValueChange={setFilterRole}>
                <SelectTrigger>
                  <SelectValue placeholder="Filter by role" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Roles</SelectItem>
                  <SelectItem value="Admin">Admin</SelectItem>
                  <SelectItem value="Manager">Manager</SelectItem>
                  <SelectItem value="Employee">Employee</SelectItem>
                </SelectContent>
              </Select>

              {/* Status Filter */}
              <Select value={filterStatus} onValueChange={setFilterStatus}>
                <SelectTrigger>
                  <SelectValue placeholder="Filter by status" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Status</SelectItem>
                  <SelectItem value="active">Active</SelectItem>
                  <SelectItem value="inactive">Inactive</SelectItem>
                  <SelectItem value="suspended">Suspended</SelectItem>
                </SelectContent>
              </Select>
            </div>

            <div className="flex items-center justify-between pt-4 border-t">
              <p className="text-sm text-muted-foreground">
                Showing {filteredUsers.length} of {totalUsers} users
              </p>
            </div>
          </CardContent>
        </Card>

        {/* Data Table */}
        <Card className="mt-6">
          <CardHeader>
            <CardTitle>User List</CardTitle>
          </CardHeader>
          <CardContent>
            <DataTable
              columns={columns}
              data={filteredUsers}
              searchable={false}
              emptyMessage="No users found matching your criteria"
            />
          </CardContent>
        </Card>

        {/* View User Dialog */}
        <Dialog open={isViewDialogOpen} onOpenChange={setIsViewDialogOpen}>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle className="flex items-center justify-between">
                <span>User Details</span>
                <Button variant="ghost" size="sm" onClick={() => setIsViewDialogOpen(false)}>
                  <X className="h-4 w-4" />
                </Button>
              </DialogTitle>
              <DialogDescription>
                Complete information about the selected user
              </DialogDescription>
            </DialogHeader>
            {selectedUser && (
              <div className="space-y-4 py-2">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold uppercase text-muted-foreground">User ID</Label>
                    <p className="text-sm font-medium">{selectedUser.userId}</p>
                  </div>
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold uppercase text-muted-foreground">Full Name</Label>
                    <p className="text-sm font-medium">{selectedUser.name}</p>
                  </div>
                </div>

                <Separator />

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold uppercase text-muted-foreground flex items-center gap-2">
                      <Mail className="h-3.5 w-3.5" /> Email
                    </Label>
                    <p className="text-sm break-all">{selectedUser.email}</p>
                  </div>
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold uppercase text-muted-foreground flex items-center gap-2">
                      <Phone className="h-3.5 w-3.5" /> Phone
                    </Label>
                    <p className="text-sm">{selectedUser.phone}</p>
                  </div>
                </div>

                <Separator />

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold uppercase text-muted-foreground">Role</Label>
                    <Badge className={`${getRoleBadgeClass(selectedUser.role)} mt-1`}>
                      <Shield className="mr-1 h-3 w-3" />
                      {selectedUser.role}
                    </Badge>
                  </div>
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold uppercase text-muted-foreground">Department</Label>
                    <p className="text-sm font-medium mt-1">{selectedUser.department}</p>
                  </div>
                </div>

                <Separator />

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold uppercase text-muted-foreground">Status</Label>
                    <Badge className={`${getStatusBadgeClass(selectedUser.status)} mt-1`}>
                      <UserCheck className="mr-1 h-3 w-3" />
                      {selectedUser.status.charAt(0).toUpperCase() + selectedUser.status.slice(1)}
                    </Badge>
                  </div>
                  <div className="space-y-1.5">
                    <Label className="text-xs font-semibold uppercase text-muted-foreground">Last Login</Label>
                    <p className="text-sm">{selectedUser.lastLogin || 'Never'}</p>
                  </div>
                </div>

                <Separator />

                <div className="space-y-1.5">
                  <Label className="text-xs font-semibold uppercase text-muted-foreground">Account Created</Label>
                  <p className="text-sm">{selectedUser.createdDate}</p>
                </div>
              </div>
            )}
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsViewDialogOpen(false)}>
                Close
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>

        {/* Edit User Dialog */}
        <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle className="flex items-center justify-between">
                <span>Edit User</span>
                <Button variant="ghost" size="sm" onClick={() => setIsEditDialogOpen(false)}>
                  <X className="h-4 w-4" />
                </Button>
              </DialogTitle>
              <DialogDescription>
                Update user information and details
              </DialogDescription>
            </DialogHeader>
            {selectedUser && (
              <form className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="edit-name">Full Name</Label>
                    <Input
                      id="edit-name"
                      defaultValue={selectedUser.name}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="edit-email">Email</Label>
                    <Input
                      id="edit-email"
                      type="email"
                      defaultValue={selectedUser.email}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="edit-phone">Phone</Label>
                    <Input
                      id="edit-phone"
                      defaultValue={selectedUser.phone}
                    />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="edit-department">Department</Label>
                    <Input
                      id="edit-department"
                      defaultValue={selectedUser.department}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="edit-role">Role</Label>
                    <Select defaultValue={selectedUser.role}>
                      <SelectTrigger>
                        <SelectValue placeholder="Select role" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="Admin">Admin</SelectItem>
                        <SelectItem value="Manager">Manager</SelectItem>
                        <SelectItem value="Employee">Employee</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="edit-status">Status</Label>
                    <Select defaultValue={selectedUser.status}>
                      <SelectTrigger>
                        <SelectValue placeholder="Select status" />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="active">Active</SelectItem>
                        <SelectItem value="inactive">Inactive</SelectItem>
                        <SelectItem value="suspended">Suspended</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>
              </form>
            )}
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsEditDialogOpen(false)}>
                Cancel
              </Button>
              <Button onClick={() => {
                toast({ title: "Success", description: "User updated successfully!" });
                setIsEditDialogOpen(false);
              }}>
                Save Changes
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>

        {/* Manage Roles Dialog */}
        <Dialog open={isRolesDialogOpen} onOpenChange={setIsRolesDialogOpen}>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle className="flex items-center justify-between">
                <span>Manage User Roles</span>
                <Button variant="ghost" size="sm" onClick={() => setIsRolesDialogOpen(false)}>
                  <X className="h-4 w-4" />
                </Button>
              </DialogTitle>
              <DialogDescription>
                Assign or remove roles for the selected user
              </DialogDescription>
            </DialogHeader>
            {selectedUser && (
              <div className="space-y-4">
                <div className="flex items-center gap-4 p-4 bg-muted rounded-lg">
                  <div className="flex-shrink-0">
                    <div className="w-12 h-12 rounded-full bg-primary flex items-center justify-center text-primary-foreground font-bold">
                      {selectedUser.name.charAt(0)}
                    </div>
                  </div>
                  <div className="flex-1">
                    <p className="font-semibold">{selectedUser.name}</p>
                    <p className="text-sm text-muted-foreground">{selectedUser.email}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm font-semibold">Current Role</p>
                    <Badge className={getRoleBadgeClass(selectedUser.role)}>
                      {selectedUser.role}
                    </Badge>
                  </div>
                </div>

                <Separator />

                <div className="space-y-3">
                  <Label className="text-base font-semibold">Available Roles</Label>
                  <div className="space-y-2">
                    {['Admin', 'Manager', 'Employee'].map((role) => (
                      <div key={role} className="flex items-center justify-between p-3 border rounded-lg hover:bg-accent transition-colors">
                        <div className="flex items-center gap-3">
                          <Checkbox
                            id={`role-${role}`}
                            checked={selectedUser.role === role}
                          />
                          <Label
                            htmlFor={`role-${role}`}
                            className="flex items-center gap-2 cursor-pointer font-medium"
                          >
                            <Shield className="h-4 w-4" />
                            {role}
                          </Label>
                        </div>
                        <Badge variant={selectedUser.role === role ? 'default' : 'secondary'}>
                          {selectedUser.role === role ? 'Current' : 'Available'}
                        </Badge>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
                  <p className="text-sm text-blue-800">
                    <strong>Note:</strong> Changing a user's role will immediately affect their access permissions in the system.
                  </p>
                </div>
              </div>
            )}
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsRolesDialogOpen(false)}>
                Cancel
              </Button>
              <Button onClick={() => {
                toast({ title: "Success", description: "Roles updated successfully!" });
                setIsRolesDialogOpen(false);
              }}>
                Update Roles
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>
    </AppLayout>
  );
};

export default AllUsers;
