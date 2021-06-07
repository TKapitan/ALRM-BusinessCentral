/// <summary>
/// Enum ART Object Type (ID 74179000) implements Interface ART IObject Type.
/// </summary>
enum 74179000 "ART Object Type" implements "ART IObject Type"
{
    Extensible = true;
    DefaultImplementation = "ART IObject Type" = "ART Standard Object";

    value(0; " ")
    {
        Caption = '';
    }
    value(5; "Table")
    {
        Caption = 'Table';
        Implementation = "ART IObject Type" = "ART Standard Licensed Object";
    }
    value(6; "Table Extension")
    {
        Caption = 'Table Extension';
        Implementation = "ART IObject Type" = "ART Extension Object";
    }
    value(10; "Page")
    {
        Caption = 'Page';
        Implementation = "ART IObject Type" = "ART Standard Licensed Object";
    }
    value(11; "Page Extension")
    {
        Caption = 'Page Extension';
        Implementation = "ART IObject Type" = "ART Extension Object";
    }
    value(12; "Page Customization")
    {
        Caption = 'Page Customization';
        Implementation = "ART IObject Type" = "ART Object Without ID";
    }
    value(15; "Codeunit")
    {
        Caption = 'Codeunit';
        Implementation = "ART IObject Type" = "ART Standard Licensed Object";
    }
    value(20; "Report")
    {
        Caption = 'Report';
        Implementation = "ART IObject Type" = "ART Standard Licensed Object";
    }
    value(21; "Report Extension")
    {
        Caption = 'Report Extension';
        Implementation = "ART IObject Type" = "ART Extension Object";
    }
    value(25; "XML Port")
    {
        Caption = 'XML Port';
        Implementation = "ART IObject Type" = "ART Standard Licensed Object";
    }
    value(30; "Query")
    {
        Caption = 'Query';
        Implementation = "ART IObject Type" = "ART Standard Licensed Object";
    }
    value(35; "Enum")
    {
        Caption = 'Enum';
    }
    value(36; "Enum Extension")
    {
        Caption = 'Enum Extension';
        Implementation = "ART IObject Type" = "ART Extension Object";
    }
    value(40; "Permission Set")
    {
        Caption = 'Permission Set';
    }
    value(41; "Permission Set Extension")
    {
        Caption = 'Permission Set Extension';
        Implementation = "ART IObject Type" = "ART Extension Object";
    }
    value(45; "Entitlement")
    {
        Caption = 'Entitlement';
        Implementation = "ART IObject Type" = "ART Object Without ID";
    }
    value(85; "Profile")
    {
        Caption = 'Profile';
        Implementation = "ART IObject Type" = "ART Object Without ID";
    }
    value(90; "Interface")
    {
        Caption = 'Interface';
        Implementation = "ART IObject Type" = "ART Object Without ID";
    }
    value(95; "ControlAddin")
    {
        Caption = 'Control Addin';
        Implementation = "ART IObject Type" = "ART Object Without ID";
    }
}
