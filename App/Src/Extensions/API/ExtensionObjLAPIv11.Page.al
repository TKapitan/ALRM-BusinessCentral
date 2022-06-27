/// <summary>
/// Page C4BC Extension Obj.L. API v1.1 (ID 80015).
/// </summary>
page 79515 "C4BC Extension Obj.L. API v1.1"
{
    PageType = API;
    Caption = 'Extension Object Lines API';
    APIPublisher = 'teamARTAAAE';
    APIGroup = 'extension';
    APIVersion = 'v1.1';
    EntityName = 'extensionObjectLine';
    EntitySetName = 'extensionObjectLines';
    SourceTable = "C4BC Extension Object Line";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(systemId; Rec.SystemId) { }
                field("code"; Rec."Extension Code") { }
                field(extensionID; Rec."Extension ID") { }
                field(objectID; Rec."Object ID") { }
                field(alternateObjectID; Rec."Alternate Object ID") { }
                field(objectType; Rec."Object Type") { }
                field(id; Rec.ID) { }
                field(alternateID; Rec."Alternate ID") { }
                field(name; Rec.Name) { }
                field(systemCreatedAt; Rec.SystemCreatedAt) { }
                field(systemCreatedBy; Rec.SystemCreatedBy) { }
                field(systemModifiedAt; Rec.SystemModifiedAt) { }
                field(systemModifiedBy; Rec.SystemModifiedBy) { }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        C4BCALRMSetup: Record "C4BC ALRM Setup";
    begin
        C4BCALRMSetup.FindFirst();
        C4BCALRMSetup.CheckAPIVersion(C4BCALRMSetup."Minimal API Version"::"v1.1");
    end;
}