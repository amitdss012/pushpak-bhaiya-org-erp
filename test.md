
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

//////////////////////////////////////////////////////////////
// ENUMS
//////////////////////////////////////////////////////////////

enum UserStatus {
  ACTIVE
  INACTIVE
  SUSPENDED
}

enum SessionStatus {
  ACTIVE
  REVOKED
  EXPIRED
}

enum BranchStatus {
  ACTIVE
  INACTIVE
}

enum StudentStatus {
  ACTIVE
  INACTIVE
  GRADUATED
  SUSPENDED
}

//////////////////////////////////////////////////////////////
// USER
//////////////////////////////////////////////////////////////

model User {

  id String @id @default(cuid())

  email String @unique

  passwordHash String

  firstName String

  lastName String?

  phone String?

  avatarUrl String?

  status UserStatus @default(ACTIVE)

  emailVerified Boolean @default(false)

  lastLoginAt DateTime?

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  sessions Session[]

  organizationMemberships OrganizationMember[]

  branchMemberships BranchMember[]

  student Student?

  @@index([email])

  @@index([status])

}

//////////////////////////////////////////////////////////////
// SESSION
//////////////////////////////////////////////////////////////

model Session {

  id String @id @default(cuid())

  userId String

  refreshTokenHash String @unique

  ipAddress String?

  userAgent String?

  expiresAt DateTime

  status SessionStatus @default(ACTIVE)

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  user User
  @relation(fields:[userId],references:[id],onDelete:Cascade)

  @@index([userId])

  @@index([expiresAt])

}

//////////////////////////////////////////////////////////////
// ORGANIZATION
//////////////////////////////////////////////////////////////

model Organization {

  id String @id @default(cuid())

  name String

  code String @unique

  logoUrl String?

  email String?

  phone String?

  website String?

  isActive Boolean @default(true)

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  branches Branch[]

  members OrganizationMember[]

  roles Role[]

}

//////////////////////////////////////////////////////////////
// BRANCH
//////////////////////////////////////////////////////////////

model Branch {

  id String @id @default(cuid())

  organizationId String

  name String

  code String

  email String?

  phone String?

  address String?

  status BranchStatus @default(ACTIVE)

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  organization Organization
  @relation(fields:[organizationId],references:[id],onDelete:Cascade)

  students Student[]

  members BranchMember[]

  @@unique([organizationId,code])

  @@index([organizationId])

  @@index([status])

}

//////////////////////////////////////////////////////////////
// STUDENT
//////////////////////////////////////////////////////////////

model Student {

  id String @id @default(cuid())

  userId String @unique

  branchId String

  admissionNumber String

  rollNumber String?

  status StudentStatus @default(ACTIVE)

  joinedAt DateTime @default(now())

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  user User
  @relation(fields:[userId],references:[id],onDelete:Cascade)

  branch Branch
  @relation(fields:[branchId],references:[id],onDelete:Cascade)

  @@unique([branchId,admissionNumber])

  @@unique([branchId,rollNumber])

  @@index([branchId])

  @@index([status])

}




//////////////////////////////////////////////////////////////
// ORGANIZATION MEMBER
//////////////////////////////////////////////////////////////

model OrganizationMember {

  id String @id @default(cuid())

  organizationId String

  userId String

  isOwner Boolean @default(false)

  joinedAt DateTime @default(now())

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  organization Organization
    @relation(fields: [organizationId], references: [id], onDelete: Cascade)

  user User
    @relation(fields: [userId], references: [id], onDelete: Cascade)

  roles OrganizationMemberRole[]

  @@unique([organizationId, userId])

  @@index([organizationId])

  @@index([userId])

}

//////////////////////////////////////////////////////////////
// BRANCH MEMBER
//////////////////////////////////////////////////////////////

model BranchMember {

  id String @id @default(cuid())

  branchId String

  userId String

  joinedAt DateTime @default(now())

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  branch Branch
    @relation(fields: [branchId], references: [id], onDelete: Cascade)

  user User
    @relation(fields: [userId], references: [id], onDelete: Cascade)

  roles BranchMemberRole[]

  @@unique([branchId, userId])

  @@index([branchId])

  @@index([userId])

}

//////////////////////////////////////////////////////////////
// ROLE
//////////////////////////////////////////////////////////////

model Role {

  id String @id @default(cuid())

  organizationId String

  name String

  description String?

  isSystem Boolean @default(false)

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  organization Organization
    @relation(fields: [organizationId], references: [id], onDelete: Cascade)

  permissions RolePermission[]

  organizationMembers OrganizationMemberRole[]

  branchMembers BranchMemberRole[]

  @@unique([organizationId, name])

  @@index([organizationId])

}

//////////////////////////////////////////////////////////////
// PERMISSION
//////////////////////////////////////////////////////////////

model Permission {

  id String @id @default(cuid())

  key String @unique

  name String

  description String?

  createdAt DateTime @default(now())

  updatedAt DateTime @updatedAt

  roles RolePermission[]

}

//////////////////////////////////////////////////////////////
// ROLE PERMISSION
//////////////////////////////////////////////////////////////

model RolePermission {

  roleId String

  permissionId String

  role Role
    @relation(fields: [roleId], references: [id], onDelete: Cascade)

  permission Permission
    @relation(fields: [permissionId], references: [id], onDelete: Cascade)

  @@id([roleId, permissionId])

  @@index([permissionId])

}

//////////////////////////////////////////////////////////////
// ORGANIZATION MEMBER ROLE
//////////////////////////////////////////////////////////////

model OrganizationMemberRole {

  organizationMemberId String

  roleId String

  assignedAt DateTime @default(now())

  organizationMember OrganizationMember
    @relation(fields: [organizationMemberId], references: [id], onDelete: Cascade)

  role Role
    @relation(fields: [roleId], references: [id], onDelete: Cascade)

  @@id([organizationMemberId, roleId])

  @@index([roleId])

}

//////////////////////////////////////////////////////////////
// BRANCH MEMBER ROLE
//////////////////////////////////////////////////////////////

model BranchMemberRole {

  branchMemberId String

  roleId String

  assignedAt DateTime @default(now())

  branchMember BranchMember
    @relation(fields: [branchMemberId], references: [id], onDelete: Cascade)

  role Role
    @relation(fields: [roleId], references: [id], onDelete: Cascade)

  @@id([branchMemberId, roleId])

  @@index([roleId])

}


