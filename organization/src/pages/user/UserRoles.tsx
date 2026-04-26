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
  DialogTrigger,
} from "@/components/ui/dialog";
import { useToast } from "@/hooks/use-toast";
import { Plus, Shield, Users, Edit, Trash2, Check, Search } from "lucide-react";

interface Role {
  id: string;
  roleName: string;
  description: string;
  userCount: number;
  permissions: string[];
  isDefault: boolean;
  createdDate: string;
}

// Sample data - replace with actual API data
const sampleRoles: Role[] = [
  {
    id: "1",
    roleName: "Admin",
    description: "Full system access with all permissions",
    userCount: 5,
    permissions: ["all"],
    isDefault: false,
    createdDate: "2024-01-01",
  },
  {
    id: "2",
    roleName: "Manager",
    description: "Can manage team and view reports",
    userCount: 12,
    permissions: ["view_reports", "manage_team", "approve_requests"],
    isDefault: true,
    createdDate: "2024-01-05",
  },
  {
    id: "3",
    roleName: "Employee",
    description: "Basic employee access",
    userCount: 50,
    permissions: ["view_profile", "mark_attendance"],
    isDefault: true,
    createdDate: "2024-01-10",
  },
  {
    id: "4",
    roleName: "HR Manager",
    description: "Human resources management",
    userCount: 3,
    permissions: ["manage_employees", "view_attendance", "manage_leave"],
    isDefault: false,
    createdDate: "2024-01-15",
  },
];

