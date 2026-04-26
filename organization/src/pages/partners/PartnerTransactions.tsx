import { useState } from "react";
import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable } from "@/components/ui/DataTable";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { DollarSign, TrendingUp, TrendingDown, Calendar, Filter } from "lucide-react";
import { format } from "date-fns";

interface Transaction {
  id: string;
  partnerId: string;
  partnerName: string;
  type: "commission" | "payment" | "refund" | "adjustment";
  amount: number;
  status: "completed" | "pending" | "failed";
  description: string;
  date: string;
  referenceId: string;
  paymentMethod?: string;
}

// Sample data - replace with actual API data
const sampleTransactions: Transaction[] = [
  {
    id: "1",
    partnerId: "1",
    partnerName: "John Education Services",
    type: "commission",
    amount: 5000,
    status: "completed",
    description: "Commission for student admission - Batch 2024",
    date: "2024-03-15",
    referenceId: "COMM-2024-001",
    paymentMethod: "Bank Transfer",
  },
  {
    id: "2",
    partnerId: "1",
    partnerName: "John Education Services",
    type: "payment",
    amount: 10000,
    status: "completed",
    description: "Partner incentive payment",
    date: "2024-03-10",
    referenceId: "PAY-2024-045",
    paymentMethod: "UPI",
  },
  {
    id: "3",
    partnerId: "1",
    partnerName: "John Education Services",
    type: "commission",
    amount: 3500,
    status: "pending",
    description: "Commission for online course enrollment",
    date: "2024-03-20",
    referenceId: "COMM-2024-002",
  },
  {
    id: "4",
    partnerId: "1",
    partnerName: "John Education Services",
    type: "refund",
    amount: 2000,
    status: "completed",
    description: "Refund for cancelled admission",
    date: "2024-03-05",
    referenceId: "REF-2024-012",
    paymentMethod: "Bank Transfer",
  },
  {
    id: "5",
    partnerId: "1",
    partnerName: "John Education Services",
    type: "adjustment",
    amount: 500,
    status: "completed",
    description: "Tax adjustment for February 2024",
    date: "2024-03-01",
    referenceId: "ADJ-2024-003",
  },
];

