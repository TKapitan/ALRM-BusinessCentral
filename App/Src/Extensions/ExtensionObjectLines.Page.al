/// <summary>
/// Page C4BC Extension Object Lines (ID 80010).
/// </summary>
page 79510 "C4BC Extension Object Lines"
{
    PageType = List;
    UsageCategory = None;
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
                field("Alternate ID"; Rec."Alternate ID")
                {
                    ToolTip = 'Specifies alternate ID of the field. Alternate ID is not mandatory and can be generated only when the extension has alternate assignable range defined.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies name of the field. The evidence of field names is optional.';
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies user who created this record (who requested new object line ID).';
                }
            }
        }
    }
}