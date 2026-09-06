import type { Branch, BranchStatus } from "../../../types/types.js";

/**
 * Detailed branch view entity with relation counts.
 */
export interface BranchWithDetails extends Branch {
  _count?: {
    users?: number;
    students?: number;
    teachers?: number;
  };
  creator?: {
    id: string;
    email: string;
    firstName?: string | null;
    lastName?: string | null;
  } | null;
}

/**
 * Paginated branches list query result.
 */
export interface PaginatedBranchesResult {
  data: BranchWithDetails[];
  stats: BranchStatsResult;
  meta: {
    total: number;
    page: number;
    limit: number;
    totalPages: number;
  };
}

/**
 * Aggregated branch metric statistics for KPI summary cards.
 */
export interface BranchStatsResult {
  totalBranches: number;
  activeBranches: number;
  inactiveBranches: number;
  totalStudents: number;
  totalStaff: number;
}
