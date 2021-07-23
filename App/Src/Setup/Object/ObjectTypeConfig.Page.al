/// <summary>
/// Page C4BC Object Type Config. (ID 80018).
/// </summary>
page 80018 "C4BC Object Type Config."
{
    Caption = 'Object Type Configurations';
    PageType = List;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;
    SourceTable = "C4BC Object Type Configuration";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ToolTip = 'Specifies type of object.';
                    ApplicationArea = All;
                }
                field("Max Name Length"; Rec."Max Name Length")
                {
                    ToolTip = 'Specifies maximal length for name of the object.';
                    ApplicationArea = All;
                }
                field("Is Licensed"; Rec."Is Licensed")
                {
                    ToolTip = 'Specifies whether the object type is licensed. Only licensed object types are included into license export.';
                    ApplicationArea = All;
                }
                field("Has ID"; Rec."Has ID")
                {
                    ToolTip = 'Specifies whether the object type uses ID for its identification.';
                    ApplicationArea = All;
                }
                field("Extends Other Objects"; Rec."Extends Other Objects")
                {
                    ToolTip = 'Specifies whether object type extends some of others object types.';
                    ApplicationArea = All;
                }
            }
        }
    }

}
