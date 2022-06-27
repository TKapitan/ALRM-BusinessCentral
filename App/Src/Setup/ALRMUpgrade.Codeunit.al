/// <summary>
/// Codeunit C4BC ALRM Upgrade (ID 80006).
/// </summary>
codeunit 80006 "C4BC ALRM Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        InitObjectTypeConfiguration();
        FillEmptyExtensionObjectExtensionIDs();
        FillEmptyExtensionObjectLineExtensionIDs();
    end;

    var
        UpgradeTag: Codeunit "Upgrade Tag";

    local procedure InitObjectTypeConfiguration()
    var
        C4BCALRMInstallation: Codeunit "C4BC ALRM Installation";
        UpgradeTagLbl: Label 'ALRM 001 - Init Object Type Configuration';
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagLbl) then
            exit;
        C4BCALRMInstallation.InitObjectTypeConfiguration();
        UpgradeTag.SetUpgradeTag(UpgradeTagLbl);
    end;

    local procedure FillEmptyExtensionObjectExtensionIDs()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObject: Record "C4BC Extension Object";
        UpgradeTagLbl: Label 'ALRM 002 - Fill Empty Extension Object Extension IDs';
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagLbl) then
            exit;

        if C4BCExtensionHeader.FindSet() then
                repeat
                    C4BCExtensionObject.SetRange("Extension Code", C4BCExtensionHeader.Code);
                    if C4BCExtensionObject.FindSet() then
                            repeat
                                if IsNullGuid(C4BCExtensionObject."Extension ID") then begin
                                    C4BCExtensionObject."Extension ID" := C4BCExtensionHeader.ID;
                                    C4BCExtensionObject.Modify(false);
                                end;
                            until C4BCExtensionObject.Next() < 1;
                until C4BCExtensionHeader.Next() < 1;

        UpgradeTag.SetUpgradeTag(UpgradeTagLbl);
    end;

    local procedure FillEmptyExtensionObjectLineExtensionIDs()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObjectLine: Record "C4BC Extension Object Line";
        UpgradeTagLbl: Label 'ALRM 003 - Fill Empty Extension Object Line Extension IDs';
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagLbl) then
            exit;

        if C4BCExtensionHeader.FindSet() then
            repeat
                    C4BCExtensionObjectLine.SetRange("Extension Code", C4BCExtensionHeader.Code);
                if C4BCExtensionObjectLine.FindSet() then
                    repeat
                            if IsNullGuid(C4BCExtensionObjectLine."Extension ID") then begin
                                C4BCExtensionObjectLine."Extension ID" := C4BCExtensionHeader.ID;
                                C4BCExtensionObjectLine.Modify(false);
                            end;
                    until C4BCExtensionObjectLine.Next() < 1;
            until C4BCExtensionHeader.Next() < 1;

        UpgradeTag.SetUpgradeTag(UpgradeTagLbl);
    end;
}