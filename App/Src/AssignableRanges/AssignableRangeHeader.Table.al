table 80001 "C4BC Assignable Range Header"
{
    Caption = 'Assignable Range Header';
    LookupPageId = "C4BC Assignable Range List";
    DrillDownPageId = "C4BC Assignable Range List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; "Ranges per BC Instance"; Boolean)
        {
            Caption = 'Ranges per BC Instance';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                C4BCExtensionHeader: Record "C4BC Extension Header";

                CanNotChangeDueToExistingRecErr: Label 'The field can not be changed due to the existing extensions linked to this assignable range.';
            begin
                C4BCExtensionHeader.SetRange("Assignable Range Code", Rec.Code);
                if not C4BCExtensionHeader.IsEmpty() then
                    Error(CanNotChangeDueToExistingRecErr);
            end;
        }
        field(11; Default; Boolean)
        {
            Caption = 'Default';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                AssignableRangeHeader: Record "C4BC Assignable Range Header";

                CannotHaveMoreDefaultRangesErr: Label 'There is already existing default assignable range.';
            begin
                if Rec.Default and not xRec.Default then begin
                    AssignableRangeHeader.SetFilter(Code, '<>%1', Rec.Code);
                    AssignableRangeHeader.SetRange(Default, true);
                    if not AssignableRangeHeader.IsEmpty() then
                        Error(CannotHaveMoreDefaultRangesErr);
                end;
            end;
        }
        field(15; "Default Range From"; Integer)
        {
            Caption = 'Default Range From';
            MinValue = 0;
            DataClassification = SystemMetadata;
        }
        field(16; "Default Range To"; Integer)
        {
            Caption = 'Default Range To';
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(25; "Object Name Template"; Text[30])
        {
            Caption = 'Object Name Template';
            DataClassification = CustomerContent;
        }
        field(100; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description) { }
    }

    trigger OnDelete()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";

        CannotDeleteLinkExistsErr: Label '%1 can not be deleted due to existing related records in %2.', Comment = '%1 - Caption of table in which the record can not be deleted, %2 - Caption of table where the link exists.';
    begin
        C4BCExtensionHeader.SetRange("Assignable Range Code", Rec."Code");
        if not C4BCExtensionHeader.IsEmpty() then
            Error(CannotDeleteLinkExistsErr, Rec.TableCaption(), C4BCExtensionHeader.TableCaption());
    end;

    trigger OnRename()
    var
        CanNotBeRenamedErr: Label 'The record can not be renamed.';
    begin
        Error(CanNotBeRenamedErr);
    end;

    /// <summary> 
    /// Specifies whether the default range should be used for specified object type instead of specific range.
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want to find out whether the default range should be used.</param>
    /// <returns>Return variable "Boolean" - whether the default range should be used.</returns>
    local procedure ShouldUseDefaultRanges(ForObjectType: Enum "C4BC Object Type"): Boolean
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
    begin
        C4BCAssignablerangeLine.SetRange("Assignable Range Code", Rec."Code");
        C4BCAssignablerangeLine.SetRange("Object Type", ForObjectType);
        if C4BCAssignableRangeLine.IsEmpty() then
            exit(true);
        exit(false);
    end;

    /// <summary> 
    /// Allows to get the very first object ID for specified object type. The ID is returned without checking whether is in use or not.
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want the ID</param>
    /// <returns>Return variable "Integer" - specifies ID of the very first object in the range.</returns>
    local procedure GetVeryFirstObjectID(ForObjectType: Enum "C4BC Object Type"): Integer
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
    begin
        if ShouldUseDefaultRanges(ForObjectType) then
            exit(Rec."Default Range From");

        C4BCAssignablerangeLine.SetRange("Assignable Range Code", Rec."Code");
        C4BCAssignablerangeLine.SetRange("Object Type", ForObjectType);
        C4BCAssignablerangeLine.FindFirst();
        exit(C4BCAssignablerangeLine."Object Range From");
    end;

    /// <summary> 
    /// Allows to get new unused ID for specified object type
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want the ID</param>
    /// <param name="ForBusinessCentralInstance">Code[20], Code of .</param>
    /// <returns>Return variable "Integer" - specifies ID which is the next in row and is still unused.</returns>
    procedure GetNewID(ForObjectType: Enum "C4BC Object Type"; ForBusinessCentralInstance: Code[20]): Integer
    var
        C4BCExtensionLine: Record "C4BC Extension Line";
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";

        LastUsedObjectID, VeryFirstObjectID : Integer;

        MissingParameterErr: Label 'When the range has %1 = Yes, the IDs must be assigned using procedure that specify business central instance ID and the value must not be empty. This is probably programming error.', Comment = '%1 - Ranges per BC Instance field caption';
    begin
        if Rec."Ranges per BC Instance" and (ForBusinessCentralInstance = '') then
            Error(MissingParameterErr, Rec.FieldCaption("Ranges per BC Instance"));

        LastUsedObjectID := 0;
        C4BCExtensionLine.SetCurrentKey("Object Type", "Object ID");
        C4BCExtensionLine.SetRange("Object Type", ForObjectType);
        C4BCExtensionLine.SetRange("Assignable Range Code", Rec."Code");
        if Rec."Ranges per BC Instance" then begin
            // Find extension lines that are installed on specific business central instance
            C4BCExtensionLine.SetRange("Bus. Central Instance Filter", ForBusinessCentralInstance);
            C4BCExtensionLine.SetRange("Bus. Central Instance Linked", true);
        end;

        if C4BCExtensionLine.FindLast() then begin
            LastUsedObjectID := C4BCExtensionLine."Object ID";
            if IsIDFromRange(ForObjectType, LastUsedObjectID + 1) then
                exit(LastUsedObjectID + 1);
        end;

        if LastUsedObjectID = 0 then begin
            VeryFirstObjectID := GetVeryFirstObjectID(ForObjectType);
            if VeryFirstObjectID <> 0 then
                exit(VeryFirstObjectID);
        end;

        C4BCAssignablerangeLine.SetRange("Assignable Range Code", Rec."Code");
        C4BCAssignablerangeLine.SetRange("Object Type", ForObjectType);
        C4BCAssignablerangeLine.SetFilter("Object Range To", '>%1', LastUsedObjectID);
        C4BCAssignablerangeLine.FindFirst();
        exit(C4BCAssignablerangeLine."Object Range From");
    end;

    /// <summary> 
    /// Allows to get new unused ID for specified object type.
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want the ID</param>
    /// <returns>Return variable "Integer" - specifies ID which is the next in row and is still unused.</returns>
    procedure GetNewID(ForObjectType: Enum "C4BC Object Type"): Integer
    begin
        exit(GetNewID(ForObjectType, ''));
    end;

    /// <summary> 
    /// Specifies whether the combination of the object type and ID is from any range specified by this assignable range code.
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want to check, whether the ID is within the range.</param> 
    /// <param name="ID">Integer, specifies ID of the object which we want to check.</param>
    /// <returns>Return variable "Boolean" - specifies whether the object type/ID is within any range in this assignable range code.</returns>
    procedure IsIDFromRange(ForObjectType: Enum "C4BC Object Type"; ID: Integer): Boolean
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
    begin
        if ShouldUseDefaultRanges(ForObjectType) then begin
            if (Rec."Default Range From" <= ID) and (Rec."Default Range To" >= ID) then
                exit(true);
            exit(false);
        end;

        C4BCAssignablerangeLine.SetRange("Assignable Range Code", Rec."Code");
        C4BCAssignablerangeLine.SetRange("Object Type", ForObjectType);
        C4BCAssignablerangeLine.SetFilter("Object Range From", '<=%1', ID);
        C4BCAssignablerangeLine.SetFilter("Object Range To", '>=%1', ID);
        if not C4BCAssignableRangeLine.IsEmpty() then
            exit(true);
        exit(false);
    end;
}