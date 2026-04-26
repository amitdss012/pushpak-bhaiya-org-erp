 import { AppLayout } from "@/components/layout/AppLayout";
 import { PageHeader } from "@/components/ui/PageHeader";
 import { Button } from "@/components/ui/button";
 import { BranchInfoSection } from "@/components/branch/BranchInfoSection";
 import { AddressSection } from "@/components/branch/AddressSection";
 import { ContactSection } from "@/components/branch/ContactSection";
 import { DirectorInfoSection } from "@/components/branch/DirectorInfoSection";
 import { BranchSpaceSection } from "@/components/branch/BranchSpaceSection";
 import { BranchDocumentsSection } from "@/components/branch/BranchDocumentsSection";
 import { BranchAdminSection } from "@/components/branch/BranchAdminSection";
 
 export default function CreateBranch() {
   return (
     <AppLayout>
       <PageHeader
         title="Create Branch"
         description="Add a new branch to your institution"
         breadcrumbs={[
           { label: "Branch Management", href: "/branch/view" },
           { label: "Create Branch" },
         ]}
       />
 
       <div className="grid gap-6 lg:grid-cols-3">
         <div className="lg:col-span-2 space-y-6">
           <BranchInfoSection />
           <AddressSection />
           <ContactSection />
           <DirectorInfoSection />
           <BranchSpaceSection />
           <BranchDocumentsSection />
         </div>
 
         <BranchAdminSection />
       </div>
 
       <div className="flex justify-end gap-3 mt-6">
         <Button variant="outline">Cancel</Button>
         <Button>Create Branch</Button>
       </div>
     </AppLayout>
   );
 }
