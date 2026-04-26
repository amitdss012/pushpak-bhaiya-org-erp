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
import {
  Package,
  PackageCheck,
  Truck,
  Clock,
  Plus,
  Download,
  Upload,
  Send,
  Eye,
} from "lucide-react";
import { useToast } from "@/hooks/use-toast";

interface DispatchItem {
  id: string;
  itemName: string;
  description: string;
  quantity: number;
  recipientName: string;
  recipientAddress: string;
  recipientPhone: string;
  courierService: string;
  trackingNumber: string;
  dispatchDate: string;
  expectedDelivery: string;
  status: "pending" | "active" | "completed";
  dispatchedBy: string;
}

const dispatchData: DispatchItem[] = [
  {
    id: "DSP001",
    itemName: "Student Certificates",
    description: "Batch of 25 completion certificates",
    quantity: 25,
    recipientName: "ABC Institute",
    recipientAddress: "123 Education Lane, Mumbai",
    recipientPhone: "+91 98765 43210",
    courierService: "Blue Dart",
    trackingNumber: "BD123456789",
    dispatchDate: "2024-01-24 10:00",
    expectedDelivery: "2024-01-26",
    status: "active",
    dispatchedBy: "Admin Staff",
  },
  {
    id: "DSP002",
    itemName: "Exam Papers",
    description: "Mid-term exam question papers",
    quantity: 150,
    recipientName: "Regional Office",
    recipientAddress: "456 Main Road, Delhi",
    recipientPhone: "+91 98765 43211",
    courierService: "DTDC",
    trackingNumber: "DTDC987654321",
    dispatchDate: "2024-01-23 14:30",
    expectedDelivery: "2024-01-25",
    status: "completed",
    dispatchedBy: "Exam Coordinator",
  },
  {
    id: "DSP003",
    itemName: "Lab Equipment",
    description: "Microscope and lab supplies",
    quantity: 5,
    recipientName: "Science Department",
    recipientAddress: "Branch Campus, Pune",
    recipientPhone: "+91 98765 43212",
    courierService: "FedEx",
    trackingNumber: "FX567891234",
    dispatchDate: "2024-01-24 09:00",
    expectedDelivery: "2024-01-27",
    status: "active",
    dispatchedBy: "Lab Manager",
  },
  {
    id: "DSP004",
    itemName: "Books & Journals",
    description: "Reference books for library",
    quantity: 50,
    recipientName: "Central Library",
    recipientAddress: "University Campus, Chennai",
    recipientPhone: "+91 98765 43213",
    courierService: "India Post",
    trackingNumber: "IP123789456",
    dispatchDate: "2024-01-22 11:00",
    expectedDelivery: "2024-01-28",
    status: "pending",
    dispatchedBy: "Librarian",
  },
  {
    id: "DSP005",
    itemName: "Sports Equipment",
    description: "Cricket bats and footballs",
    quantity: 20,
    recipientName: "Sports Complex",
    recipientAddress: "Sports Wing, Bangalore",
    recipientPhone: "+91 98765 43214",
    courierService: "Delhivery",
    trackingNumber: "DL456123789",
    dispatchDate: "2024-01-24 16:00",
    expectedDelivery: "2024-01-26",
    status: "pending",
    dispatchedBy: "Sports Coordinator",
  },
];

