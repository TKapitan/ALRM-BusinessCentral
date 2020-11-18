page 80002 "C4BC Assignable Range Card"
{
    Caption = 'Assignable Range';
    PageType = Card;
    SourceTable = "C4BC Assignable Range Header";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("Ranges per Customer"; Rec."Ranges per Customer")
                {
                    ToolTip = 'Specifies whether the ranges will be assigned per customer or the ID will be used once and only once.';
                    ApplicationArea = All;
                }
                field(Default; Rec.Default)
                {
                    ToolTip = 'Specifies whether this range should be used when no assignable range is specified in API request to create a new extension.';
                    ApplicationArea = All;
                }
                group("Default Ranges")
                {
                    Caption = 'Default Ranges';
                    field("Default Range From"; Rec."Default Range From")
                    {
                        ToolTip = 'Specifies ID of the object that is the first assignable ID for all object types that has no detailed specification in the lines.';
                        ApplicationArea = All;
                    }
                    field("Default Range To"; Rec."Default Range To")
                    {
                        ToolTip = 'Specifies ID of the object that is the last assignable ID for all object types that has no detailed specification in the lines.';
                        ApplicationArea = All;
                    }
                }
            }

            part("C4BC Assignable Range Subform"; "C4BC Assignable Range Subform")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        BothOrNoneDefaultRangesMustBeSpecifiedLbl: Label 'Both or none of default range fields must be specified.';
    begin
        if (Rec."Default Range From" > 0) and (Rec."Default Range To" > 0) then
            exit(true);
        if (Rec."Default Range From" = 0) and (Rec."Default Range To" = 0) then
            exit(true);

        Message(BothOrNoneDefaultRangesMustBeSpecifiedLbl);
        exit(false);
    end;
}