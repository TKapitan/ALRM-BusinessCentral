/// <summary>
/// PermissionSet C4BC ALRM API User (ID 80002).
/// </summary>
permissionset 80002 "C4BC ALRM API User"
{
    Caption = 'ALRM API User';
    Assignable = true;
    Permissions =
    table "C4BC ALRM Setup" = X,
    tabledata "C4BC ALRM Setup" = R,

    table "C4BC Object Type Configuration" = X,
    tabledata "C4BC Object Type Configuration" = R,

    table "C4BC Assignable Range Header" = X,
    tabledata "C4BC Assignable Range Header" = R,
    table "C4BC Assignable Range Line" = X,
    tabledata "C4BC Assignable Range Line" = R,
    page "C4BC Assignable Range API" = X,

    table "C4BC Business Central Instance" = X,
    tabledata "C4BC Business Central Instance" = R,

    table "C4BC Extension Header" = X,
    tabledata "C4BC Extension Header" = RIMD,
    table "C4BC Extension Object" = X,
    tabledata "C4BC Extension Object" = RIMD,
    table "C4BC Extension Object Line" = X,
    tabledata "C4BC Extension Object Line" = RIMD,
    page "C4BC Extension API" = X,
    page "C4BC Extension API v1.1" = X,
    page "C4BC Extension Obj.L. API v1.1" = X,
    page "C4BC Extension Object API" = X,
    page "C4BC Extension Object API v1.1" = X,
    page "C4BC Extension Object L. API" = X,

    table "C4BC Extension Usage" = X,
    tabledata "C4BC Extension Usage" = RIMD,

    codeunit "C4BC ALRM Management" = X,
    codeunit "C4BC Extension Object" = X,
    codeunit "C4BC Object Without ID" = X,
    codeunit "C4BC Standard Licensed Object" = X,
    codeunit "C4BC Standard Object" = X;
}
