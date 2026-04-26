 import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
 import { Label } from "@/components/ui/label";
 import { Button } from "@/components/ui/button";
 import { FileText, Upload } from "lucide-react";
 
 export function BranchDocumentsSection() {
   return (
     <Card>
       <CardHeader>
         <CardTitle className="flex items-center gap-2">
           <FileText className="h-5 w-5" />
           Branch Documents
         </CardTitle>
       </CardHeader>
       <CardContent className="space-y-4">
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label>Branch Mohar (Stamp)</Label>
             <div className="border-2 border-dashed border-border rounded-lg p-4 text-center">
               <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
               <p className="text-xs text-muted-foreground mb-2">Upload mohar/stamp</p>
               <Button variant="outline" size="sm">Choose File</Button>
             </div>
           </div>
           <div className="space-y-2">
             <Label>Branch Photo</Label>
             <div className="border-2 border-dashed border-border rounded-lg p-4 text-center">
               <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
               <p className="text-xs text-muted-foreground mb-2">Upload branch photo</p>
               <Button variant="outline" size="sm">Choose File</Button>
             </div>
           </div>
         </div>
         <div className="grid gap-4 md:grid-cols-2">
           <div className="space-y-2">
             <Label>Lab Photo</Label>
             <div className="border-2 border-dashed border-border rounded-lg p-4 text-center">
               <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
               <p className="text-xs text-muted-foreground mb-2">Upload lab photo</p>
               <Button variant="outline" size="sm">Choose File</Button>
             </div>
           </div>
           <div className="space-y-2">
             <Label>Status Document</Label>
             <div className="border-2 border-dashed border-border rounded-lg p-4 text-center">
               <Upload className="h-8 w-8 mx-auto text-muted-foreground mb-2" />
               <p className="text-xs text-muted-foreground mb-2">Upload status document</p>
               <Button variant="outline" size="sm">Choose File</Button>
             </div>
           </div>
         </div>
       </CardContent>
     </Card>
   );
 }