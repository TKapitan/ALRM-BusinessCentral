/// <summary>
/// Page C4BC Extension Object Lines (ID 80010).
/// </summary>
page 80010 "C4BC Extension Object Lines"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "C4BC Extension Object Line";
    Caption = 'Extension Object Lines';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ID; Rec."ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of the field or the enum value';
                }
            }
        }
    }
}