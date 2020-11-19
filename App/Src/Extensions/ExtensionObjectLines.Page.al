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
                field("Field ID"; Rec."ID")
                {
                    ApplicationArea = All;
                }
                field("Field Name"; Rec."Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}