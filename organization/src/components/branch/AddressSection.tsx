 import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
 import { Input } from "@/components/ui/input";
 import { Label } from "@/components/ui/label";
 import { Textarea } from "@/components/ui/textarea";
 import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
 import { MapPin } from "lucide-react";
 
 const states = [
   "Andhra Pradesh", "Bihar", "Delhi", "Gujarat", "Karnataka", 
   "Maharashtra", "Punjab", "Rajasthan", "Tamil Nadu", "Uttar Pradesh", "West Bengal"
 ];
 
 export function AddressSection() {
   return (
     <Card>
       <CardHeader>
         <CardTitle className="flex items-center gap-2">
           <MapPin className="h-5 w-5" />
           Address Details
         </CardTitle>
       </CardHeader>
       <CardContent className="space-y-4">
         <div className="space-y-2">
           <Label htmlFor="address">Street Address *</Label>
           <Textarea id="address" placeholder="Enter full address" rows={2} />
         </div>
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label htmlFor="state">State *</Label>
             <Select>
               <SelectTrigger>
                 <SelectValue placeholder="Select state" />
               </SelectTrigger>
               <SelectContent>
                 {states.map((state) => (
                   <SelectItem key={state} value={state.toLowerCase().replace(/\s/g, '-')}>
                     {state}
                   </SelectItem>
                 ))}
               </SelectContent>
             </Select>
           </div>
           <div className="space-y-2">
             <Label htmlFor="district">District *</Label>
             <Input id="district" placeholder="Enter district" />
           </div>
         </div>
         <div className="grid gap-4 md:grid-cols-3">
           <div className="space-y-2">
             <Label htmlFor="block">Block</Label>
             <Input id="block" placeholder="Enter block" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="city">City *</Label>
             <Input id="city" placeholder="City" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="pincode">Pincode *</Label>
             <Input id="pincode" placeholder="Pincode" />
           </div>
         </div>
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label htmlFor="latitude">Latitude</Label>
             <Input id="latitude" type="number" step="any" placeholder="e.g., 28.6139" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="longitude">Longitude</Label>
             <Input id="longitude" type="number" step="any" placeholder="e.g., 77.2090" />
           </div>
         </div>
         <div className="space-y-2">
           <Label htmlFor="country">Country</Label>
           <Select defaultValue="india">
             <SelectTrigger>
               <SelectValue placeholder="Select country" />
             </SelectTrigger>
             <SelectContent>
               <SelectItem value="india">India</SelectItem>
               <SelectItem value="usa">United States</SelectItem>
               <SelectItem value="uk">United Kingdom</SelectItem>
               <SelectItem value="canada">Canada</SelectItem>
             </SelectContent>
           </Select>
         </div>
       </CardContent>
     </Card>
   );
 }