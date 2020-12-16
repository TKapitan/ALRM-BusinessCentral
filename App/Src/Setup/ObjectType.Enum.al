enum 80000 "C4BC Object Type" implements "C4BC IObject Type"
{
    Extensible = true;
    DefaultImplementation = "C4BC IObject Type" = "C4BC Standard Object";

    value(0; " ")
    {
        Caption = '';
    }
    value(5; "Table")
    {
        Caption = 'Table';
        Implementation = "C4BC IObject Type" = "C4BC Standard Licensed Object";
    }
    value(6; "Table Extension")
    {
        Caption = 'Table Extension';
    }
    value(10; "Page")
    {
        Caption = 'Page';
        Implementation = "C4BC IObject Type" = "C4BC Standard Licensed Object";
    }
    value(11; "Page Extension")
    {
        Caption = 'Page Extension';
    }
    value(15; "Codeunit")
    {
        Caption = 'Codeunit';
        Implementation = "C4BC IObject Type" = "C4BC Standard Licensed Object";
    }
    value(20; "Report")
    {
        Caption = 'Report';
        Implementation = "C4BC IObject Type" = "C4BC Standard Licensed Object";
    }
    value(25; "XML Port")
    {
        Caption = 'XML Port';
        Implementation = "C4BC IObject Type" = "C4BC Standard Licensed Object";
    }
    value(30; "Query")
    {
        Caption = 'Query';
        Implementation = "C4BC IObject Type" = "C4BC Standard Licensed Object";
    }
    value(35; "Enum")
    {
        Caption = 'Enum';
    }
    value(36; "Enum Extension")
    {
        Caption = 'Enum Extension';
    }
    value(90; "Interface")
    {
        Caption = 'Interface';
        Implementation = "C4BC IObject Type" = "C4BC Object Without ID";
    }
}
