/// <summary>
/// Enum C4BC Object Type (ID 80000) implements Interface C4BC IObject Type.
/// </summary>
enum 80000 "C4BC Object Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = '';
    }
    value(5; "Table")
    {
        Caption = 'Table';
    }
    value(6; "Table Extension")
    {
        Caption = 'Table Extension';
    }
    value(10; "Page")
    {
        Caption = 'Page';
    }
    value(11; "Page Extension")
    {
        Caption = 'Page Extension';
    }
    value(12; "Page Customization")
    {
        Caption = 'Page Customization';
    }
    value(15; "Codeunit")
    {
        Caption = 'Codeunit';
    }
    value(20; "Report")
    {
        Caption = 'Report';
    }
    value(21; "Report Extension")
    {
        Caption = 'Report Extension';
    }
    value(25; "XML Port")
    {
        Caption = 'XML Port';
    }
    value(30; "Query")
    {
        Caption = 'Query';
    }
    value(35; "Enum")
    {
        Caption = 'Enum';
    }
    value(36; "Enum Extension")
    {
        Caption = 'Enum Extension';
    }
    value(40; "Permission Set")
    {
        Caption = 'Permission Set';
    }
    value(41; "Permission Set Extension")
    {
        Caption = 'Permission Set Extension';
    }
    value(45; "Entitlement")
    {
        Caption = 'Entitlement';
    }
    value(85; "Profile")
    {
        Caption = 'Profile';
    }
    value(90; "Interface")
    {
        Caption = 'Interface';
    }
    value(95; "ControlAddin")
    {
        Caption = 'Control Addin';
    }
}
