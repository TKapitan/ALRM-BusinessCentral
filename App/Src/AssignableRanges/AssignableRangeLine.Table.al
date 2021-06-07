/// <summary>
/// Table ART Assignable Range Line (ID 74179002).
/// </summary>
table 74179002 "ART Assignable Range Line"
{
    Caption = 'Assignable Range Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Assignable Range Code"; Code[20])
        {
            Caption = 'Assignable Range Code';
            DataClassification = CustomerContent;
        }
        field(3; "Object Type"; Enum "ART Object Type")
        {
            Caption = 'Object Type';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                ARTALRMManagement: Codeunit "ART ALRM Management";
            begin
                ARTALRMManagement.UseObjectTypeIDs(Rec."Object Type", true);
                ValidateChangeToRanges(xRec."Object Type", RangeType::From, xRec."Object Range From", 0);
                ValidateChangeToRanges(xRec."Object Type", RangeType::"To", xRec."Object Range To", 0);
            end;
        }
        field(4; "Object Range From"; Integer)
        {
            Caption = 'Object Range From';
            MinValue = 0;
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                ValidateChangeToRanges(Rec."Object Type", RangeType::From, xRec."Object Range From", Rec."Object Range From");
            end;
        }
        field(5; "Object Range To"; Integer)
        {
            Caption = 'Object Range To';
            MinValue = 0;
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                ValidateChangeToRanges(Rec."Object Type", RangeType::"To", xRec."Object Range To", Rec."Object Range To");
            end;
        }
        field(12; "Fill Object ID Gaps"; Boolean)
        {
            Caption = 'Fill Object ID Gaps';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Assignable Range Code", "Object Type", "Object Range From")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        CheckLine();
        CheckIfHeaderRangesNotInUseForObjectType();
    end;

    trigger OnModify()
    begin
        CheckLine();
        if xRec."Object Range To" <> Rec."Object Range To" then
            ValidateChangeToRanges(Rec."Object Type", RangeType::"To", xRec."Object Range To", Rec."Object Range To");
    end;

    trigger OnRename()
    begin
        if xRec."Object Type" <> Rec."Object Type" then begin
            ValidateChangeToRanges(xRec."Object Type", RangeType::From, xRec."Object Range From", 0);
            ValidateChangeToRanges(xRec."Object Type", RangeType::"To", xRec."Object Range To", 0);

            CheckIfHeaderRangesNotInUseForObjectType();
        end else
            if xRec."Object Range From" <> Rec."Object Range From" then
                ValidateChangeToRanges(xRec."Object Type", RangeType::From, xRec."Object Range From", Rec."Object Range From");
    end;

    trigger OnDelete()
    begin
        ValidateChangeToRanges(xRec."Object Type", RangeType::From, xRec."Object Range From", 0);
        ValidateChangeToRanges(xRec."Object Type", RangeType::"To", xRec."Object Range To", 0);
    end;

    var
        RangeType: Option From,"To";

    /// <summary> 
    /// Check current whether it can be saved to the database. Validate all required fields and verify logical condititions.
    /// </summary>
    local procedure CheckLine()
    begin
        Rec.TestField("Object Type");
        Rec.TestField("Object Range From");
        Rec.TestField("Object Range To");
        if Rec."Object Range From" > Rec."Object Range To" then
            Rec.FieldError("Object Range To");
    end;

    /// <summary>
    /// Check whether the object range from the header is in use for specific object type. If so, return error that it is not possible to create special range for this range.
    /// </summary>
    local procedure CheckIfHeaderRangesNotInUseForObjectType()
    var
        ARTExtensionObject: Record "ART Extension Object";
        ARTAssignableRangeLine: Record "ART Assignable Range Line";
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";

        ForObjectTypeTheHeaderRangeIsInUseErr: Label 'For %1 the header object range is in use hence it is not possible to define special range.', Comment = '%1 - Object type that is checked';
    begin
        ARTAssignableRangeHeader.Get(Rec."Assignable Range Code");
        if (ARTAssignableRangeHeader."Default Object Range From" = 0) and (ARTAssignableRangeHeader."Default Object Range To" = 0) then
            exit;

        ARTAssignableRangeLine.SetRange("Assignable Range Code", Rec."Assignable Range Code");
        ARTAssignableRangeLine.SetRange("Object Type", Rec."Object Type");
        if not ARTAssignableRangeLine.IsEmpty() then
            exit;

        ARTExtensionObject.SetRange("Assignable Range Code", Rec."Assignable Range Code");
        ARTExtensionObject.SetRange("Object Type", Rec."Object Type");
        ARTExtensionObject.SetFilter("Object ID", '<%1|>%2', Rec."Object Range From", Rec."Object Range To");
        if not ARTExtensionObject.IsEmpty() then
            Error(ForObjectTypeTheHeaderRangeIsInUseErr, Rec."Object Type");
    end;

    /// <summary> 
    /// Validate changes to ranges to verify, whether the old range is not in use
    /// </summary>
    /// <param name="ARTObjectType">Parameter of type Enum "ART Object Type".</param>
    /// <param name="RangeType">Option (From,To), specify type of the range we want to validate.</param>/// 
    /// <param name="OldRange">Integer, specify old range (the one before the change).</param>
    /// <param name="NewRange">Integer, specify new range (the one after the change).</param>
    local procedure ValidateChangeToRanges(ARTObjectType: Enum "ART Object Type"; RangeType: Option From,"To"; OldRange: Integer; NewRange: Integer)
    var
        ARTExtensionObject: Record "ART Extension Object";

        OldRangeIsInUseErr: Label 'The range can not be change as there are extension lines with IDs from the existing range.';
    begin
        ARTExtensionObject.SetRange("Assignable Range Code", Rec."Assignable Range Code");
        ARTExtensionObject.SetRange("Object Type", ARTObjectType);
        if not ARTExtensionObject.ShouldCheckChange(RangeType, OldRange, NewRange) then
            exit;
        ARTExtensionObject.SetFilterOnRangeChange(RangeType, OldRange, NewRange);
        if not ARTExtensionObject.IsEmpty() then
            Error(OldRangeIsInUseErr);
    end;
}