/// <summary>
/// Page C4BC Extension Card (ID 74179005).
/// </summary>
page 74179005 "C4BC Extension Card"
{
    Caption = 'Extension Card';
    PageType = Card;
    UsageCategory = None;
    SourceTable = "C4BC Extension Header";


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Assignable Range Code"; Rec."Assignable Range Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Defines type of the id range used for this extension';
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
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
            part("Subform"; "C4BC Extension Subform")
            {
                Caption = 'Objects';
                ApplicationArea = All;
                SubPageLink = "Extension Code" = field(Code);
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
                RunObject = page "C4BC Extension Usage List";
                RunPageLink = "Extension Code" = field(Code);
                ApplicationArea = All;
            }
            action("Assignable Range")
            {
                Caption = 'Assignable Range';
                ToolTip = 'Allows to view and edit current assignable range.';
                Enabled = (Rec."Assignable Range Code" <> '');
                Image = Ranges;
                RunObject = page "C4BC Assignable Range Card";
                RunPageLink = Code = field("Assignable Range Code");
                ApplicationArea = All;
            }
        }
    }
}