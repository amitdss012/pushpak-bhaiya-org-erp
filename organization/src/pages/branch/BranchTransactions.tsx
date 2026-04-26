import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { DataTable, Column } from "@/components/ui/DataTable";
import { StatsCard } from "@/components/ui/StatsCard";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ArrowUpRight, ArrowDownLeft, IndianRupee, TrendingUp, TrendingDown, Download } from "lucide-react";

interface Transaction {
  id: string;
  date: string;
  branch: string;
  type: "credit" | "debit";
  category: string;
  description: string;
  amount: number;
  balance: number;
  reference: string;
}

const transactionsData: Transaction[] = [
  { id: "1", date: "2024-01-15", branch: "Main Campus", type: "credit", category: "Fee Collection", description: "Student fee payment - Batch A", amount: 125000, balance: 485000, reference: "TXN001234" },
  { id: "2", date: "2024-01-15", branch: "Main Campus", type: "debit", category: "Salary", description: "Staff salary disbursement", amount: 85000, balance: 400000, reference: "TXN001235" },
  { id: "3", date: "2024-01-14", branch: "North Campus", type: "credit", category: "Fee Collection", description: "Exam fee collection", amount: 45000, balance: 485000, reference: "TXN001236" },
  { id: "4", date: "2024-01-14", branch: "South Campus", type: "debit", category: "Utilities", description: "Electricity bill payment", amount: 12000, balance: 53000, reference: "TXN001237" },
  { id: "5", date: "2024-01-13", branch: "Main Campus", type: "credit", category: "Wallet Recharge", description: "Admin wallet recharge", amount: 50000, balance: 485000, reference: "TXN001238" },
  { id: "6", date: "2024-01-13", branch: "East Campus", type: "debit", category: "Maintenance", description: "Building repair work", amount: 25000, balance: 45000, reference: "TXN001239" },
  { id: "7", date: "2024-01-12", branch: "North Campus", type: "credit", category: "Fee Collection", description: "Late fee payment - 15 students", amount: 7500, balance: 440000, reference: "TXN001240" },
  { id: "8", date: "2024-01-12", branch: "Main Campus", type: "debit", category: "Purchase", description: "Lab equipment purchase", amount: 35000, balance: 435000, reference: "TXN001241" },
];

const columns: Column<Transaction>[] = [
  {
    key: "date",
    header: "Date",
    sortable: true,
  },
  {
    key: "branch",
    header: "Branch",
    sortable: true,
  },
  {
    key: "type",
    header: "Type",
    cell: (txn) => (
      <div className="flex items-center gap-2">
        {txn.type === "credit" ? (
          <ArrowDownLeft className="h-4 w-4 text-success" />
        ) : (
          <ArrowUpRight className="h-4 w-4 text-destructive" />
        )}
        <Badge variant={txn.type === "credit" ? "default" : "secondary"}>
          {txn.type === "credit" ? "Credit" : "Debit"}
        </Badge>
      </div>
    ),
  },
  {
    key: "category",
    header: "Category",
    cell: (txn) => <Badge variant="outline">{txn.category}</Badge>,
  },
  {
    key: "description",
    header: "Description",
    cell: (txn) => (
      <div>
        <p className="text-sm">{txn.description}</p>
        <p className="text-xs text-muted-foreground">{txn.reference}</p>
      </div>
    ),
  },
  {
    key: "amount",
    header: "Amount",
    sortable: true,
    cell: (txn) => (
      <span className={`font-medium ${txn.type === "credit" ? "text-success" : "text-destructive"}`}>
        {txn.type === "credit" ? "+" : "-"}₹{txn.amount.toLocaleString()}
      </span>
    ),
  },
  {
    key: "balance",
    header: "Balance",
    cell: (txn) => <span className="font-medium">₹{txn.balance.toLocaleString()}</span>,
  },
];

export default function BranchTransactions() {
  const handleActions = (txn: Transaction) => [
    { label: "View Details", onClick: () => console.log("View", txn.id) },
    { label: "Download Receipt", onClick: () => console.log("Download", txn.id) },
    { label: "Print", onClick: () => console.log("Print", txn.id) },
  ];

  const totalCredits = transactionsData.filter(t => t.type === "credit").reduce((sum, t) => sum + t.amount, 0);
  const totalDebits = transactionsData.filter(t => t.type === "debit").reduce((sum, t) => sum + t.amount, 0);

  return (
    <AppLayout>
      <PageHeader
        title="Branch Transactions"
        description="View all financial transactions across branches"
        breadcrumbs={[
          { label: "Branch Management", href: "/branch/view" },
          { label: "Transactions" },
        ]}
        actions={
          <Button variant="outline" className="gap-2">
            <Download className="h-4 w-4" />
            Export
          </Button>
        }
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <StatsCard
          title="Total Transactions"
          value={transactionsData.length}
          subtitle="This month"
          icon={IndianRupee}
        />
        <StatsCard
          title="Total Credits"
          value={`₹${(totalCredits / 1000).toFixed(0)}K`}
          subtitle="Incoming funds"
          icon={TrendingUp}
          trend={{ value: 12, isPositive: true }}
        />
        <StatsCard
          title="Total Debits"
          value={`₹${(totalDebits / 1000).toFixed(0)}K`}
          subtitle="Outgoing funds"
          icon={TrendingDown}
          trend={{ value: 5, isPositive: false }}
        />
        <StatsCard
          title="Net Balance"
          value={`₹${((totalCredits - totalDebits) / 1000).toFixed(0)}K`}
          subtitle="Credits - Debits"
          icon={IndianRupee}
          trend={{ value: 8, isPositive: true }}
        />
      </div>

      <DataTable
        data={transactionsData}
        columns={columns}
        searchPlaceholder="Search transactions..."
        actions={handleActions}
      />
    </AppLayout>
  );
}
