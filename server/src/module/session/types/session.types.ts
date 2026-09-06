export interface SessionCreatorSummary {
  id: string;
  firstName: string;
  lastName: string;
  email: string;
}

export interface BranchSummary {
  id: string;
  name: string;
  slug: string;
  code: string | null;
}

export interface BranchAcademicSessionWithDetails {
  id: string;
  academicSessionId: string;
  branchId: string;
  branch: BranchSummary;
  isCurrent: boolean;
  createdById: string | null;
  createdBy: SessionCreatorSummary | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface AcademicSessionWithDetails {
  id: string;
  organizationId: string;
  name: string;
  code: string | null;
  startYear: number;
  endYear: number;
  startDate: Date;
  endDate: Date;
  description: string | null;
  createdById: string | null;
  createdBy: SessionCreatorSummary | null;
  createdAt: Date;
  updatedAt: Date;
  branchMappings: BranchAcademicSessionWithDetails[];
}

export interface PaginatedSessionsResult {
  sessions: AcademicSessionWithDetails[];
  meta: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}
