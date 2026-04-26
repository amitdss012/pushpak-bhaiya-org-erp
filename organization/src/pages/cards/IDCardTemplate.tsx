import { AppLayout } from "@/components/layout/AppLayout";
import { PageHeader } from "@/components/ui/PageHeader";
import { EmptyState } from "@/components/ui/EmptyState";
import { LayoutTemplate } from "lucide-react";

export default function IDCardTemplate() {
  return (
    <AppLayout>
      <PageHeader
        title="ID Card Template"
        description="Design and customize student ID card templates"
        breadcrumbs={[
          { label: "ID & Admit Card", href: "/cards/id-template" },
          { label: "ID Card Template" },
        ]}
      />

      <EmptyState
        icon={LayoutTemplate}
        title="ID Card Template Builder"
        description="Create custom ID card templates with drag-and-drop interface. Add student photo, name, roll number, and other fields."
        action={{
          label: "Create New Template",
          onClick: () => console.log("Create template"),
        }}
      />
    </AppLayout>
  );
}
