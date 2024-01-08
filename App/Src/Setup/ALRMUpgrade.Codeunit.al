/// <summary>
/// Codeunit C4BC ALRM Upgrade (ID 80006).
/// </summary>
codeunit 80006 "C4BC ALRM Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        RunOnUpgradePerCompany();
    end;

    procedure RunOnUpgradePerCompany()
    begin
        InitObjectTypeConfiguration();
        FillEmptyExtensionObjectExtensionIDs();
        FillEmptyExtensionObjectLineExtensionIDs();
    end;

    local procedure InitObjectTypeConfiguration()
    var
        C4BCALRMInstallation: Codeunit "C4BC ALRM Installation";
    begin
        if UpgradeTag.HasUpgradeTag(InitObjectTypeConfigurationTok) then
            exit;
        C4BCALRMInstallation.InitObjectTypeConfiguration();
        UpgradeTag.SetUpgradeTag(InitObjectTypeConfigurationTok);
    end;

    local procedure FillEmptyExtensionObjectExtensionIDs()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        if UpgradeTag.HasUpgradeTag(FillEmptyExtensionObjectExtensionIDsTok) then
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

        UpgradeTag.SetUpgradeTag(FillEmptyExtensionObjectExtensionIDsTok);
    end;

    local procedure FillEmptyExtensionObjectLineExtensionIDs()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObjectLine: Record "C4BC Extension Object Line";
    begin
        if UpgradeTag.HasUpgradeTag(FillEmptyExtensionObjectLineExtensionIDsTok) then
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

        UpgradeTag.SetUpgradeTag(FillEmptyExtensionObjectLineExtensionIDsTok);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure OnGetPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(InitObjectTypeConfigurationTok);
        PerCompanyUpgradeTags.Add(FillEmptyExtensionObjectExtensionIDsTok);
        PerCompanyUpgradeTags.Add(FillEmptyExtensionObjectLineExtensionIDsTok);
    end;

    var
        UpgradeTag: Codeunit "Upgrade Tag";
        InitObjectTypeConfigurationTok: Label 'ALRM 001 - Init Object Type Configuration';
        FillEmptyExtensionObjectExtensionIDsTok: Label 'ALRM 002 - Fill Empty Extension Object Extension IDs';
        FillEmptyExtensionObjectLineExtensionIDsTok: Label 'ALRM 003 - Fill Empty Extension Object Line Extension IDs';
}
