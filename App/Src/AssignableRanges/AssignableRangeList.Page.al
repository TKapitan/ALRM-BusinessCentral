page 80001 "C4BC Assignable Range List"
{
    Caption = 'Assignable Ranges';
    PageType = List;
    Editable = false;
    UsageCategory = Lists;
    CardPageId = "C4BC Assignable Range Card";
    SourceTable = "C4BC Assignable Range Header";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies code of the assignable range. This Code is used in the initial API request, when the new project is initialized to specify used ranges.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies description of the assignable range.';
                    ApplicationArea = All;
                }
                field(Default; Rec.Default)
                {
                    ToolTip = 'Specifies whether this range should be used when no assignable range is specified in API request to create a new extension.';
                    ApplicationArea = All;
                }
            }
        }
    }
}