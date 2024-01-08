/// <summary>
/// Page C4BC Extension Card (ID 80005).
/// </summary>
page 79505 "C4BC Extension Card"
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
                field("Alternate Assign. Range Code"; Rec."Alternate Assign. Range Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Defines alternate type of the id range used for this extension. This range is not mandatory and can be used for example to define a range for AppSource range.';

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
                field("BC Instance for Assign. Range"; Rec."BC Instance for Assign. Range")
                {
                    ToolTip = 'Specifies Business Central instance that is used to assign ids for this extension. This setting is used only for ranges per BC instance.';
                    ApplicationArea = All;
                }
            }
            part("Subform"; "C4BC Extension Subform")
            {
                Caption = 'Objects';
                ApplicationArea = All;
                SubPageLink = "Extension Code" = field(Code);
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
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