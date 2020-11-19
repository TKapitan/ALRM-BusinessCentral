page 80004 "C4BC Extension Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "C4BC Extension Line";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Object Type';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Object ID';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Object Name';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Created By';
                }

            }
        }
    }
}