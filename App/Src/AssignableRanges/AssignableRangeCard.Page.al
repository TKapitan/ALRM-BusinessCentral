/// <summary>
/// Page C4BC Assignable Range Card (ID 80002).
/// </summary>
page 80002 "C4BC Assignable Range Card"
{
    Caption = 'Assignable Range';
    PageType = Card;
    UsageCategory = None;
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
                field("Ranges per BC Instance"; Rec."Ranges per BC Instance")
                {
                    ToolTip = 'Specifies whether the ranges will be assigned per BC instance or the ID will be used once and only once.';
                    ApplicationArea = All;
                }
                field("Object Name Template"; Rec."Object Name Template")
                {
                    ToolTip = 'Specifies template for object names. All objects created within this assignable range must satisfy this template rule.';
                    ApplicationArea = All;
                }
                field(Default; Rec.Default)
                {
                    ToolTip = 'Specifies whether this range should be used when no assignable range is specified in API request to create a new extension.';
                    ApplicationArea = All;
                }
                group("Default Object Ranges")
                {
                    Caption = 'Default Object Ranges';
                    field("Default Object Range From"; Rec."Default Object Range From")
                    {
                        ToolTip = 'Specifies ID of the object that is the first assignable ID for all object types that has no detailed specification in the lines.';
                        ApplicationArea = All;
                    }
                    field("Default Object Range To"; Rec."Default Object Range To")
                    {
                        ToolTip = 'Specifies ID of the object that is the last assignable ID for all object types that has no detailed specification in the lines.';
                        ApplicationArea = All;
                    }
                    field("Fill Object ID Gaps"; Rec."Fill Object ID Gaps")
                    {
                        ToolTip = 'Specifies whether system should fill gaps in ID ranges when assigning new object ID. This can lead to slower performance of assigning process.';
                        ApplicationArea = All;
                    }
                }
                group("Field Ranges")
                {
                    Caption = 'Field Ranges';
                    field("Field Range From"; Rec."Field Range From")
                    {
                        ToolTip = 'Specifies ID of the field that is the first assignable ID for all object types.';
                        ApplicationArea = All;
                    }
                    field("Field Range To"; Rec."Field Range To")
                    {
                        ToolTip = 'Specifies ID of the field that is the last assignable ID for all object types.';
                        ApplicationArea = All;
                    }
                }
                group("No. Series Group")
                {
                    Caption = 'No. Series';
                    field("No. Series for Extensions"; Rec."No. Series for Extensions")
                    {
                        ToolTip = 'Specifies No. Series used for creating new extensions.';
                        ApplicationArea = All;
                    }

                }

            }

            part("C4BC Assignable Range Subform"; "C4BC Assignable Range Subform")
            {
                SubPageLink = "Assignable Range Code" = field(Code);
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Extension)
            {
                Caption = 'Extensions';
                ToolTip = 'Allows to view and edit extensions.';
                Enabled = (Rec.Code <> '');
                Image = ExtendedDataEntry;
                RunObject = page "C4BC Extension List";
                RunPageLink = "Assignable Range Code" = field("Code");
                ApplicationArea = All;
            }
            action(AssignedObjects)
            {
                Caption = 'Assigned Objects';
                ToolTip = 'View all objects assigned to this range.';
                image = AllLines;
                RunObject = page "C4BC Assigned Range Objects";
                RunPageLink = "Assignable Range Code" = field("Code");
                ApplicationArea = All;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        BothOrNoneDefaultRangesMustBeSpecifiedLbl: Label 'Both or none of default range fields must be specified.';
    begin
        if (Rec."Default Object Range From" > 0) and (Rec."Default Object Range To" > 0) then
            exit(true);
        if (Rec."Default Object Range From" = 0) and (Rec."Default Object Range To" = 0) then
            exit(true);

        Message(BothOrNoneDefaultRangesMustBeSpecifiedLbl);
        exit(false);
    end;
}