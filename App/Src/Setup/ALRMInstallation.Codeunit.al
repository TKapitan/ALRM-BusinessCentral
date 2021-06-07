/// <summary>
/// Codeunit ART ALRM Installation (ID 74179005).
/// </summary>
codeunit 74179005 "ART ALRM Installation"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InitALRMSetup();
    end;

    local procedure InitALRMSetup()
    var
        ARTALRMSetup: Record "ART ALRM Setup";
    begin
        if not ARTALRMSetup.Get() then begin
            ARTALRMSetup.Init();
            ARTALRMSetup.Insert();
        end;
    end;
}