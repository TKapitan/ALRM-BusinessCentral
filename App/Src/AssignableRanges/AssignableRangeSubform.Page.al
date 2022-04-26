/// <summary>
/// Page C4BC Assignable Range Subform (ID 80003).
/// </summary>
page 79503 "C4BC Assignable Range Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    DelayedInsert = true;
    SourceTable = "C4BC Assignable Range Line";

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
