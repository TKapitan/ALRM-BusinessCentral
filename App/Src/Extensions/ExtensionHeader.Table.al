/// <summary>
/// Table ART Extension Header (ID 74179000).
/// </summary>
table 74179000 "ART Extension Header"
{
    Caption = 'Extension Header';
    LookupPageId = "ART Extension List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                ARTExtensionHeader: Record "ART Extension Header";

                IDAlreadyExistsErr: Label 'ID %1 already exists on another extension.', Comment = '%1 - ID to check';
            begin
                ARTExtensionHeader.SetFilter(Code, '<>%1', Rec.Code);
                ARTExtensionHeader.SetRange(ID, Rec.ID);
                if not ARTExtensionHeader.IsEmpty() then
                    Error(IDAlreadyExistsErr, Rec.ID);
            end;
        }
        field(3; "Assignable Range Code"; Code[20])
        {
            Caption = 'Assignable Range Code';
            DataClassification = CustomerContent;
            TableRelation = "ART Assignable Range Header".Code;

            trigger OnValidate()
            var
                AssignableRangeHeader: Record "ART Assignable Range Header";
                NoSerisManagement: Codeunit NoSeriesManagement;
            begin
                if (Rec.Code = '') and (Rec."Assignable Range Code" <> '') then begin
                    AssignableRangeHeader.Get(Rec."Assignable Range Code");
                    AssignableRangeHeader.TestField("No. Series for Extensions");
                    Rec.Code := NoSerisManagement.GetNextNo3(AssignableRangeHeader."No. Series for Extensions", Today, true, true);
                end;
            end;
        }
        field(4; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(6; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("ART Assignable Range Header"."No. Series for Extensions" where(Code = field("Assignable Range Code")));
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin
        Rec.TestField("Assignable Range Code");
    end;

    trigger OnDelete()
    begin
        if UsageExists() then
            Error(DeleteHeaderInUsageErr);
        if ObjectsExist() then
            DeleteObjects(true);
    end;

    var
        DeleteHeaderInUsageErr: Label 'Extension header cannot be deleted because it is used by atleast one Business Central instance';

    /// <summary> 
    /// Deteletes all objects within the extension
    /// </summary>
    /// <param name="RunTrigger">Boolean "RunTrigger", True = Run delete trigger</param>
    local procedure DeleteObjects(RunTrigger: Boolean)
    var
        ARTExtensionObject: Record "ART Extension Object";
    begin
        ARTExtensionObject.SetRange("Extension Code", Code);
        ARTExtensionObject.DeleteAll(RunTrigger);
    end;

    /// <summary> 
    /// Return true if atleast one usage of the extension was found 
    /// </summary>
    /// <returns>Return variable "Boolean", true = extension is used, false = extension is not used.</returns>
    local procedure UsageExists(): Boolean
    var
        ARTExtensionUsage: Record "ART Extension Usage";
    begin
        ARTExtensionUsage.SetRange("Extension Code", Rec.Code);
        if not ARTExtensionUsage.IsEmpty then
            exit(true);
    end;

    /// <summary> 
    /// Return true if atleast one object exist within the extension 
    /// </summary>
    /// <returns>Return variable "Boolean", true = objects exist, false = objects do not exist.</returns>
    local procedure ObjectsExist(): Boolean
    var
        ARTExtensionObject: Record "ART Extension Object";
    begin
        ARTExtensionObject.SetRange("Extension Code", Rec.Code);
        if not ARTExtensionObject.IsEmpty then
            exit(true);
    end;

    /// <summary> 
    /// Return first valid usage (business central instance) of this extension
    /// </summary>
    /// <returns>Return variable "Code[20]", code of the business central instance that use extension.</returns>
    procedure GetUsageOfExtension(): Code[20]
    var
        ARTExtensionUsage: Record "ART Extension Usage";
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
    begin
        ARTExtensionUsage.SetRange("Extension Code", Rec.Code);
        ARTExtensionUsage.SetFilter("Starting Date", '<=%1', WorkDate());
        ARTExtensionUsage.SetFilter("Ending Date", '>=%1|%2', WorkDate(), 0D);

        Rec.TestField("Assignable Range Code");
        ARTAssignableRangeHeader.Get(Rec."Assignable Range Code");
        if ARTAssignableRangeHeader."Ranges per BC Instance" then begin
            ARTExtensionUsage.FindFirst();
            exit(ARTExtensionUsage."Business Central Instance Code");
        end else
            if ARTExtensionUsage.FindFirst() then
                exit(ARTExtensionUsage."Business Central Instance Code");
        exit('');
    end;
}