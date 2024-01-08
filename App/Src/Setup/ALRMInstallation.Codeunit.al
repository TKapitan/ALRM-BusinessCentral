/// <summary>
/// Codeunit C4BC ALRM Installation (ID 80005).
/// </summary>
codeunit 80005 "C4BC ALRM Installation"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        ALRMUpgrade: Codeunit "C4BC ALRM Upgrade";
        ModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(ModuleInfo);
        if ModuleInfo.DataVersion = Version.Create(0, 0, 0, 0) then
            RunOnInstallAppPerCompanyFreshInstall()
        else
            ALRMUpgrade.RunOnUpgradePerCompany();
    end;

    procedure RunOnInstallAppPerCompanyFreshInstall()
    begin
        InitALRMSetup();
        InitObjectTypeConfiguration();

        UpgradeTag.SetAllUpgradeTags();
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

    /// <summary>
    /// Init records in "C4BC Object Type Configuration" tables with default setting for each object type.
    /// </summary>
    procedure InitObjectTypeConfiguration()
    var
        C4BCObjectType: Enum "C4BC Object Type";
    begin
        CreateObjectTypeConfiguration(C4BCObjectType::Table, 30, true, true, false, 50000, 50009);
        CreateObjectTypeConfiguration(C4BCObjectType::"Table Extension", 30, false, true, true, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::Page, 30, true, true, false, 50000, 50099);
        CreateObjectTypeConfiguration(C4BCObjectType::"Page Extension", 30, false, true, true, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::"Page Customization", 30, false, false, false, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::Codeunit, 30, true, true, false, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::Report, 30, true, true, false, 50000, 50099);
        CreateObjectTypeConfiguration(C4BCObjectType::"Report Extension", 30, false, true, true, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::"XML Port", 30, true, true, false, 50000, 50099);
        CreateObjectTypeConfiguration(C4BCObjectType::Query, 30, true, true, false, 50000, 50099);
        CreateObjectTypeConfiguration(C4BCObjectType::Enum, 30, false, true, false, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::"Enum Extension", 30, false, true, true, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::"Permission Set", 20, false, true, false, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::"Permission Set Extension", 20, false, true, true, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::Entitlement, 30, false, false, false, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::Profile, 30, false, false, false, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::Interface, 30, false, false, false, 0, 0);
        CreateObjectTypeConfiguration(C4BCObjectType::ControlAddin, 30, false, false, false, 0, 0);
    end;

    local procedure CreateObjectTypeConfiguration
    (
        C4BCObjectType: Enum "C4BC Object Type";
        MaxNameLength: Integer;
        IsLicensed: Boolean;
        HasId: Boolean;
        ExtendsOtherObjects: Boolean;
        IncludedObjectIDFrom: Integer;
        IncludedObjectIDTo: Integer
    )
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
        C4BCObjectTypeConfiguration.Validate("Included Object ID From", IncludedObjectIDFrom);
        C4BCObjectTypeConfiguration.Validate("Included Object ID To", IncludedObjectIDTo);
        C4BCObjectTypeConfiguration.Insert(true);
    end;

    var
        UpgradeTag: Codeunit "Upgrade Tag";
}