/// <summary>
/// Table C4BC Extension Header (ID 80000).
/// </summary>
table 80000 "C4BC Extension Header"
{
    Caption = 'Extension Header';
    LookupPageId = "C4BC Extension List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; ID; Guid)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                C4BCExtensionHeader: Record "C4BC Extension Header";

                IDAlreadyExistsErr: Label 'ID %1 already exists on another extension.', Comment = '%1 - ID to check';
            begin
                C4BCExtensionHeader.SetFilter(Code, '<>%1', Rec.Code);
                C4BCExtensionHeader.SetRange(ID, Rec.ID);
                if not C4BCExtensionHeader.IsEmpty() then
                    Error(IDAlreadyExistsErr, Rec.ID);
            end;
        }
        field(3; "Assignable Range Code"; Code[20])
        {
            Caption = 'Assignable Range Code';
            DataClassification = CustomerContent;
            TableRelation = "C4BC Assignable Range Header".Code;

            trigger OnValidate()
            var
                AssignableRangeHeader: Record "C4BC Assignable Range Header";
                ExtensionObject: Record "C4BC Extension Object";
                NoSerisManagement: Codeunit NoSeriesManagement;

                ObjectIDsGeneratedErr: Label 'Object IDs are already generated. The assignable range can not be changed.';
            begin
                if (xRec."Assignable Range Code" <> '') and (Rec."Assignable Range Code" <> xRec."Assignable Range Code") then begin
                    ExtensionObject.SetRange("Extension Code", Rec.Code);
                    ExtensionObject.SetFilter("Object ID", '<>0');
                    if not ExtensionObject.IsEmpty() then
                        Error(ObjectIDsGeneratedErr);
                end;

                if (Rec.Code = '') and (Rec."Assignable Range Code" <> '') then begin
                    AssignableRangeHeader.Get(Rec."Assignable Range Code");
                    AssignableRangeHeader.TestField("No. Series for Extensions");
                    Rec.Code := NoSerisManagement.DoGetNextNo(AssignableRangeHeader."No. Series for Extensions", Today, true, true);
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
            CalcFormula = lookup("C4BC Assignable Range Header"."No. Series for Extensions" where(Code = field("Assignable Range Code")));
        }
        field(50; "Sell as Item No."; Code[20])
        {
            Caption = 'Sell as Item No.';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
            DataClassification = CustomerContent;
        }
        field(51; "Flat-rate Inv. as Item No."; Code[20])
        {
            Caption = 'Flat-rate Invoicing as Item No.';
            TableRelation = Item."No." where(Type = const("Non-Inventory"));
            DataClassification = CustomerContent;
        }
        field(150; "Alternate Assign. Range Code"; Code[20])
        {
            Caption = 'Alternate Assignable Range Code';
            DataClassification = CustomerContent;
            TableRelation = "C4BC Assignable Range Header".Code;

            trigger OnValidate()
            var
                AssignableRangeHeader: Record "C4BC Assignable Range Header";
                AssignableRangeHeader2: Record "C4BC Assignable Range Header";

                ExtensionObject: Record "C4BC Extension Object";
                ExtensionObjectLine: Record "C4BC Extension Object Line";

                AlternateObjectIDsGeneratedErr: Label 'Alternate object IDs are already generated. The assignable range can not be changed.';
            begin
                Rec.TestField("Assignable Range Code");
                if Rec."Assignable Range Code" = Rec."Alternate Assign. Range Code" then
                    Rec.FieldError("Assignable Range Code");

                if (xRec."Alternate Assign. Range Code" <> '') and (Rec."Alternate Assign. Range Code" <> xRec."Alternate Assign. Range Code") then begin
                    ExtensionObject.SetRange("Extension Code", Rec.Code);
                    ExtensionObject.SetFilter("Alternate Object ID", '<>0');
                    if not ExtensionObject.IsEmpty() then
                        Error(AlternateObjectIDsGeneratedErr);
                end;
                if Rec."Alternate Assign. Range Code" = '' then
                    exit;

                AssignableRangeHeader.Get(Rec."Assignable Range Code");
                AssignableRangeHeader2.Get(Rec."Alternate Assign. Range Code");
                AssignableRangeHeader2.TestField("Ranges per BC Instance", AssignableRangeHeader."Ranges per BC Instance");
                AssignableRangeHeader2.TestField("Object Name Template", AssignableRangeHeader."Object Name Template");

                Rec.Modify(true);

                Clear(ExtensionObject);
                ExtensionObject.SetRange("Extension Code", Rec.Code);
                if ExtensionObject.FindSet() then
                    repeat
                        ExtensionObject."Alternate Object ID" := ExtensionObject.GetNewObjectID(Rec."Alternate Assign. Range Code", true);
                        ExtensionObject.Modify(true);
                    until ExtensionObject.Next() < 1;

                ExtensionObjectLine.SetCurrentKey("Object Type", "ID");
                ExtensionObjectLine.SetRange("Extension Code", ExtensionObject."Extension Code");
                if ExtensionObjectLine.FindSet() then
                    repeat
                        ExtensionObjectLine."Alternate ID" := ExtensionObjectLine.GetNewFieldLineID(Rec."Alternate Assign. Range Code", true);
                        ExtensionObjectLine.Modify(true)
                    until ExtensionObjectLine.Next() < 1;
            end;
        }
        field(200; "BC Instance for Assign. Range"; Code[20])
        {
            Caption = 'BC Instance used for Assignable Range';
            TableRelation = "C4BC Business Central Instance".Code;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                AssignableRangeHeader: Record "C4BC Assignable Range Header";
            begin
                if Rec."BC Instance for Assign. Range" = '' then
                    exit;
                Rec.TestField("Assignable Range Code");
                AssignableRangeHeader.Get(Rec."Assignable Range Code");
                AssignableRangeHeader.TestField("Ranges per BC Instance");
            end;
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
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCExtensionObject.SetRange("Extension Code", Code);
        C4BCExtensionObject.DeleteAll(RunTrigger);
    end;

    /// <summary> 
    /// Return true if atleast one usage of the extension was found 
    /// </summary>
    /// <returns>Return variable "Boolean", true = extension is used, false = extension is not used.</returns>
    local procedure UsageExists(): Boolean
    var
        C4BCExtensionUsage: Record "C4BC Extension Usage";
    begin
        C4BCExtensionUsage.SetRange("Extension Code", Rec.Code);
        if not C4BCExtensionUsage.IsEmpty then
            exit(true);
    end;

    /// <summary> 
    /// Return true if atleast one object exist within the extension 
    /// </summary>
    /// <returns>Return variable "Boolean", true = objects exist, false = objects do not exist.</returns>
    local procedure ObjectsExist(): Boolean
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCExtensionObject.SetRange("Extension Code", Rec.Code);
        if not C4BCExtensionObject.IsEmpty then
            exit(true);
    end;

    /// <summary> 
    /// Return first valid usage (business central instance) of this extension
    /// </summary>
    /// <returns>Return variable "Code[20]", code of the business central instance that use extension.</returns>
    procedure GetUsageOfExtension(): Code[20]
    var
        C4BCExtensionUsage: Record "C4BC Extension Usage";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        C4BCExtensionUsage.SetRange("Extension Code", Rec.Code);
        C4BCExtensionUsage.SetFilter("Starting Date", '<=%1', WorkDate());
        C4BCExtensionUsage.SetFilter("Ending Date", '>=%1|%2', WorkDate(), 0D);

        Rec.TestField("Assignable Range Code");
        C4BCAssignableRangeHeader.Get(Rec."Assignable Range Code");
        if C4BCAssignableRangeHeader."Ranges per BC Instance" then begin
            Rec.TestField("BC Instance for Assign. Range");
            exit(Rec."BC Instance for Assign. Range");
        end else
            if C4BCExtensionUsage.FindFirst() then
                exit(C4BCExtensionUsage."Business Central Instance Code");
        exit('');
    end;
}