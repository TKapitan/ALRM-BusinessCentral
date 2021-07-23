/// <summary>
/// Codeunit C4BC ALRM Installation (ID 80005).
/// </summary>
codeunit 80005 "C4BC ALRM Installation"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InitALRMSetup();
        InitObjectTypeConfiguration();
        FillEmptyExtensionObjectsID();
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

    local procedure InitObjectTypeConfiguration()
    var
        C4BCObjectType: Enum "C4BC Object Type";
    begin
        CreateObjectTypeConfiguration(C4BCObjectType::Table, 30, true, true, false);
        CreateObjectTypeConfiguration(C4BCObjectType::"Table Extension", 30, false, true, true);
        CreateObjectTypeConfiguration(C4BCObjectType::Page, 30, true, true, false);
        CreateObjectTypeConfiguration(C4BCObjectType::"Page Extension", 30, false, true, true);
        CreateObjectTypeConfiguration(C4BCObjectType::"Page Customization", 30, false, false, false);
        CreateObjectTypeConfiguration(C4BCObjectType::Codeunit, 30, true, true, false);
        CreateObjectTypeConfiguration(C4BCObjectType::Report, 30, true, true, false);
        CreateObjectTypeConfiguration(C4BCObjectType::"Report Extension", 30, false, true, true);
        CreateObjectTypeConfiguration(C4BCObjectType::"XML Port", 30, true, true, false);
        CreateObjectTypeConfiguration(C4BCObjectType::Query, 30, true, true, false);
        CreateObjectTypeConfiguration(C4BCObjectType::Enum, 30, false, true, false);
        CreateObjectTypeConfiguration(C4BCObjectType::"Enum Extension", 30, false, true, true);
        CreateObjectTypeConfiguration(C4BCObjectType::"Permission Set", 20, false, true, false);
        CreateObjectTypeConfiguration(C4BCObjectType::"Permission Set Extension", 20, false, true, true);
        CreateObjectTypeConfiguration(C4BCObjectType::Entitlement, 30, false, false, false);
        CreateObjectTypeConfiguration(C4BCObjectType::Profile, 30, false, false, false);
        CreateObjectTypeConfiguration(C4BCObjectType::Interface, 30, false, false, false);
        CreateObjectTypeConfiguration(C4BCObjectType::ControlAddin, 30, false, false, false);
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

    local procedure CreateObjectTypeConfiguration(C4BCObjectType: Enum "C4BC Object Type"; MaxNameLength: Integer; IsLicensed: Boolean; HasId: Boolean; ExtendsOtherObjects: Boolean)
    var
        C4BCObjectTypeConfiguration: Record "C4BC Object Type Configuration";
    begin
        if C4BCObjectTypeConfiguration.Get(C4BCObjectType) then
            exit;
        C4BCObjectTypeConfiguration.Init();
        C4BCObjectTypeConfiguration.Validate("Object Type", C4BCObjectType);
        C4BCObjectTypeConfiguration.Validate("Is Licensed", IsLicensed);
        C4BCObjectTypeConfiguration.Validate("Has ID", HasId);
        C4BCObjectTypeConfiguration.Validate("Extends Other Objects", ExtendsOtherObjects);
        C4BCObjectTypeConfiguration.Validate("Max Name Length", MaxNameLength);
        C4BCObjectTypeConfiguration.Insert(true);
    end;
}