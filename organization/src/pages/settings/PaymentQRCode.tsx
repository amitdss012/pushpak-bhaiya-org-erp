import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { QrCode, Upload, Download, Eye, Trash2 } from "lucide-react";

const PaymentQRCode = () => {
  const existingQRCodes = [
    { id: 1, name: "Main Account UPI", upiId: "school@upi", isActive: true },
    { id: 2, name: "Fee Collection", upiId: "schoolfee@paytm", isActive: true },
    { id: 3, name: "Hostel Fees", upiId: "hostel@upi", isActive: false },
  ];

  return (
    <AppLayout>
      <div className="space-y-6">
        <PageHeader
          title="Payment QR Code"
          description="Configure UPI QR codes for payment collection"
          breadcrumbs={[
            { label: "Settings", href: "/settings/general" },
            { label: "Payment QR Code" },
          ]}
        />

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Create New QR Code */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <QrCode className="h-5 w-5" />
                Create QR Code
              </CardTitle>
              <CardDescription>
                Generate a new payment QR code for fee collection
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="qr-name">QR Code Name</Label>
                <Input id="qr-name" placeholder="e.g., Main Fee Collection" />
              </div>

              <div className="space-y-2">
                <Label htmlFor="upi-id">UPI ID</Label>
                <Input id="upi-id" placeholder="e.g., school@upi" />
              </div>

              <div className="space-y-2">
                <Label htmlFor="merchant-name">Merchant Name</Label>
                <Input id="merchant-name" placeholder="School Name" />
              </div>

              <div className="space-y-2">
                <Label htmlFor="payment-type">Payment Type</Label>
                <Select>
                  <SelectTrigger>
                    <SelectValue placeholder="Select payment type" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="static">Static QR (Fixed Amount)</SelectItem>
                    <SelectItem value="dynamic">Dynamic QR (Variable Amount)</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label htmlFor="amount">Default Amount (Optional)</Label>
                <Input id="amount" type="number" placeholder="0.00" />
              </div>

              <div className="space-y-2">
                <Label htmlFor="description">Payment Description</Label>
                <Textarea id="description" placeholder="Fee payment for..." />
              </div>

              <div className="flex items-center justify-between p-4 border rounded-lg">
                <div>
                  <p className="font-medium">Set as Primary</p>
                  <p className="text-sm text-muted-foreground">Use as default payment QR</p>
                </div>
                <Switch />
              </div>

              <div className="space-y-2">
                <Label>Or Upload Existing QR</Label>
                <div className="border-2 border-dashed rounded-lg p-6 text-center">
                  <Upload className="h-8 w-8 mx-auto mb-2 text-muted-foreground" />
                  <p className="text-sm text-muted-foreground">
                    Click to upload or drag and drop
                  </p>
                  <p className="text-xs text-muted-foreground mt-1">
                    PNG, JPG up to 5MB
                  </p>
                </div>
              </div>

              <Button className="w-full">Generate QR Code</Button>
            </CardContent>
          </Card>

          {/* QR Preview */}
          <Card>
            <CardHeader>
              <CardTitle>QR Code Preview</CardTitle>
              <CardDescription>
                Preview of the generated QR code
              </CardDescription>
            </CardHeader>
            <CardContent className="flex flex-col items-center justify-center py-8">
              <div className="w-48 h-48 border-2 border-dashed rounded-lg flex items-center justify-center bg-muted/50">
                <QrCode className="h-24 w-24 text-muted-foreground" />
              </div>
              <p className="mt-4 text-sm text-muted-foreground">
                QR code will appear here after generation
              </p>
              <div className="flex gap-2 mt-4">
                <Button variant="outline" size="sm" disabled>
                  <Download className="h-4 w-4 mr-2" />
                  Download
                </Button>
                <Button variant="outline" size="sm" disabled>
                  <Eye className="h-4 w-4 mr-2" />
                  Print
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Existing QR Codes */}
        <Card>
          <CardHeader>
            <CardTitle>Existing QR Codes</CardTitle>
            <CardDescription>Manage your payment QR codes</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {existingQRCodes.map((qr) => (
                <div key={qr.id} className="flex items-center justify-between p-4 border rounded-lg">
                  <div className="flex items-center gap-4">
                    <div className="w-12 h-12 bg-muted rounded-lg flex items-center justify-center">
                      <QrCode className="h-6 w-6" />
                    </div>
                    <div>
                      <p className="font-medium">{qr.name}</p>
                      <p className="text-sm text-muted-foreground">{qr.upiId}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-4">
                    <Switch checked={qr.isActive} />
                    <Button variant="ghost" size="icon">
                      <Download className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon">
                      <Eye className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" className="text-destructive">
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </AppLayout>
  );
};

export default PaymentQRCode;
