import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { StatsCard } from "@/components/ui/StatsCard";
 import { Wallet, CreditCard, Building2, History, Plus, ArrowUpRight, Search } from "lucide-react";
import { Badge } from "@/components/ui/badge";
 import { useState } from "react";
 
 interface Institute {
   id: string;
   name: string;
   directorName: string;
   balance: number;
 }
 
 const institutesData: Institute[] = [
   { id: "main", name: "Main Campus", directorName: "Dr. Rajesh Kumar", balance: 125000 },
   { id: "north", name: "North Campus", directorName: "Mrs. Priya Sharma", balance: 85000 },
   { id: "south", name: "South Campus", directorName: "Mr. Anand Patel", balance: 65000 },
   { id: "east", name: "East Campus", directorName: "Dr. Sanjay Gupta", balance: 45000 },
   { id: "west", name: "West Campus", directorName: "Mrs. Meera Singh", balance: 35000 },
 ];

const rechargeHistory = [
  { id: "1", branch: "Main Campus", amount: 50000, method: "UPI", date: "2024-01-15", status: "completed" },
  { id: "2", branch: "North Campus", amount: 30000, method: "Card", date: "2024-01-14", status: "completed" },
  { id: "3", branch: "South Campus", amount: 25000, method: "Net Banking", date: "2024-01-13", status: "pending" },
  { id: "4", branch: "East Campus", amount: 20000, method: "UPI", date: "2024-01-12", status: "completed" },
  { id: "5", branch: "Main Campus", amount: 45000, method: "Card", date: "2024-01-10", status: "failed" },
];

const quickAmounts = [5000, 10000, 25000, 50000, 100000];

