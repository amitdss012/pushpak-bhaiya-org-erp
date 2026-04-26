 import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
 import { Input } from "@/components/ui/input";
 import { Label } from "@/components/ui/label";
 import { Textarea } from "@/components/ui/textarea";
 import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
 import { Building2 } from "lucide-react";
 
 const instituteTypes = [
   { value: "computer", label: "Computer Institute" },
   { value: "typing", label: "Typing Institute" },
   { value: "paramedical", label: "Paramedical Institute" },
   { value: "other", label: "Other" },
 ];
 
 const academicYears = [
   "2024-25", "2025-26", "2026-27", "2027-28"
 ];
 
 export function BranchInfoSection() {
   return (
     <Card>
       <CardHeader>
         <CardTitle className="flex items-center gap-2">
           <Building2 className="h-5 w-5" />
           Branch Information
         </CardTitle>
       </CardHeader>
       <CardContent className="space-y-4">
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label htmlFor="branchName">Branch Name *</Label>
             <Input id="branchName" placeholder="Enter branch name" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="branchCode">Branch Code *</Label>
             <Input id="branchCode" placeholder="e.g., BR001" />
           </div>
         </div>
         <div className="grid gap-4 md:grid-cols-3">
           <div className="space-y-2">
             <Label htmlFor="branchType">Branch Type</Label>
             <Select>
               <SelectTrigger>
                 <SelectValue placeholder="Select type" />
               </SelectTrigger>
               <SelectContent>
                 <SelectItem value="main">Main Branch</SelectItem>
                 <SelectItem value="sub">Sub Branch</SelectItem>
                 <SelectItem value="franchise">Franchise</SelectItem>
               </SelectContent>
             </Select>
           </div>
           <div className="space-y-2">
             <Label htmlFor="instituteType">Institute Type *</Label>
             <Select>
               <SelectTrigger>
                 <SelectValue placeholder="Select institute type" />
               </SelectTrigger>
               <SelectContent>
                 {instituteTypes.map((type) => (
                   <SelectItem key={type.value} value={type.value}>
                     {type.label}
                   </SelectItem>
                 ))}
               </SelectContent>
             </Select>
           </div>
           <div className="space-y-2">
             <Label htmlFor="academicYear">Academic Year *</Label>
             <Select>
               <SelectTrigger>
                 <SelectValue placeholder="Select academic year" />
               </SelectTrigger>
               <SelectContent>
                 {academicYears.map((year) => (
                   <SelectItem key={year} value={year}>
                     {year}
                   </SelectItem>
                 ))}
               </SelectContent>
             </Select>
           </div>
         </div>
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label htmlFor="establishedYear">Established Year</Label>
             <Input id="establishedYear" type="number" placeholder="e.g., 2020" />
           </div>
           <div className="space-y-2">
             <Label htmlFor="website">Website</Label>
             <Input id="website" placeholder="https://branch.example.com" />
           </div>
         </div>
         <div className="space-y-2">
           <Label htmlFor="description">Description</Label>
           <Textarea id="description" placeholder="Brief description of the branch" rows={3} />
         </div>
       </CardContent>
     </Card>
   );
 }