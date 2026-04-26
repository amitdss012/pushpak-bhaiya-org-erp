import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatusBadge } from "@/components/ui/StatusBadge";
import { StatsCard } from "@/components/ui/StatsCard";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import {
  PackageOpen,
  PackageCheck,
  Package,
  Clock,
  Plus,
  Download,
  CheckCircle,
  AlertTriangle,
  Upload,
} from "lucide-react";
import { useToast } from "@/hooks/use-toast";

interface ReceivedItem {
  id: string;
  itemName: string;
  description: string;
  quantity: number;
  senderName: string;
  senderAddress: string;
  senderPhone: string;
  courierService: string;
  trackingNumber: string;
  receivedDate: string;
  receivedBy: string;
  department: string;
  condition: "good" | "damaged" | "partial";
  status: "pending" | "completed" | "active";
}

const receivedData: ReceivedItem[] = [
  {
    id: "RCV001",
    itemName: "Office Stationery",
    description: "Pens, notebooks, and files",
    quantity: 100,
    senderName: "ABC Suppliers",
    senderAddress: "Industrial Area, Delhi",
    senderPhone: "+91 98765 43210",
    courierService: "Blue Dart",
    trackingNumber: "BD987654321",
    receivedDate: "2024-01-24 11:30",
    receivedBy: "Reception Staff",
    department: "Administration",
    condition: "good",
    status: "completed",
  },
  {
    id: "RCV002",
    itemName: "Computer Accessories",
    description: "Keyboards, mice, and USB cables",
    quantity: 25,
    senderName: "Tech Solutions Pvt Ltd",
    senderAddress: "Electronics Hub, Mumbai",
    senderPhone: "+91 98765 43211",
    courierService: "FedEx",
    trackingNumber: "FX123456789",
    receivedDate: "2024-01-24 14:00",
    receivedBy: "IT Staff",
    department: "IT Department",
    condition: "good",
    status: "completed",
  },
  {
    id: "RCV003",
    itemName: "Lab Chemicals",
    description: "Chemistry lab reagents and chemicals",
    quantity: 15,
    senderName: "Scientific Supplies Co",
    senderAddress: "Chemical Zone, Chennai",
    senderPhone: "+91 98765 43212",
    courierService: "DTDC",
    trackingNumber: "DTDC456789123",
    receivedDate: "2024-01-24 09:45",
    receivedBy: "Lab Assistant",
    department: "Science Department",
    condition: "partial",
    status: "active",
  },
  {
    id: "RCV004",
    itemName: "Sports Equipment",
    description: "Basketball and volleyball sets",
    quantity: 10,
    senderName: "Sports World",
    senderAddress: "Sports Complex, Bangalore",
    senderPhone: "+91 98765 43213",
    courierService: "Delhivery",
    trackingNumber: "DL789123456",
    receivedDate: "2024-01-24 16:30",
    receivedBy: "Sports Coordinator",
    department: "Sports",
    condition: "damaged",
    status: "active",
  },
  {
    id: "RCV005",
    itemName: "Library Books",
    description: "Reference books and journals",
    quantity: 75,
    senderName: "Publishers Hub",
    senderAddress: "Book Street, Kolkata",
    senderPhone: "+91 98765 43214",
    courierService: "India Post",
    trackingNumber: "IP321654987",
    receivedDate: "2024-01-23 10:00",
    receivedBy: "Librarian",
    department: "Library",
    condition: "good",
    status: "completed",
  },
  {
    id: "RCV006",
    itemName: "Art Supplies",
    description: "Paints, brushes, and canvases",
    quantity: 50,
    senderName: "Creative Arts Store",
    senderAddress: "Art District, Jaipur",
    senderPhone: "+91 98765 43215",
    courierService: "Blue Dart",
    trackingNumber: "BD654321987",
    receivedDate: "2024-01-24 12:15",
    receivedBy: "Art Teacher",
    department: "Arts Department",
    condition: "good",
    status: "pending",
  },
];

const conditionColors = {
  good: "bg-success/10 text-success border-success/20",
  damaged: "bg-destructive/10 text-destructive border-destructive/20",
  partial: "bg-warning/10 text-warning border-warning/20",
};

const conditionLabels = {
  good: "Good Condition",
  damaged: "Damaged",
  partial: "Partial Received",
};

