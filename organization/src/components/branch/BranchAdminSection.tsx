 import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
 import { Input } from "@/components/ui/input";
 import { Label } from "@/components/ui/label";
 import { Button } from "@/components/ui/button";
 import { Upload, ShieldCheck } from "lucide-react";
 import { Switch } from "@/components/ui/switch";
 
 export function BranchAdminSection() {
   return (
     <div className="space-y-6">
       <Card>
         <CardHeader>
           <CardTitle>Branch Logo</CardTitle>
         </CardHeader>
         <CardContent>
           <div className="border-2 border-dashed border-border rounded-lg p-8 text-center">
             <Upload className="h-10 w-10 mx-auto text-muted-foreground mb-2" />
             <p className="text-sm text-muted-foreground mb-2">Upload branch logo</p>
             <Button variant="outline" size="sm">Choose File</Button>
             <p className="text-xs text-muted-foreground mt-2">PNG, JPG up to 2MB</p>
           </div>
         </CardContent>
       </Card>
 
       <Card>
         <CardHeader>
           <CardTitle className="flex items-center gap-2">
             <ShieldCheck className="h-5 w-5" />
             Branch Admin Credentials
           </CardTitle>
         </CardHeader>
         <CardContent className="space-y-4">
           <div className="space-y-2">
             <Label htmlFor="adminName">Admin Name *</Label>
             <Input id="adminName" placeholder="Branch admin name" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="adminUsername">Admin Username *</Label>
             <Input id="adminUsername" placeholder="admin_username" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="adminPassword">Admin Password *</Label>
             <Input id="adminPassword" type="password" placeholder="••••••••" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="adminEmail">Admin Email</Label>
             <Input id="adminEmail" type="email" placeholder="admin@example.com" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="adminPhone">Admin Phone</Label>
             <Input id="adminPhone" placeholder="+91 XXXXX XXXXX" />
           </div>
         </CardContent>
       </Card>
 
       <Card>
         <CardHeader>
           <CardTitle>Branch Settings</CardTitle>
         </CardHeader>
         <CardContent className="space-y-4">
           <div className="flex items-center justify-between">
             <div>
               <Label>Active Status</Label>
               <p className="text-xs text-muted-foreground">Enable/disable branch</p>
             </div>
             <Switch defaultChecked />
           </div>
           <div className="flex items-center justify-between">
             <div>
               <Label>Online Enrollment</Label>
               <p className="text-xs text-muted-foreground">Accept online admissions</p>
             </div>
             <Switch defaultChecked />
           </div>
           <div className="flex items-center justify-between">
             <div>
               <Label>SMS Notifications</Label>
               <p className="text-xs text-muted-foreground">Send SMS alerts</p>
             </div>
             <Switch />
           </div>
           <div className="flex items-center justify-between">
             <div>
               <Label>Email Notifications</Label>
               <p className="text-xs text-muted-foreground">Send email updates</p>
             </div>
             <Switch defaultChecked />
           </div>
         </CardContent>
       </Card>
     </div>
   );
 }