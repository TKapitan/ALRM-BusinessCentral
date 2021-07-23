/// <summary>
/// Codeunit C4BC ALRM Upgrade (ID 80006).
/// </summary>
codeunit 80006 "C4BC ALRM Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        C4BCALRMInstallation: Codeunit "C4BC ALRM Installation";
        MyModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(MyModuleInfo);
        if MyModuleInfo.DataVersion < Version.Create(0, 1, 5, 2) then begin
            FillEmptyExtensionObjectsID();
            C4BCALRMInstallation.InitObjectTypeConfiguration();
        end;
    end;

    local procedure FillEmptyExtensionObjectsID()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObject: Record "C4BC Extension Object";

        EmptyGuid: Guid;
    begin
        if C4BCExtensionHeader.FindSet() then
            repeat
                if C4BCExtensionObject."Extension ID" = EmptyGuid then begin
                    C4BCExtensionObject."Extension ID" := C4BCExtensionHeader.ID;
                    C4BCExtensionObject.Modify(false);
                end;
            until C4BCExtensionHeader.Next() < 1;
    end;
}