const columns: Column<ReceivedItem>[] = [
  {
    key: "itemName",
    header: "Item",
    sortable: true,
    cell: (item) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <PackageOpen className="h-5 w-5 text-primary" />
        </div>
        <div>
          <p className="font-medium">{item.itemName}</p>
          <p className="text-xs text-muted-foreground">{item.id}</p>
        </div>
      </div>
    ),
  },
  {
    key: "quantity",
    header: "Qty",
    cell: (item) => <Badge variant="secondary">{item.quantity}</Badge>,
  },
  {
    key: "senderName",
    header: "Sender",
    sortable: true,
    cell: (item) => (
      <div>
        <p className="text-sm font-medium">{item.senderName}</p>
        <p className="text-xs text-muted-foreground">{item.senderPhone}</p>
      </div>
    ),
  },
  {
    key: "courierService",
    header: "Courier",
    cell: (item) => (
      <div>
        <p className="text-sm">{item.courierService}</p>
        <p className="text-xs text-muted-foreground font-mono">{item.trackingNumber}</p>
      </div>
    ),
  },
  {
    key: "receivedDate",
    header: "Received",
    sortable: true,
    cell: (item) => (
      <span className="text-sm">
        {new Date(item.receivedDate).toLocaleDateString("en-US", {
          month: "short",
          day: "numeric",
          hour: "2-digit",
          minute: "2-digit",
        })}
      </span>
    ),
  },
  {
    key: "department",
    header: "Department",
    sortable: true,
  },
  {
    key: "condition",
    header: "Condition",
    cell: (item) => (
      <span
        className={`inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-medium ${conditionColors[item.condition]}`}
      >
        {item.condition === "good" && <CheckCircle className="h-3 w-3 mr-1" />}
        {item.condition === "damaged" && <AlertTriangle className="h-3 w-3 mr-1" />}
        {conditionLabels[item.condition]}
      </span>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (item) => <StatusBadge status={item.status} />,
  },
];

