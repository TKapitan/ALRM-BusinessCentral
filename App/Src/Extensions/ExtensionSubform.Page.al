/// <summary>
/// Page ART Extension Subform (ID 74179004).
/// </summary>
page 74179004 "ART Extension Subform"
{
    PageType = ListPart;
    UsageCategory = None;
    DelayedInsert = true;
    SourceTable = "ART Extension Object";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    QuickEntry = true;
                    ToolTip = 'Object Type';

                    trigger OnValidate()
                    begin
                        UpdateHideValueForObjectID();
                    end;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                    HideValue = HideValueForObjectID;
                    ToolTip = 'Object ID';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    QuickEntry = true;
                    ToolTip = 'Object Name';
                }
                field("Extends Object Name"; Rec."Extends Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies name of object that is extended by this newly created object. The field can be filled in for extension objects only.';
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
                RunObject = page "ART Extension Object Lines";
                RunPageLink = "Extension Code" = field("Extension Code"), "Object ID" = field("Object ID"), "Object Type" = field("Object Type");
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        UpdateHideValueForObjectID();
        if Rec."Object Type" in [Rec."Object Type"::"Table Extension", Rec."Object Type"::"Enum Extension"] then
            ObjectFieldsActionEnabled := true;
    end;

    var
        ObjectFieldsActionEnabled: Boolean;
        HideValueForObjectID: Boolean;

    local procedure UpdateHideValueForObjectID()
    var
        ARTALRMManagement: Codeunit "ART ALRM Management";
    begin
        HideValueForObjectID := false;
        if not ARTALRMManagement.UseObjectTypeIDs(Rec."Object Type", false) then
            HideValueForObjectID := true;
    end;
}