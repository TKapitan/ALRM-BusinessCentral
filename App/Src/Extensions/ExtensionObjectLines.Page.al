/// <summary>
/// Page ART Extension Object Lines (ID 74179010).
/// </summary>
page 74179010 "ART Extension Object Lines"
{
    PageType = List;
    UsageCategory = None;
    SourceTable = "ART Extension Object Line";
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