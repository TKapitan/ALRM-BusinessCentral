/// <summary>
/// PermissionSet C4BC ALRM Admin (ID 80000).
/// </summary>
permissionset 80000 "C4BC ALRM Admin"
{
    Caption = 'ALRM Admin';
    Assignable = true;
    IncludedPermissionSets = "C4BC ALRM User";

    Permissions =
    tabledata "C4BC ALRM Setup" = RIMD,
    tabledata "C4BC Assignable Range Header" = RIMD,
    tabledata "C4BC Assignable Range Line" = RIMD;
}