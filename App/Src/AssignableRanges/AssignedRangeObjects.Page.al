/// <summary>
/// Page C4BC Assigned Range Objects (ID 80017).
/// </summary>
page 80017 "C4BC Assigned Range Objects"
{
    Caption = 'Assigned Range Object List';
    ApplicationArea = All;
    PageType = List;
    SourceTable = "C4BC Extension Object";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Extension Code"; Rec."Extension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Extension Code field';
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object Type field';
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object ID field';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object Name field';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field';
                }
                field("Extends Object Name"; Rec."Extends Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Extends Object Name field';
                }
            }
        }
    }
}
