import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { CreditCard, Globe, Shield, CheckCircle, AlertCircle } from "lucide-react";

const PaymentGateway = () => {
  const gateways = [
    {
      id: "razorpay",
      name: "Razorpay",
      description: "Accept payments via UPI, Cards, Netbanking, Wallets",
      status: "connected",
      logo: "🔷",
    },
    {
      id: "paytm",
      name: "Paytm",
      description: "Accept payments via Paytm Wallet, UPI, Cards",
      status: "disconnected",
      logo: "💙",
    },
    {
      id: "stripe",
      name: "Stripe",
      description: "Global payment processing for cards and wallets",
      status: "disconnected",
      logo: "💳",
    },
    {
      id: "phonepe",
      name: "PhonePe",
      description: "Accept UPI payments via PhonePe",
      status: "disconnected",
      logo: "💜",
    },
  ];

  return (
    <AppLayout>
      <div className="space-y-6">
        <PageHeader
          title="Payment Gateway"
          description="Configure payment gateways for fee collection"
          breadcrumbs={[
            { label: "Settings", href: "/settings/general" },
            { label: "Payment Gateway" },
          ]}
        />

        <Tabs defaultValue="gateways" className="space-y-6">
          <TabsList>
            <TabsTrigger value="gateways">Payment Gateways</TabsTrigger>
            <TabsTrigger value="settings">Gateway Settings</TabsTrigger>
            <TabsTrigger value="transactions">Transaction Logs</TabsTrigger>
          </TabsList>

          <TabsContent value="gateways" className="space-y-6">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {gateways.map((gateway) => (
                <Card key={gateway.id}>
                  <CardHeader>
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className="text-3xl">{gateway.logo}</div>
                        <div>
                          <CardTitle className="text-lg">{gateway.name}</CardTitle>
                          <CardDescription>{gateway.description}</CardDescription>
                        </div>
                      </div>
                      <Badge variant={gateway.status === "connected" ? "default" : "secondary"}>
                        {gateway.status === "connected" ? (
                          <><CheckCircle className="h-3 w-3 mr-1" /> Connected</>
                        ) : (
                          <><AlertCircle className="h-3 w-3 mr-1" /> Not Connected</>
                        )}
                      </Badge>
                    </div>
                  </CardHeader>
                  <CardContent>
                    <div className="flex gap-2">
                      {gateway.status === "connected" ? (
                        <>
                          <Button variant="outline" size="sm">Configure</Button>
                          <Button variant="destructive" size="sm">Disconnect</Button>
                        </>
                      ) : (
                        <Button size="sm">Connect</Button>
                      )}
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="settings" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <CreditCard className="h-5 w-5" />
                  Razorpay Configuration
                </CardTitle>
                <CardDescription>
                  Configure your Razorpay API credentials
                </CardDescription>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="key-id">API Key ID</Label>
                    <Input id="key-id" placeholder="rzp_live_xxxxxxxxxx" type="password" />
                  </div>
                  <div className="space-y-2">
                    <Label htmlFor="key-secret">API Key Secret</Label>
                    <Input id="key-secret" placeholder="••••••••••••••••" type="password" />
                  </div>
                </div>

                <div className="flex items-center justify-between p-4 border rounded-lg">
                  <div className="flex items-center gap-3">
                    <Globe className="h-5 w-5 text-muted-foreground" />
                    <div>
                      <p className="font-medium">Test Mode</p>
                      <p className="text-sm text-muted-foreground">Use test credentials for development</p>
                    </div>
                  </div>
                  <Switch />
                </div>

                <div className="flex items-center justify-between p-4 border rounded-lg">
                  <div className="flex items-center gap-3">
                    <Shield className="h-5 w-5 text-muted-foreground" />
                    <div>
                      <p className="font-medium">Webhook Verification</p>
                      <p className="text-sm text-muted-foreground">Verify webhook signatures for security</p>
                    </div>
                  </div>
                  <Switch defaultChecked />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="webhook-secret">Webhook Secret</Label>
                  <Input id="webhook-secret" placeholder="whsec_xxxxxxxxxx" type="password" />
                </div>

                <Button>Save Configuration</Button>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="transactions" className="space-y-6">
            <Card>
              <CardHeader>
                <CardTitle>Recent Transactions</CardTitle>
                <CardDescription>View payment transaction history</CardDescription>
              </CardHeader>
              <CardContent>
                <div className="text-center py-8 text-muted-foreground">
                  <CreditCard className="h-12 w-12 mx-auto mb-4 opacity-50" />
                  <p>No transactions yet</p>
                  <p className="text-sm">Transactions will appear here once payments are processed</p>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </AppLayout>
  );
};

export default PaymentGateway;
