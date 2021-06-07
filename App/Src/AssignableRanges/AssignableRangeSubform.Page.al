/// <summary>
/// Page ART Assignable Range Subform (ID 74179003).
/// </summary>
page 74179003 "ART Assignable Range Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    DelayedInsert = true;
    SourceTable = "ART Assignable Range Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ToolTip = 'Specifies type of the object for which this range is specified.';
                    ApplicationArea = All;
                }
                field("Object Range From"; Rec."Object Range From")
                {
                    ToolTip = 'Specifies ID of the object that is the first assignable ID for selected object type.';
                    ApplicationArea = All;
                }
                field("Object Range To"; Rec."Object Range To")
                {
                    ToolTip = 'Specifies ID of the object that is the last assignable ID for selected object type.';
                    ApplicationArea = All;
                }
                field("Fill Object ID Gaps"; Rec."Fill Object ID Gaps")
                {
                    ToolTip = 'Specifies whether system should fill gaps in ID ranges when assigning new object ID. This can lead to slower performance of assigning process.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