export default function WalletRecharge() {
   const [searchQuery, setSearchQuery] = useState("");
   const [selectedInstitute, setSelectedInstitute] = useState<Institute | null>(null);
 
   const filteredInstitutes = institutesData.filter(
     (inst) =>
       inst.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
       inst.directorName.toLowerCase().includes(searchQuery.toLowerCase())
   );
 
  return (
    <AppLayout>
      <PageHeader
        title="Wallet Recharge"
        description="Recharge branch wallets for transactions"
        breadcrumbs={[
          { label: "Branch Management", href: "/branch/view" },
          { label: "Wallet Recharge" },
        ]}
      />

      <div className="grid gap-4 md:grid-cols-4 mb-6">
        <StatsCard
          title="Total Balance"
          value="₹4,85,000"
          subtitle="All branches combined"
          icon={Wallet}
          trend={{ value: 15, isPositive: true }}
        />
        <StatsCard
          title="This Month Recharge"
          value="₹1,70,000"
          subtitle="5 transactions"
          icon={CreditCard}
          trend={{ value: 8, isPositive: true }}
        />
        <StatsCard
          title="Pending Recharges"
          value="1"
          subtitle="₹25,000 pending"
          icon={History}
        />
        <StatsCard
          title="Active Branches"
          value="4"
          subtitle="With wallet enabled"
          icon={Building2}
        />
      </div>

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Plus className="h-5 w-5" />
                New Recharge
              </CardTitle>
              <CardDescription>Add funds to a branch wallet</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid gap-4 md:grid-cols-2">
                <div className="space-y-2">
                   <Label htmlFor="searchInstitute">Search Institute *</Label>
                   <div className="relative">
                     <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                     <Input
                       id="searchInstitute"
                       placeholder="Search by name or director..."
                       className="pl-9"
                       value={searchQuery}
                       onChange={(e) => setSearchQuery(e.target.value)}
                     />
                   </div>
                   {searchQuery && filteredInstitutes.length > 0 && (
                     <div className="border rounded-md mt-1 max-h-48 overflow-auto bg-background shadow-lg">
                       {filteredInstitutes.map((inst) => (
                         <div
                           key={inst.id}
                           className="p-3 hover:bg-muted cursor-pointer border-b last:border-b-0"
                           onClick={() => {
                             setSelectedInstitute(inst);
                             setSearchQuery(inst.name);
                           }}
                         >
                           <p className="font-medium text-sm">{inst.name}</p>
                           <p className="text-xs text-muted-foreground">Director: {inst.directorName}</p>
                           <p className="text-xs text-success">Balance: ₹{inst.balance.toLocaleString()}</p>
                         </div>
                       ))}
                     </div>
                   )}
                   {selectedInstitute && (
                     <div className="bg-muted/50 p-3 rounded-md mt-2">
                       <p className="text-sm font-medium">{selectedInstitute.name}</p>
                       <p className="text-xs text-muted-foreground">Director: {selectedInstitute.directorName}</p>
                       <p className="text-xs text-success">Current Balance: ₹{selectedInstitute.balance.toLocaleString()}</p>
                     </div>
                   )}
                </div>
                <div className="space-y-2">
                  <Label htmlFor="amount">Recharge Amount *</Label>
                  <Input id="amount" type="number" placeholder="Enter amount" />
                </div>
              </div>

              <div className="space-y-2">
                <Label>Quick Select Amount</Label>
                <div className="flex flex-wrap gap-2">
                  {quickAmounts.map((amount) => (
                    <Button key={amount} variant="outline" size="sm">
                      ₹{amount.toLocaleString()}
                    </Button>
                  ))}
                </div>
              </div>

              <div className="space-y-2">
                <Label>Payment Method</Label>
                <div className="grid gap-3 md:grid-cols-3">
                  <Card className="cursor-pointer border-2 hover:border-primary transition-colors">
                    <CardContent className="p-4 text-center">
                      <CreditCard className="h-6 w-6 mx-auto mb-2 text-primary" />
                      <p className="font-medium text-sm">Credit/Debit Card</p>
                    </CardContent>
                  </Card>
                  <Card className="cursor-pointer border-2 border-primary">
                    <CardContent className="p-4 text-center">
                      <Wallet className="h-6 w-6 mx-auto mb-2 text-primary" />
                      <p className="font-medium text-sm">UPI Payment</p>
                    </CardContent>
                  </Card>
                  <Card className="cursor-pointer border-2 hover:border-primary transition-colors">
                    <CardContent className="p-4 text-center">
                      <Building2 className="h-6 w-6 mx-auto mb-2 text-primary" />
                      <p className="font-medium text-sm">Net Banking</p>
                    </CardContent>
                  </Card>
                </div>
              </div>

              <div className="space-y-2">
                <Label htmlFor="remarks">Remarks (Optional)</Label>
                <Input id="remarks" placeholder="Add a note for this recharge" />
              </div>

              <div className="flex justify-end gap-3 pt-4">
                <Button variant="outline">Cancel</Button>
                <Button className="gap-2">
                  <ArrowUpRight className="h-4 w-4" />
                  Proceed to Payment
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <History className="h-5 w-5" />
                Recent Recharges
              </CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                {rechargeHistory.map((item) => (
                  <div key={item.id} className="flex items-center justify-between py-2 border-b last:border-0">
                    <div>
                      <p className="font-medium text-sm">{item.branch}</p>
                      <p className="text-xs text-muted-foreground">{item.date} • {item.method}</p>
                    </div>
                    <div className="text-right">
                      <p className="font-medium text-sm">₹{item.amount.toLocaleString()}</p>
                      <Badge 
                        variant={item.status === "completed" ? "default" : item.status === "pending" ? "secondary" : "destructive"}
                        className="text-xs"
                      >
                        {item.status}
                      </Badge>
                    </div>
                  </div>
                ))}
              </div>
              <Button variant="ghost" className="w-full mt-4" size="sm">
                View All Transactions
              </Button>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle>Branch Balances</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                 {institutesData.map((inst) => (
                   <div key={inst.id} className="flex items-center justify-between">
                     <div>
                       <span className="text-sm">{inst.name}</span>
                       <p className="text-xs text-muted-foreground">{inst.directorName}</p>
                     </div>
                     <span className="font-medium text-success">₹{inst.balance.toLocaleString()}</span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </AppLayout>
  );
}
