/// <summary>
/// Codeunit C4BC ALRM Installation (ID 80005).
/// </summary>
codeunit 80005 "C4BC ALRM Installation"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InitALRMSetup();
    end;

    local procedure InitALRMSetup()
    var
        C4BCALRMSetup: Record "C4BC ALRM Setup";
    begin
        if not C4BCALRMSetup.Get() then begin
            C4BCALRMSetup.Init();
            C4BCALRMSetup.Insert();
        end;
    end;
}