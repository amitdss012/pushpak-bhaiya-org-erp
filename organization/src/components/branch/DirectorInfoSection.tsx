 import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
 import { Input } from "@/components/ui/input";
 import { Label } from "@/components/ui/label";
 import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
 import { Button } from "@/components/ui/button";
 import { User, Upload } from "lucide-react";
 
 const bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];
 
 export function DirectorInfoSection() {
   return (
     <Card>
       <CardHeader>
         <CardTitle className="flex items-center gap-2">
           <User className="h-5 w-5" />
           Director Information
         </CardTitle>
       </CardHeader>
       <CardContent className="space-y-4">
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label htmlFor="directorName">Director Name *</Label>
             <Input id="directorName" placeholder="Enter director name" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="directorGender">Gender *</Label>
             <Select>
               <SelectTrigger>
                 <SelectValue placeholder="Select gender" />
               </SelectTrigger>
               <SelectContent>
                 <SelectItem value="male">Male</SelectItem>
                 <SelectItem value="female">Female</SelectItem>
                 <SelectItem value="other">Other</SelectItem>
               </SelectContent>
             </Select>
           </div>
         </div>
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label htmlFor="directorDOB">Date of Birth *</Label>
             <Input id="directorDOB" type="date" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="directorBloodGroup">Blood Group</Label>
             <Select>
               <SelectTrigger>
                 <SelectValue placeholder="Select blood group" />
               </SelectTrigger>
               <SelectContent>
                 {bloodGroups.map((group) => (
                   <SelectItem key={group} value={group.toLowerCase()}>
                     {group}
                   </SelectItem>
                 ))}
               </SelectContent>
             </Select>
           </div>
         </div>
 
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label>Director Photo</Label>
             <div className="border-2 border-dashed border-border rounded-lg p-4 text-center">
               <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
               <p className="text-xs text-muted-foreground mb-2">Upload photo</p>
               <Button variant="outline" size="sm">Choose File</Button>
             </div>
           </div>
           <div className="space-y-2">
             <Label>Director Signature</Label>
             <div className="border-2 border-dashed border-border rounded-lg p-4 text-center">
               <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
               <p className="text-xs text-muted-foreground mb-2">Upload signature</p>
               <Button variant="outline" size="sm">Choose File</Button>
             </div>
           </div>
         </div>
 
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label>Aadhar Card (Front)</Label>
             <div className="border-2 border-dashed border-border rounded-lg p-4 text-center">
               <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
               <p className="text-xs text-muted-foreground mb-2">Upload front side</p>
               <Button variant="outline" size="sm">Choose File</Button>
             </div>
           </div>
           <div className="space-y-2">
             <Label>Aadhar Card (Back)</Label>
             <div className="border-2 border-dashed border-border rounded-lg p-4 text-center">
               <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
               <p className="text-xs text-muted-foreground mb-2">Upload back side</p>
               <Button variant="outline" size="sm">Choose File</Button>
             </div>
           </div>
         </div>
       </CardContent>
     </Card>
   );
 }