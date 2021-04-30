/// <summary>
/// Table C4BC Assignable Range Header (ID 80001).
/// </summary>
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
        field(12; "Fill Object ID Gaps"; Boolean)
        {
            Caption = 'Fill Object ID Gaps';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                AssignableRangeLine: Record "C4BC Assignable Range Line";
            begin
                AssignableRangeLine.SetRange("Assignable Range Code", Rec.Code);
                AssignableRangeLine.ModifyAll("Fill Object ID Gaps", Rec."Fill Object ID Gaps");
            end;
        }
        field(15; "Default Object Range From"; Integer)
        {
            Caption = 'Default Object Range From';
            MinValue = 0;
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                ValidateChangeToDefaultRanges(RangeType::From, xRec."Default Object Range From", Rec."Default Object Range From");
            end;
        }
        field(16; "Default Object Range To"; Integer)
        {
            Caption = 'Default Object Range To';
            MinValue = 0;
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                ValidateChangeToDefaultRanges(RangeType::"To", xRec."Default Object Range To", Rec."Default Object Range To");
            end;
        }
        field(17; "Field Range From"; Integer)
        {
            Caption = 'Field Range From';
            MinValue = 0;
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                // TODO validate change to default field range
                // ValidateChangeToDefaultRanges(RangeType::From, xRec."Default Object Range From", Rec."Default Object Range From");
            end;
        }
        field(18; "Field Range To"; Integer)
        {
            Caption = 'Field Range To';
            MinValue = 0;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                // TODO validate change to default field range
                // ValidateChangeToDefaultRanges(RangeType::"To", xRec."Default Object Range To", Rec."Default Object Range To");
            end;
        }
        field(25; "Object Name Template"; Text[30])
        {
            Caption = 'Object Name Template';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                C4BCExtensionLine: Record "C4BC Extension Object";
                TempInt: Integer;

                DifferentFileNamesExistsErr: Label 'There are extension lines that are different from the specified template name.';
            begin
                if Rec."Object Name Template" = '' then
                    exit;

                C4BCExtensionLine.SetRange("Assignable Range Code", Rec.Code);
                TempInt := C4BCExtensionLine.Count();
                C4BCExtensionLine.SetFilter("Object Name", Rec."Object Name Template");
                if TempInt <> C4BCExtensionLine.Count() then
                    Error(DifferentFileNamesExistsErr);
            end;
        }
        field(100; "No. Series for Extensions"; Code[20])
        {
            Caption = 'No. Series for Extensions';
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
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
        C4BCExtensionHeader: Record "C4BC Extension Header";

        CannotDeleteLinkExistsErr: Label '%1 can not be deleted due to existing related records in %2.', Comment = '%1 - Caption of table in which the record can not be deleted, %2 - Caption of table where the link exists.';
    begin
        C4BCExtensionHeader.SetRange("Assignable Range Code", Rec."Code");
        if not C4BCExtensionHeader.IsEmpty() then
            Error(CannotDeleteLinkExistsErr, Rec.TableCaption(), C4BCExtensionHeader.TableCaption());

        C4BCAssignableRangeLine.SetRange("Assignable Range Code", Rec.Code);
        C4BCAssignableRangeLine.DeleteAll();
    end;

    trigger OnRename()
    var
        CanNotBeRenamedErr: Label 'The record can not be renamed.';
    begin
        Error(CanNotBeRenamedErr);
    end;

    var
        RangeType: Option From,To;
        MissingParameterErr: Label 'When the range has %1 = Yes, the IDs must be assigned using procedure that specify business central instance ID and the value must not be empty. This is probably programming error.', Comment = '%1 - Ranges per BC Instance field caption';

    /// <summary> 
    /// Allows to get new unused ID for specified object type
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want the ID</param>
    /// <param name="ForBusinessCentralInstance">Code[20], Code of .</param>
    /// <returns>Return variable "Integer" - specifies ID which is the next in row and is still unused.</returns>
    procedure GetNewObjectID(ForObjectType: Enum "C4BC Object Type"; ForBusinessCentralInstance: Code[20]): Integer
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";

        LastUsedObjectID, NewObjectID, VeryFirstObjectID : Integer;
    begin
        if Rec."Ranges per BC Instance" and (ForBusinessCentralInstance = '') then
            Error(MissingParameterErr, Rec.FieldCaption("Ranges per BC Instance"));

        LastUsedObjectID := 0;
        C4BCExtensionObject.SetCurrentKey("Object Type", "Object ID");
        C4BCExtensionObject.SetRange("Object Type", ForObjectType);
        C4BCExtensionObject.SetRange("Assignable Range Code", Rec."Code");
        if Rec."Ranges per BC Instance" then begin
            // Find extension lines that are installed on specific business central instance
            C4BCExtensionObject.SetRange("Bus. Central Instance Filter", ForBusinessCentralInstance);
            C4BCExtensionObject.SetRange("Bus. Central Instance Linked", true);
        end;

        if C4BCExtensionObject.FindLast() then begin
            // Try to find gap in already assigned ranges
            if FindGapInAssignableRange(C4BCExtensionObject, ForObjectType, NewObjectID) then
                exit(NewObjectID);

            // Get next ID after the last used one (if the ID is within allowed ranges)
            LastUsedObjectID := C4BCExtensionObject."Object ID";
            NewObjectID := LastUsedObjectID + 1;
            if IsObjectIDFromRange(ForObjectType, NewObjectID) then
                exit(NewObjectID);
        end else begin
            // No ID in use yet, find the first one
            VeryFirstObjectID := GetVeryFirstObjectID(ForObjectType);
            if VeryFirstObjectID <> 0 then
                exit(VeryFirstObjectID);
        end;

        // Some IDs already in use but the first range is depleted, try to find another defined range
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
    [Obsolete('Replaced by GetNewObjectID(Enum "C4BC Object Type"; Code[20])', '2021-04')]
    procedure GetNewObjectID(ForObjectType: Enum "C4BC Object Type"): Integer
    begin
        exit(GetNewObjectID(ForObjectType, ''));
    end;

    /// <summary> 
    /// Specifies whether the combination of the object type and ID is from any range specified by this assignable range code.
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want to check, whether the ID is within the range.</param> 
    /// <param name="ID">Integer, specifies ID of the object which we want to check.</param>
    /// <returns>Return variable "Boolean" - specifies whether the object type/ID is within any range in this assignable range code.</returns>
    procedure IsObjectIDFromRange(ForObjectType: Enum "C4BC Object Type"; ID: Integer): Boolean
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
    begin
        if ShouldUseDefaultRanges(ForObjectType) then begin
            if (Rec."Default Object Range From" <= ID) and (Rec."Default Object Range To" >= ID) then
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

    /// <summary> 
    /// Returns the very first object ID from the range within which the ObjectID in parameter was created.
    /// </summary>
    /// <param name="C4BCObjectType">Enum "C4BC Object Type", The object type for which we want the ID</param>
    /// <param name="ObjectID">Integer, object ID for which we are looking the very first ID.</param>
    /// <returns>Return variable "Integer", specifies ID of the very first object within the same range.</returns>
    procedure GetVeryFirstObjectIDFromRangeBasedOnObjectID(C4BCObjectType: Enum "C4BC Object Type"; ObjectID: Integer): Integer
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
    begin
        if ShouldUseDefaultRanges(C4BCObjectType) then
            exit(Rec."Default Object Range From");

        C4BCAssignableRangeLine.SetRange("Assignable Range Code", Rec.Code);
        C4BCAssignableRangeLine.SetRange("Object Type", C4BCObjectType);
        if ObjectID <> 0 then begin
            C4BCAssignableRangeLine.SetFilter("Object Range From", '<=%1', ObjectID);
            C4BCAssignableRangeLine.SetFilter("Object Range To", '>=%1', ObjectID);
        end;
        C4BCAssignableRangeLine.FindFirst();
        exit(C4BCAssignableRangeLine."Object Range From");
    end;

    /// <summary> 
    /// Returns the very last object ID from the range within which the ObjectID in parameter was created.
    /// </summary>
    /// <param name="C4BCObjectType">Enum "C4BC Object Type", The object type for which we want the ID</param>
    /// <param name="ObjectID">Integer, object ID for which we are looking the very last ID.</param>
    /// <returns>Return variable "Integer", specifies ID of the very last object within the same range.</returns>
    procedure GetVeryLastObjectIDFromRangeBasedOnObjectID(C4BCObjectType: Enum "C4BC Object Type"; ObjectID: Integer): Integer
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
    begin
        if ShouldUseDefaultRanges(C4BCObjectType) then
            exit(Rec."Default Object Range To");

        C4BCAssignableRangeLine.SetRange("Assignable Range Code", Rec.Code);
        C4BCAssignableRangeLine.SetRange("Object Type", C4BCObjectType);
        if ObjectID <> 0 then begin
            C4BCAssignableRangeLine.SetFilter("Object Range From", '<=%1', ObjectID);
            C4BCAssignableRangeLine.SetFilter("Object Range To", '>=%1', ObjectID);
        end;
        C4BCAssignableRangeLine.FindFirst();
        exit(C4BCAssignableRangeLine."Object Range To");
    end;

    /// <summary> 
    /// Allows to get the very first object ID for specified object type. The ID is returned without checking whether is in use or not.
    /// </summary>
    /// <param name="C4BCObjectType">Enum "C4BC Object Type", The object type for which we want the ID</param>
    /// <returns>Return variable "Integer" - specifies ID of the very first object in the range.</returns>
    local procedure GetVeryFirstObjectID(C4BCObjectType: Enum "C4BC Object Type"): Integer
    begin
        exit(GetVeryFirstObjectIDFromRangeBasedOnObjectID(C4BCObjectType, 0));
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
        C4BCAssignableRangeLine.SetRange("Assignable Range Code", Rec."Code");
        C4BCAssignableRangeLine.SetRange("Object Type", ForObjectType);
        if C4BCAssignableRangeLine.IsEmpty() then
            exit(true);
        exit(false);
    end;

    /// <summary> 
    /// Allows to get new unused field ID for specified object type
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want the field ID</param>
    /// <param name="ForBusinessCentralInstance">Code[20], Code of the business central instance on which the object is used.</param>
    /// <returns>Return variable "Integer" - specifies field ID which is the next in row and is still unused.</returns>
    procedure GetNewFieldID(ForObjectType: Enum "C4BC Object Type"; ForBusinessCentralInstance: Code[20]): Integer
    var
        C4BCExtensionObjectLine: Record "C4BC Extension Object Line";

        NewFieldID: Integer;
        NoAvailableFieldIDsErr: Label 'There are no available field IDs for a new field.';
    begin
        if Rec."Ranges per BC Instance" and (ForBusinessCentralInstance = '') then
            Error(MissingParameterErr, Rec.FieldCaption("Ranges per BC Instance"));

        C4BCExtensionObjectLine.SetCurrentKey("Object Type", "ID");
        C4BCExtensionObjectLine.SetAscending("ID", true);
        C4BCExtensionObjectLine.SetRange("Object Type", ForObjectType);
        C4BCExtensionObjectLine.SetRange("Assignable Range Code", Rec."Code");
        if Rec."Ranges per BC Instance" then begin
            // Find extension object lines that are installed on specific business central instance
            C4BCExtensionObjectLine.SetRange("Bus. Central Instance Filter", ForBusinessCentralInstance);
            C4BCExtensionObjectLine.SetRange("Bus. Central Instance Linked", true);
        end;

        if C4BCExtensionObjectLine.FindLast() then begin
            NewFieldID := C4BCExtensionObjectLine.ID + 1;
            if (Rec."Field Range From" <= NewFieldID) and (Rec."Field Range To" >= NewFieldID) then
                exit(NewFieldID);
            Error(NoAvailableFieldIDsErr);
        end;

        Rec.TestField("Field Range From");
        exit(REc."Field Range From");
    end;

    /// <summary> 
    /// Allows to get new unused field ID for specified object type
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", The object type for which we want the field ID</param>
    /// <returns>Return variable "Integer" - specifies field ID which is the next in row and is still unused.</returns>
    [Obsolete('Replaced by GetNewFieldID(Enum "C4BC Object Type"; Code[20])', '2021-04')]/// 
    procedure GetNewFieldID(ForObjectType: Enum "C4BC Object Type"): Integer
    begin
        exit(GetNewFieldID(ForObjectType, ''));
    end;

    /// <summary> 
    /// Validate changes to default ranges to verify, whether the old range is not in use
    /// </summary>
    /// <param name="RangeType">Option (From,To), specify type of the range we want to validate.</param>
    /// <param name="OldRange">Integer, specify old range (the one before the change).</param>
    /// <param name="NewRange">Integer, specify new range (the one after the change).</param>
    local procedure ValidateChangeToDefaultRanges(RangeType: Option From,"To"; OldRange: Integer; NewRange: Integer)
    var
        C4BCExtensionObject: Record "C4BC Extension Object";

        OptionNames: List of [Text];
        OptionString: Text;
        C4BCObjectType: Enum "C4BC Object Type";

        OldRangeIsInUseErr: Label 'The range can not be change as there are extension lines with IDs from the existing range.';
    begin
        C4BCExtensionObject.SetRange("Assignable Range Code", Rec.Code);
        if not C4BCExtensionObject.ShouldCheckChange(RangeType, OldRange, NewRange) then
            exit;
        C4BCExtensionObject.SetFilterOnRangeChange(RangeType, OldRange, NewRange);
        if C4BCExtensionObject.IsEmpty() then
            exit;

        OptionNames := C4BCObjectType.Names();
        foreach OptionString in C4BCObjectType.Names() do begin
            Evaluate(C4BCObjectType, OptionString);
            if ShouldUseDefaultRanges(C4BCObjectType) then begin
                C4BCExtensionObject.SetRange("Object Type", C4BCObjectType);
                if not C4BCExtensionObject.IsEmpty() then
                    Error(OldRangeIsInUseErr);
            end;
        end;
    end;

    /// <summary> 
    /// Check whether the object ID is already in use based on setting of this range
    /// </summary>
    /// <param name="C4BCObjectType">Enum "C4BC Object Type", The object type which we want to check</param>
    /// <param name="ObjectID">Integer, ID of the object to check.</param>
    /// <param name="ForBusinessCentralInstance">Code[20], Code of the business central instance on which the object is used.</param>/// 
    /// <returns>Return variable "Boolean", whether the object is in use or not.</returns>
    procedure IsObjectIDAlreadyInUse(C4BCObjectType: Enum "C4BC Object Type"; ObjectID: Integer; ForBusinessCentralInstance: Code[20]): Boolean
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCExtensionObject.SetRange("Object Type", C4BCObjectType);
        C4BCExtensionObject.SetRange("Object ID", ObjectID);
        if Rec."Ranges per BC Instance" then begin
            if ForBusinessCentralInstance = '' then
                Error(MissingParameterErr, Rec.FieldCaption("Ranges per BC Instance"));

            C4BCExtensionObject.SetRange("Bus. Central Instance Filter", ForBusinessCentralInstance);
            C4BCExtensionObject.SetRange("Bus. Central Instance Linked", true);
        end;

        if not C4BCExtensionObject.IsEmpty then
            exit(true);
        exit(false);
    end;

    /// <summary> 
    /// Check whether the object name is already in use based on setting of this range
    /// </summary>
    /// <param name="C4BCObjectType">Enum "C4BC Object Type", The object type which we want to check</param>
    /// <param name="ObjectName">Text, Name of the object to check.</param>
    /// <param name="ForBusinessCentralInstance">Code[20], Code of the business central instance on which the object is used.</param>/// 
    /// <returns>Return variable "Boolean", whether the object is in use or not.</returns>
    procedure IsObjectNameAlreadyInUse(C4BCObjectType: Enum "C4BC Object Type"; ObjectName: Text; ForBusinessCentralInstance: Code[20]): Boolean
    var
        C4BCExtensionObject: Record "C4BC Extension Object";
    begin
        C4BCExtensionObject.SetRange("Object Type", C4BCObjectType);
        C4BCExtensionObject.SetRange("Object Name", ObjectName);
        if Rec."Ranges per BC Instance" then begin
            if ForBusinessCentralInstance = '' then
                Error(MissingParameterErr, Rec.FieldCaption("Ranges per BC Instance"));

            C4BCExtensionObject.SetRange("Bus. Central Instance Filter", ForBusinessCentralInstance);
            C4BCExtensionObject.SetRange("Bus. Central Instance Linked", true);
        end;

        if not C4BCExtensionObject.IsEmpty then
            exit(true);
        exit(false);
    end;

    local procedure FindGapInAssignableRange(var C4BCExtensionObject: Record "C4BC Extension Object"; ForObjectType: Enum "C4BC Object Type"; var NewObjectID: Integer): Boolean
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
        TempC4BCAssignableRangeLine: Record "C4BC Assignable Range Line" temporary;

        IDDiff, PrevID : Integer;
    begin
        TempC4BCAssignableRangeLine.DeleteAll();
        if ShouldUseDefaultRanges(ForObjectType) then begin
            if not Rec."Fill Object ID Gaps" then
                exit(false);

            TempC4BCAssignableRangeLine."Object Range From" := Rec."Default Object Range From";
            TempC4BCAssignableRangeLine."Object Range To" := Rec."Default Object Range To";
            TempC4BCAssignableRangeLine.Insert();
        end else begin
            C4BCAssignableRangeLine.SetRange("Assignable Range Code", Rec.Code);
            C4BCAssignableRangeLine.SetRange("Object Type", ForObjectType);
            C4BCAssignableRangeLine.SetRange("Fill Object ID Gaps", true);
            if C4BCAssignableRangeLine.FindSet() then
                repeat
                    TempC4BCAssignableRangeLine."Object Range From" := C4BCAssignableRangeLine."Object Range From";
                    TempC4BCAssignableRangeLine."Object Range To" := C4BCAssignableRangeLine."Object Range To";
                    TempC4BCAssignableRangeLine.Insert();
                until C4BCAssignableRangeLine.Next() < 1;
        end;

        if TempC4BCAssignableRangeLine.FindSet() then
            repeat
                PrevID := 0;
                IDDiff := TempC4BCAssignableRangeLine."Object Range To" - TempC4BCAssignableRangeLine."Object Range From" + 1;
                if IDDiff > C4BCExtensionObject.Count() then
                    if C4BCExtensionObject.FindSet() then
                        repeat
                            if PrevID = 0 then begin
                                NewObjectID := TempC4BCAssignableRangeLine."Object Range From";
                                if C4BCExtensionObject."Object ID" <> NewObjectID then
                                    if IsObjectIDFromRange(ForObjectType, NewObjectID) then
                                        exit(true);
                            end else begin
                                NewObjectID := PrevID + 1;
                                if (NewObjectID < C4BCExtensionObject."Object ID") and IsObjectIDFromRange(ForObjectType, NewObjectID) then
                                    exit(true);
                            end;
                            PrevID := C4BCExtensionObject."Object ID";
                        until C4BCExtensionObject.Next() < 1;
            until TempC4BCAssignableRangeLine.Next() < 1;
        Clear(NewObjectID);
        exit(false);
    end;
}