const columns: Column<DispatchItem>[] = [
  {
    key: "itemName",
    header: "Item",
    sortable: true,
    cell: (item) => (
      <div className="flex items-center gap-3">
        <div className="h-10 w-10 rounded-lg bg-primary/10 flex items-center justify-center">
          <Package className="h-5 w-5 text-primary" />
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
    key: "recipientName",
    header: "Recipient",
    sortable: true,
    cell: (item) => (
      <div>
        <p className="text-sm font-medium">{item.recipientName}</p>
        <p className="text-xs text-muted-foreground truncate max-w-[150px]">
          {item.recipientAddress}
        </p>
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
    key: "dispatchDate",
    header: "Dispatched",
    sortable: true,
    cell: (item) => (
      <span className="text-sm">
        {new Date(item.dispatchDate).toLocaleDateString("en-US", {
          month: "short",
          day: "numeric",
          hour: "2-digit",
          minute: "2-digit",
        })}
      </span>
    ),
  },
  {
    key: "expectedDelivery",
    header: "Expected Delivery",
    sortable: true,
    cell: (item) => (
      <span className="text-sm">
        {new Date(item.expectedDelivery).toLocaleDateString("en-US", {
          month: "short",
          day: "numeric",
          year: "numeric",
        })}
      </span>
    ),
  },
  {
    key: "status",
    header: "Status",
    cell: (item) => <StatusBadge status={item.status} />,
  },
];

export default function ItemDispatch() {
  const { toast } = useToast();
  const [isNewDispatchOpen, setIsNewDispatchOpen] = useState(false);
  const [isViewDialogOpen, setIsViewDialogOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState<DispatchItem | null>(null);

  const totalDispatched = dispatchData.length;
  const inTransit = dispatchData.filter((d) => d.status === "active").length;
  const delivered = dispatchData.filter((d) => d.status === "completed").length;
  const pendingPickup = dispatchData.filter((d) => d.status === "pending").length;

  const handleView = (item: DispatchItem) => {
    setSelectedItem(item);
    setIsViewDialogOpen(true);
  };

  const handleActions = (item: DispatchItem) => [
    { label: "View Details", onClick: () => handleView(item) },
    { label: "Track Shipment", onClick: () => console.log("Track", item.id) },
    { label: "Print Label", onClick: () => console.log("Print", item.id) },
    { label: "Mark as Delivered", onClick: () => console.log("Delivered", item.id) },
    { label: "Cancel Dispatch", onClick: () => console.log("Cancel", item.id), destructive: true },
  ];

  const handleNewDispatch = () => {
    setIsNewDispatchOpen(false);
    toast({
      title: "Item Dispatched",
      description: "New dispatch entry has been recorded successfully.",
    });
  };

  return (
    <AppLayout>
      <PageHeader
        title="Item Dispatch"
        description="Manage outgoing items and shipments"
        breadcrumbs={[
          { label: "Reception", href: "/reception/dispatch" },
          { label: "Item Dispatch" },
        ]}
        actions={
          <>
            <Button variant="outline" className="gap-2">
              <Download className="h-4 w-4" />
              Export
            </Button>
            <Button onClick={() => setIsNewDispatchOpen(true)} className="gap-2">
              <Plus className="h-4 w-4" />
              New Dispatch
            </Button>
          </>
        }
      />

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-6">
        <StatsCard
          title="Total Dispatched"
          value={totalDispatched}
          subtitle="This month"
          icon={Package}
          variant="primary"
        />
        <StatsCard
          title="In Transit"
          value={inTransit}
          subtitle="On the way"
          icon={Truck}
          variant="info"
        />
        <StatsCard
          title="Delivered"
          value={delivered}
          subtitle="Successfully received"
          icon={PackageCheck}
          variant="success"
        />
        <StatsCard
          title="Pending Pickup"
          value={pendingPickup}
          subtitle="Awaiting courier"
          icon={Clock}
          variant="warning"
        />
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Dispatch Records</CardTitle>
        </CardHeader>
        <CardContent>
          <DataTable
            data={dispatchData}
            columns={columns}
            selectable
            searchPlaceholder="Search by item name, recipient, or tracking number..."
            actions={handleActions}
          />
        </CardContent>
      </Card>

      {/* New Dispatch Dialog */}
      <Dialog open={isNewDispatchOpen} onOpenChange={setIsNewDispatchOpen}>
        <DialogContent className="sm:max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle className="flex items-center gap-2">
              <Send className="h-5 w-5 text-primary" />
              New Item Dispatch
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
                Recipient Details
              </h4>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="recipientName">Recipient Name *</Label>
                  <Input id="recipientName" placeholder="Enter recipient name" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="recipientPhone">Phone Number *</Label>
                  <Input id="recipientPhone" placeholder="+91 98765 43210" />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="recipientAddress">Delivery Address *</Label>
                <Textarea id="recipientAddress" placeholder="Full delivery address" rows={2} />
              </div>
            </div>

            <div className="space-y-4">
              <h4 className="font-medium text-sm text-muted-foreground uppercase tracking-wide">
                Shipping Details
              </h4>
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                  <Label htmlFor="courierService">Courier Service *</Label>
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
                      <SelectItem value="self">Self Delivery</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="trackingNumber">Tracking Number</Label>
                  <Input id="trackingNumber" placeholder="Enter tracking number" />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="dispatchDate">Dispatch Date *</Label>
                  <Input
                    id="dispatchDate"
                    type="date"
                    defaultValue={new Date().toISOString().split("T")[0]}
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="expectedDelivery">Expected Delivery</Label>
                  <Input id="expectedDelivery" type="date" />
                </div>
              </div>
              <div className="space-y-2">
                <Label htmlFor="remarks">Remarks</Label>
                <Textarea id="remarks" placeholder="Any additional notes..." rows={2} />
              </div>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsNewDispatchOpen(false)}>
              Cancel
            </Button>
            <Button onClick={handleNewDispatch} className="gap-2">
              <Send className="h-4 w-4" />
              Dispatch Item
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* View Details Dialog */}
      <Dialog open={isViewDialogOpen} onOpenChange={setIsViewDialogOpen}>
        <DialogContent className="sm:max-w-lg">
          <DialogHeader>
            <DialogTitle>Dispatch Details</DialogTitle>
          </DialogHeader>
          {selectedItem && (
            <div className="space-y-4">
              <div className="flex items-center gap-4 p-4 rounded-lg bg-muted/50">
                <div className="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center">
                  <Package className="h-6 w-6 text-primary" />
                </div>
                <div className="flex-1">
                  <p className="font-medium">{selectedItem.itemName}</p>
                  <p className="text-sm text-muted-foreground">{selectedItem.description}</p>
                </div>
                <StatusBadge status={selectedItem.status} />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Dispatch ID</p>
                  <p className="font-medium">{selectedItem.id}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Quantity</p>
                  <p className="font-medium">{selectedItem.quantity}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Recipient</p>
                  <p className="font-medium">{selectedItem.recipientName}</p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Phone</p>
                  <p className="font-medium">{selectedItem.recipientPhone}</p>
                </div>
                <div className="space-y-1 col-span-2">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Address</p>
                  <p className="font-medium">{selectedItem.recipientAddress}</p>
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
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Dispatched On</p>
                  <p className="font-medium">
                    {new Date(selectedItem.dispatchDate).toLocaleDateString("en-US", {
                      month: "short",
                      day: "numeric",
                      year: "numeric",
                    })}
                  </p>
                </div>
                <div className="space-y-1">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Expected Delivery</p>
                  <p className="font-medium">
                    {new Date(selectedItem.expectedDelivery).toLocaleDateString("en-US", {
                      month: "short",
                      day: "numeric",
                      year: "numeric",
                    })}
                  </p>
                </div>
                <div className="space-y-1 col-span-2">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide">Dispatched By</p>
                  <p className="font-medium">{selectedItem.dispatchedBy}</p>
                </div>
              </div>
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" className="gap-2">
              <Truck className="h-4 w-4" />
              Track Shipment
            </Button>
            <Button onClick={() => setIsViewDialogOpen(false)}>Close</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </AppLayout>
  );
}
