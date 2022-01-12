/// <summary>
/// PermissionSet C4BC ALRM User (ID 80001).
/// </summary>
permissionset 80001 "C4BC ALRM User"
{
    Caption = 'ALRM User';
    Assignable = true;
    Permissions =
    table "C4BC ALRM Setup" = X,
    tabledata "C4BC ALRM Setup" = R,
    page "C4BC ALRM Setup" = X,

    table "C4BC Object Type Configuration" = X,
    tabledata "C4BC Object Type Configuration" = R,
    page "C4BC Object Type Config." = X,

    table "C4BC Assignable Range Header" = X,
    tabledata "C4BC Assignable Range Header" = R,
    table "C4BC Assignable Range Line" = X,
    tabledata "C4BC Assignable Range Line" = R,
    page "C4BC Assignable Range Card" = X,
    page "C4BC Assignable Range List" = X,
    page "C4BC Assignable Range Subform" = X,
    page "C4BC Assigned Range Objects" = X,

    table "C4BC Business Central Instance" = X,
    tabledata "C4BC Business Central Instance" = R,
    page "C4BC Bus. Central Inst. List" = X,

    table "C4BC Extension Header" = X,
    tabledata "C4BC Extension Header" = RIMD,
    table "C4BC Extension Object" = X,
    tabledata "C4BC Extension Object" = RIMD,
    table "C4BC Extension Object Line" = X,
    tabledata "C4BC Extension Object Line" = RIMD,
    page "C4BC Extension Card" = X,
    page "C4BC Extension List" = X,
    page "C4BC Extension Object Lines" = X,
    page "C4BC Extension Subform" = X,

    table "C4BC Extension Usage" = X,
    tabledata "C4BC Extension Usage" = RIMD,
    page "C4BC Extension Usage List" = X,

    codeunit "C4BC ALRM Management" = X,

    report "C4BC Create License File" = X;
}