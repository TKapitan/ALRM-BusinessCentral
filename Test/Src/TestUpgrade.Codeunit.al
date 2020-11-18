codeunit 50101 "C4BC Test Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        C4BCTestInstall: Codeunit "C4BC Test Install";
    begin
        C4BCTestInstall.SetupTestSuite();
    end;
}