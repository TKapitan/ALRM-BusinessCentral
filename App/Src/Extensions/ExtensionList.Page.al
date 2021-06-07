/// <summary>
/// Page ART Extension List (ID 74179000).
/// </summary>
page 74179000 "ART Extension List"
{
    Caption = 'Extension List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "ART Extension Card";
    SourceTable = "ART Extension Header";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifies the extension';
                }
                field("Assignable Range Code"; Rec."Assignable Range Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Defines type of the id range used for this extension';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the extension';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the extension';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Usage)
            {
                Caption = 'Usage';
                ToolTip = 'Allows to view and edit usage of the current extension.';
                Enabled = (Rec."Code" <> '');
                Image = LinkWithExisting;
                RunObject = page "ART Extension Usage List";
                RunPageLink = "Extension Code" = field(Code);
                ApplicationArea = All;
            }
            action("Assignable Range")
            {
                Caption = 'Assignable Range';
                ToolTip = 'Allows to view and edit current assignable range.';
                Enabled = (Rec."Assignable Range Code" <> '');
                Image = Ranges;
                RunObject = page "ART Assignable Range Card";
                RunPageLink = Code = field("Assignable Range Code");
                ApplicationArea = All;
            }
        }
    }
}