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
        C4BCBCInstanceForAssignableRanges20240108();
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

    local procedure C4BCBCInstanceForAssignableRanges20240108()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionUsage: Record "C4BC Extension Usage";
    begin
        if UpgradeTag.HasUpgradeTag(C4BCBCInstanceForAssignableRanges20240108Tok) then
            exit;

        C4BCAssignableRangeHeader.SetRange("Ranges per BC Instance", true);
        if C4BCAssignableRangeHeader.FindSet() then
            repeat
                C4BCExtensionHeader.SetRange("Assignable Range Code", C4BCAssignableRangeHeader.Code);
                if C4BCExtensionHeader.FindSet() then
                    repeat
                        C4BCExtensionUsage.SetRange("Extension Code", C4BCExtensionHeader.Code);
                        if C4BCExtensionUsage.FindFirst() then begin
                            C4BCExtensionHeader.Validate("BC Instance for Assign. Range", C4BCExtensionUsage."Business Central Instance Code");
                            C4BCExtensionHeader.Modify();
                        end;
                    until C4BCExtensionHeader.Next() < 1;
            until C4BCAssignableRangeHeader.Next() < 1;

        UpgradeTag.SetUpgradeTag(C4BCBCInstanceForAssignableRanges20240108Tok);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", 'OnGetPerCompanyUpgradeTags', '', false, false)]
    local procedure OnGetPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(InitObjectTypeConfigurationTok);
        PerCompanyUpgradeTags.Add(FillEmptyExtensionObjectExtensionIDsTok);
        PerCompanyUpgradeTags.Add(FillEmptyExtensionObjectLineExtensionIDsTok);
        PerCompanyUpgradeTags.Add(C4BCBCInstanceForAssignableRanges20240108Tok);
    end;

    var
        UpgradeTag: Codeunit "Upgrade Tag";
        InitObjectTypeConfigurationTok: Label 'ALRM 001 - Init Object Type Configuration', Locked = true;
        FillEmptyExtensionObjectExtensionIDsTok: Label 'ALRM 002 - Fill Empty Extension Object Extension IDs', Locked = true;
        FillEmptyExtensionObjectLineExtensionIDsTok: Label 'ALRM 003 - Fill Empty Extension Object Line Extension IDs', Locked = true;
        C4BCBCInstanceForAssignableRanges20240108Tok: Label 'C4BC-BCInstanceForAssignableRanges-20240108', Locked = true;
}