export default function ItemReceive() {
  const { toast } = useToast();
  const [isNewReceiveOpen, setIsNewReceiveOpen] = useState(false);
  const [isViewDialogOpen, setIsViewDialogOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState<ReceivedItem | null>(null);

  const totalReceived = receivedData.length;
  const goodCondition = receivedData.filter((d) => d.condition === "good").length;
  const damaged = receivedData.filter((d) => d.condition === "damaged").length;
  const pendingVerification = receivedData.filter((d) => d.status === "pending").length;

  const handleView = (item: ReceivedItem) => {
    setSelectedItem(item);
    setIsViewDialogOpen(true);
  };

  const handleActions = (item: ReceivedItem) => [
    { label: "View Details", onClick: () => handleView(item) },
    { label: "Print Acknowledgment", onClick: () => console.log("Print", item.id) },
    { label: "Forward to Department", onClick: () => console.log("Forward", item.id) },
    { label: "Report Issue", onClick: () => console.log("Report", item.id) },
    { label: "Delete", onClick: () => console.log("Delete", item.id), destructive: true },
  ];

  const handleNewReceive = () => {
    setIsNewReceiveOpen(false);
    toast({
      title: "Item Recorded",
      description: "Received item has been successfully logged.",
    });
  };

  return (
    <AppLayout>
      <PageHeader
        title="Item Receive"
        description="Log and manage incoming items and deliveries"
        breadcrumbs={[
          { label: "Reception", href: "/reception/receive" },
          { label: "Item Receive" },
        ]}
        actions={
          <>
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Export
            </Button>
            <Button onClick={() => setIsNewReceiveOpen(true)} className="gap-2">
              <Plus className="h-4 w-4" />
              Log New Item
            </Button>
          </>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard
          title="Total Received"
          value={totalReceived}
          subtitle="This month"
          icon={PackageOpen}
          variant="primary"
        />
        <StatsCard
          title="Good Condition"
          value={goodCondition}
          subtitle="No issues"
          icon={PackageCheck}
          variant="success"
        />
        <StatsCard
          title="Damaged Items"
          value={damaged}
          subtitle="Needs attention"
          icon={AlertTriangle}
          variant="warning"
        />
        <StatsCard
          title="Pending Verification"
          value={pendingVerification}
          subtitle="To be processed"
          icon={Clock}
          variant="info"
        />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Received Items</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={receivedData}
            columns={columns}
            selectable
            searchPlaceholder="Search by item name, sender, or tracking number..."
            actions={handleActions}
          />
        </CardContent>
      </Card>

      {/* New Receive Dialog */}
      <Dialog open={isNewReceiveOpen} onOpenChange={setIsNewReceiveOpen}>
        <DialogContent className="sm:max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <PackageOpen className="h-5 w-5 text-primary" />
              Log Received Item
            </DialogTitle>
          </DialogHeader>
          <div className="space-y-6">
            <div className="space-y-4">
              <h4 className="font-medium text-sm text-muted-foreground uppercase tracking-wide">
                Item Details
              </h4>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="itemName">Item Name *</Label>
                  <Input id="itemName" placeholder="Enter item name" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="quantity">Quantity *</Label>
                  <Input id="quantity" type="number" min="1" defaultValue="1" />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="description">Description</Label>
                <Textarea id="description" placeholder="Brief description of the item" rows={2} />
              </div>
            </div>

            <div className="space-y-4">
              <h4 className="font-medium text-sm text-muted-foreground uppercase tracking-wide">
                Sender Details
              </h4>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="senderName">Sender Name *</Label>
                  <Input id="senderName" placeholder="Enter sender name/company" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="senderPhone">Phone Number</Label>
                  <Input id="senderPhone" placeholder="+91 98765 43210" />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="senderAddress">Sender Address</Label>
                <Textarea id="senderAddress" placeholder="Sender's address" rows={2} />
              </div>
            </div>

            <div className="space-y-4">
              <h4 className="font-medium text-sm text-muted-foreground uppercase tracking-wide">
                Shipping & Receiving Details
              </h4>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="courierService">Courier Service</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="Select courier" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="bluedart">Blue Dart</SelectItem>
                      <SelectItem value="dtdc">DTDC</SelectItem>
                      <SelectItem value="fedex">FedEx</SelectItem>
                      <SelectItem value="delhivery">Delhivery</SelectItem>
                      <SelectItem value="indiapost">India Post</SelectItem>
                      <SelectItem value="handdelivery">Hand Delivery</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="trackingNumber">Tracking Number</Label>
                  <Input id="trackingNumber" placeholder="Enter tracking number" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="receivedDate">Received Date *</Label>
                  <Input
                    id="receivedDate"
                    type="datetime-local"
                    defaultValue={new Date().toISOString().slice(0, 16)}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="department">Forward to Department *</Label>
                  <Select>
                    <SelectTrigger>
                      <SelectValue placeholder="Select department" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="administration">Administration</SelectItem>
                      <SelectItem value="academics">Academics</SelectItem>
                      <SelectItem value="accounts">Accounts</SelectItem>
                      <SelectItem value="it">IT Department</SelectItem>
                      <SelectItem value="library">Library</SelectItem>
                      <SelectItem value="sports">Sports</SelectItem>
                      <SelectItem value="lab">Laboratory</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="condition">Item Condition *</Label>
                  <Select defaultValue="good">
                    <SelectTrigger>
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="good">Good Condition</SelectItem>
                      <SelectItem value="partial">Partially Received</SelectItem>
                      <SelectItem value="damaged">Damaged</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="receivedBy">Received By *</Label>
                  <Input id="receivedBy" placeholder="Name of receiving person" />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="remarks">Remarks</Label>
                <Textarea id="remarks" placeholder="Any additional notes or issues..." rows={2} />
              </div>
              <div className="space-y-2">
                <Label>Attachments</Label>
                <div className="border-2 border-dashed rounded-lg p-4 text-center hover:border-primary/50 transition-colors cursor-pointer">
                  <Upload className="h-6 w-6 mx-auto text-muted-foreground mb-2" />
                  <p className="text-sm text-muted-foreground">
                    Upload delivery receipt or photos
                  </p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <Checkbox id="notify" />
                <Label htmlFor="notify" className="text-sm font-normal">
                  Notify department head about this delivery
                </Label>
              </div>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsNewReceiveOpen(false)}>
              Cancel
            </Button>
            <Button onClick={handleNewReceive} className="gap-2">
              <PackageCheck className="h-4 w-4" />
              Log Item
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* View Details Dialog */}
      <Dialog open={isViewDialogOpen} onOpenChange={setIsViewDialogOpen}>
        <DialogContent className="sm:max-w-lg">
          <DialogHeader>
            <DialogTitle>Received Item Details</DialogTitle>
          </DialogHeader>
          {selectedItem && (
            <div className="space-y-4">
              <div className="flex items-center gap-4 p-4 rounded-lg bg-muted/50">
                <div className="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center">
                  <PackageOpen className="h-6 w-6 text-primary" />
                </div>
                <div className="flex-1">
                  <p className="font-medium">{selectedItem.itemName}</p>
                  <p className="text-sm text-muted-foreground">{selectedItem.description}</p>
                </div>
                <span
                  className={`inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-medium ${conditionColors[selectedItem.condition]}`}
                >
                  {conditionLabels[selectedItem.condition]}
                </span>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Receipt ID</p>
                  <p className="font-medium">{selectedItem.id}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Quantity</p>
                  <p className="font-medium">{selectedItem.quantity}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Sender</p>
                  <p className="font-medium">{selectedItem.senderName}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Phone</p>
                  <p className="font-medium">{selectedItem.senderPhone}</p>
                </div>
                <div className="space-y-1 col-span-2">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Sender Address</p>
                  <p className="font-medium">{selectedItem.senderAddress}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Courier</p>
                  <p className="font-medium">{selectedItem.courierService}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Tracking #</p>
                  <p className="font-medium font-mono text-sm">{selectedItem.trackingNumber}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Received On</p>
                  <p className="font-medium">
                    {new Date(selectedItem.receivedDate).toLocaleString("en-US", {
                      month: "short",
                      day: "numeric",
                      year: "numeric",
                      hour: "2-digit",
                      minute: "2-digit",
                    })}
                  </p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Department</p>
                  <p className="font-medium">{selectedItem.department}</p>
                </div>
                <div className="space-y-1 col-span-2">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Received By</p>
                  <p className="font-medium">{selectedItem.receivedBy}</p>
                </div>
              </div>
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Print Receipt
            </Button>
            <Button onClick={() => setIsViewDialogOpen(false)}>Close</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AppLayout>
  );
}