const UserRoles = () => {
  const { toast } = useToast();
  const [searchTerm, setSearchTerm] = useState("");
  const [roles] = useState<Role[]>(sampleRoles);
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [selectedRole, setSelectedRole] = useState<Role | null>(null);

  const handleDeleteRole = (id: string) => {
    toast({
      title: "Role Deleted",
      description: "The role has been removed successfully.",
      variant: "destructive",
    });
  };

  const columns = [
    {
      key: "roleName" as keyof Role,
      header: "Role Name",
      cell: (item: Role) => (
        <div className="flex items-center gap-2">
          <Shield className="h-4 w-4 text-purple-600" />
          <span className="font-medium">{item.roleName}</span>
        </div>
      ),
    },
    {
      key: "description" as keyof Role,
      header: "Description",
    },
    {
      key: "userCount" as keyof Role,
      header: "Users",
      cell: (item: Role) => (
        <div className="flex items-center gap-2">
          <Users className="h-4 w-4 text-muted-foreground" />
          <span>{item.userCount} users</span>
        </div>
      ),
    },
    {
      key: "permissions" as keyof Role,
      header: "Permissions",
      cell: (item: Role) => (
        <div className="flex gap-1 flex-wrap">
          {item.permissions.slice(0, 3).map((perm, index) => (
            <Badge key={index} variant="secondary" className="text-xs">
              {perm.replace(/_/g, " ")}
            </Badge>
          ))}
          {item.permissions.length > 3 && (
            <Badge variant="outline" className="text-xs">
              +{item.permissions.length - 3} more
            </Badge>
          )}
        </div>
      ),
    },
    {
      key: "isDefault" as keyof Role,
      header: "Default",
      cell: (item: Role) =>
        item.isDefault ? (
          <Check className="h-4 w-4 text-green-600" />
        ) : (
          <span className="text-muted-foreground">-</span>
        ),
    },
    {
      key: "actions",
      header: "Actions",
      cell: (item: Role) => (
        <div className="flex items-center gap-2">
          <Button
            variant="ghost"
            size="sm"
            onClick={() => {
              setSelectedRole(item);
              setIsEditDialogOpen(true);
            }}
          >
            <Edit className="h-4 w-4" />
          </Button>
          <Button
            variant="ghost"
            size="sm"
            onClick={() => handleDeleteRole(item.id)}
            disabled={item.isDefault}
          >
            <Trash2 className="h-4 w-4" />
          </Button>
        </div>
      ),
    },
  ];

  const filteredRoles = roles.filter((role) =>
    role.roleName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    role.description.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <AppLayout>
      <div className="container mx-auto p-6">
        <PageHeader
          title="User Roles"
          description="Manage user roles and permissions"
          breadcrumbs={[
            { label: "User Management", href: "/user/roles" },
            { label: "User Roles" },
          ]}
          actions={
            <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
              <DialogTrigger asChild>
                <Button>
                  <Plus className="mr-2 h-4 w-4" />
                  Create New Role
                </Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>Create New Role</DialogTitle>
                  <DialogDescription>
                    Define a new role with specific permissions
                  </DialogDescription>
                </DialogHeader>
                <div className="space-y-4 py-4">
                  <div className="space-y-2">
                    <Label htmlFor="roleName">Role Name</Label>
                    <Input id="roleName" placeholder="Enter role name" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="description">Description</Label>
                    <Input id="description" placeholder="Enter role description" />
                  </div>
                  <div className="space-y-2">
                    <Label>Permissions</Label>
                    <div className="grid grid-cols-2 gap-2">
                      {["View Reports", "Manage Team", "Approve Requests", "Manage Employees"].map((permission) => (
                        <div key={permission} className="flex items-center space-x-2">
                          <Checkbox id={permission} />
                          <Label htmlFor={permission} className="text-sm">
                            {permission}
                          </Label>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
                <DialogFooter>
                  <Button variant="outline" onClick={() => setIsCreateDialogOpen(false)}>
                    Cancel
                  </Button>
                  <Button onClick={() => {
                    toast({
                      title: "Role Created",
                      description: "New role has been created successfully.",
                    });
                    setIsCreateDialogOpen(false);
                  }}>
                    Create Role
                  </Button>
                </DialogFooter>
              </DialogContent>
            </Dialog>
          }
        />

        {/* Statistics Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mt-6">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Total Roles</CardTitle>
              <Shield className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">{roles.length}</div>
              <p className="text-xs text-muted-foreground mt-1">
                Defined roles
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Default Roles</CardTitle>
              <Check className="h-4 w-4 text-green-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-green-600">
                {roles.filter(r => r.isDefault).length}
              </div>
              <p className="text-xs text-muted-foreground mt-1">
                System default roles
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Custom Roles</CardTitle>
              <Edit className="h-4 w-4 text-blue-600" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-blue-600">
                {roles.filter(r => !r.isDefault).length}
              </div>
              <p className="text-xs text-muted-foreground mt-1">
                Custom defined roles
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Filters and Table */}
        <Card className="mt-6">
          <CardHeader>
            <CardTitle>All Roles</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="mb-4">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search roles..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>

            <DataTable
              columns={columns}
              data={filteredRoles}
              searchable={false}
              emptyMessage="No roles found"
            />
          </CardContent>
        </Card>

        {/* Permissions Info Card */}
        <Card className="mt-6">
          <CardHeader>
            <CardTitle>About Roles & Permissions</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2 text-sm text-muted-foreground">
            <p>
              • Roles define what users can do in the system based on their assigned permissions
            </p>
            <p>
              • Default roles are system-defined and cannot be deleted
            </p>
            <p>
              • Custom roles can be created with specific permission sets
            </p>
            <p>
              • Each user can be assigned one or more roles
            </p>
            <p>
              • Permissions control access to specific features and actions
            </p>
          </CardContent>
        </Card>

        {/* Edit Role Dialog */}
        <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
          <DialogContent className="max-w-2xl">
            <DialogHeader>
              <DialogTitle>Edit Role</DialogTitle>
              <DialogDescription>
                Update role information and permissions
              </DialogDescription>
            </DialogHeader>
            {selectedRole && (
              <form className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="edit-roleName">Role Name</Label>
                  <Input
                    id="edit-roleName"
                    defaultValue={selectedRole.roleName}
                    disabled={selectedRole.isDefault}
                  />
                  {selectedRole.isDefault && (
                    <p className="text-xs text-muted-foreground">
                      System default roles cannot be renamed
                    </p>
                  )}
                </div>

                <div className="space-y-2">
                  <Label htmlFor="edit-description">Description</Label>
                  <Input
                    id="edit-description"
                    defaultValue={selectedRole.description}
                    disabled={selectedRole.isDefault}
                  />
                </div>

                <div className="space-y-2">
                  <Label>Permissions</Label>
                  <div className="grid grid-cols-2 gap-3 max-h-[300px] overflow-y-auto p-2 border rounded-md">
                    {[
                      "View Dashboard",
                      "View Analytics",
                      "Export Reports",
                      "Manage Team",
                      "Approve Requests",
                      "Manage Employees",
                      "View Attendance",
                      "Manage Leave"
                    ].map((permission) => (
                      <div key={permission} className="flex items-center space-x-2">
                        <Checkbox
                          id={`edit-perm-${permission}`}
                          defaultChecked={selectedRole.permissions.includes(permission.toLowerCase().replace(/ /g, '_')) || selectedRole.permissions.includes('all')}
                          disabled={selectedRole.isDefault}
                        />
                        <Label
                          htmlFor={`edit-perm-${permission}`}
                          className="text-sm font-normal cursor-pointer"
                        >
                          {permission}
                        </Label>
                      </div>
                    ))}
                  </div>
                </div>
              </form>
            )}
            <DialogFooter>
              <Button variant="outline" onClick={() => setIsEditDialogOpen(false)}>
                Cancel
              </Button>
              <Button
                onClick={() => {
                  toast({
                    title: "Role Updated",
                    description: "Role has been updated successfully.",
                  });
                  setIsEditDialogOpen(false);
                }}
                disabled={selectedRole?.isDefault}
              >
                Save Changes
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>
    </AppLayout>
  );
};

export default UserRoles;
