page 80004 "C4BC Extension Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "C4BC Extension Object";

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
    actions
    {
        area(Processing)
        {
            action("Object Lines")
            {
                Caption = 'Object Lines';
                ToolTip = 'Opens a list of the lines associated with selected object, it is only possible to assign lines to objects of type Table Extension, Enum Extension';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = ObjectFieldsActionEnabled;
                ApplicationArea = All;
                Image = AllLines;
                RunObject = page "C4BC Extension Object Lines";
                RunPageLink = "Extension Code" = field("Extension Code"), "Object ID" = field("Object ID"), "Object Type" = field("Object Type");
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        if Rec."Object Type" in [Rec."Object Type"::"Table Extension", Rec."Object Type"::"Enum Extension"] then
            ObjectFieldsActionEnabled := true;
    end;

    var
        ObjectFieldsActionEnabled: Boolean;

}