const PartnerTransactions = () => {
  const [transactions] = useState<Transaction[]>(sampleTransactions);
  const [filterType, setFilterType] = useState<string>("all");
  const [filterStatus, setFilterStatus] = useState<string>("all");

  // Calculate summary
  const totalCommission = transactions
    .filter((t) => t.type === "commission")
    .reduce((sum, t) => sum + t.amount, 0);

  const totalPayment = transactions
    .filter((t) => t.type === "payment")
    .reduce((sum, t) => sum + t.amount, 0);

  const totalRefund = transactions
    .filter((t) => t.type === "refund")
    .reduce((sum, t) => sum + t.amount, 0);

  const netAmount = totalCommission + totalPayment - totalRefund;

  const getTypeColor = (type: string) => {
    switch (type) {
      case "commission":
        return "bg-green-100 text-green-800";
      case "payment":
        return "bg-blue-100 text-blue-800";
      case "refund":
        return "bg-red-100 text-red-800";
      case "adjustment":
        return "bg-yellow-100 text-yellow-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "completed":
        return "bg-green-100 text-green-800";
      case "pending":
        return "bg-yellow-100 text-yellow-800";
      case "failed":
        return "bg-red-100 text-red-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  const columns = [
    {
      key: "date" as keyof Transaction,
      header: "Date",
      cell: (item: Transaction) => format(new Date(item.date), "dd MMM yyyy"),
    },
    {
      key: "referenceId" as keyof Transaction,
      header: "Reference ID",
    },
    {
      key: "type" as keyof Transaction,
      header: "Type",
      cell: (item: Transaction) => (
        <Badge className={getTypeColor(item.type)}>
          {item.type.charAt(0).toUpperCase() + item.type.slice(1)}
        </Badge>
      ),
    },
    {
      key: "description" as keyof Transaction,
      header: "Description",
    },
    {
      key: "amount" as keyof Transaction,
      header: "Amount",
      cell: (item: Transaction) => (
        <span className="font-semibold">₹{item.amount.toLocaleString()}</span>
      ),
    },
    {
      key: "status" as keyof Transaction,
      header: "Status",
      cell: (item: Transaction) => (
        <Badge className={getStatusColor(item.status)}>
          {item.status.charAt(0).toUpperCase() + item.status.slice(1)}
        </Badge>
      ),
    },
    {
      key: "paymentMethod" as keyof Transaction,
      header: "Payment Method",
      cell: (item: Transaction) => item.paymentMethod || "-",
    },
  ];

  const filteredTransactions = transactions.filter((transaction) => {
    const typeMatch = filterType === "all" || transaction.type === filterType;
    const statusMatch = filterStatus === "all" || transaction.status === filterStatus;
    return typeMatch && statusMatch;
  });

  return (
    <AppLayout>
      <div className="container mx-auto p-6">
        <PageHeader
          title="Partner Transactions"
          description="View and manage partner financial transactions"
          breadcrumbs={[
            { label: "Partners", href: "/partners/all" },
            { label: "Transactions" },
          ]}
        />

      {/* Summary Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mt-6">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Commission</CardTitle>
            <TrendingUp className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">₹{totalCommission.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground mt-1">
              From all commission transactions
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Payments</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">₹{totalPayment.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Total payments made
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Refunds</CardTitle>
            <TrendingDown className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">₹{totalRefund.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Total refunds processed
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Net Amount</CardTitle>
            <Calendar className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">₹{netAmount.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Commission + Payments - Refunds
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Filters and Table */}
      <Card className="mt-6">
        <CardHeader>
          <CardTitle>All Transactions</CardTitle>
        </CardHeader>
        <CardContent>
          <Tabs defaultValue="all" className="space-y-4">
            <div className="flex items-center justify-between">
              <TabsList>
                <TabsTrigger value="all">All</TabsTrigger>
                <TabsTrigger value="commission">Commission</TabsTrigger>
                <TabsTrigger value="payment">Payment</TabsTrigger>
                <TabsTrigger value="refund">Refund</TabsTrigger>
                <TabsTrigger value="adjustment">Adjustment</TabsTrigger>
              </TabsList>

              <div className="flex items-center gap-2">
                <Select value={filterStatus} onValueChange={setFilterStatus}>
                  <SelectTrigger className="w-[150px]">
                    <SelectValue placeholder="Filter by status" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Status</SelectItem>
                    <SelectItem value="completed">Completed</SelectItem>
                    <SelectItem value="pending">Pending</SelectItem>
                    <SelectItem value="failed">Failed</SelectItem>
                  </SelectContent>
                </Select>

                <Button variant="outline" size="sm">
                  <Filter className="mr-2 h-4 w-4" />
                  More Filters
                </Button>
              </div>
            </div>

            <TabsContent value="all" className="space-y-4">
              <DataTable
                columns={columns}
                data={filteredTransactions}
                searchable={false}
                emptyMessage="No transactions found"
              />
            </TabsContent>

            <TabsContent value="commission" className="space-y-4">
              <DataTable
                columns={columns}
                data={filteredTransactions.filter((t) => t.type === "commission")}
                searchable={false}
                emptyMessage="No commission transactions found"
              />
            </TabsContent>

            <TabsContent value="payment" className="space-y-4">
              <DataTable
                columns={columns}
                data={filteredTransactions.filter((t) => t.type === "payment")}
                searchable={false}
                emptyMessage="No payment transactions found"
              />
            </TabsContent>

            <TabsContent value="refund" className="space-y-4">
              <DataTable
                columns={columns}
                data={filteredTransactions.filter((t) => t.type === "refund")}
                searchable={false}
                emptyMessage="No refund transactions found"
              />
            </TabsContent>

            <TabsContent value="adjustment" className="space-y-4">
              <DataTable
                columns={columns}
                data={filteredTransactions.filter((t) => t.type === "adjustment")}
                searchable={false}
                emptyMessage="No adjustment transactions found"
              />
            </TabsContent>
          </Tabs>
        </CardContent>
      </Card>
      </div>
    </AppLayout>
  );
};

export default PartnerTransactions;
