/// <summary>
/// Page C4BC Extension List (ID 80000).
/// </summary>
page 80000 "C4BC Extension List"
{
    Caption = 'Extension List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "C4BC Extension Card";
    SourceTable = "C4BC Extension Header";

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
                field("Sell as Item No."; Rec."Sell as Item No.")
                {
                    ToolTip = 'Specifies item no. that is used to sell the extension to customers. Based on this setting sales statistics are calculated.';
                    ApplicationArea = All;
                }
                field("Flat-rate Inv. as Item No."; Rec."Flat-rate Inv. as Item No.")
                {
                    ToolTip = 'Specifies item no. that is used for flat-rate invoicing to customers. Flat-rate invoicing can be achieved using blanket sales orders created for clients who bought the extension.';
                    ApplicationArea = All;
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