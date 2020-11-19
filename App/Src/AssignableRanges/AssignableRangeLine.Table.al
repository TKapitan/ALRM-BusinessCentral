table 80002 "C4BC Assignable Range Line"
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
        field(3; "Object Type"; Enum "C4BC Object Type")
        {
            Caption = 'Object Type';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
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
        CheckLine()
    end;

    trigger OnModify()
    begin
        CheckLine()
    end;

    trigger OnRename()
    begin
        if xRec."Object Type" <> Rec."Object Type" then begin
            ValidateChangeToRanges(xRec."Object Type", RangeType::From, xRec."Object Range From", 0);
            ValidateChangeToRanges(xRec."Object Type", RangeType::"To", xRec."Object Range To", 0);
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
    /// Validate changes to ranges to verify, whether the old range is not in use
    /// </summary>
    /// <param name="C4BCObjectType">Parameter of type Enum "C4BC Object Type".</param>
    /// <param name="RangeType">Option (From,To), specify type of the range we want to validate.</param>/// 
    /// <param name="OldRange">Integer, specify old range (the one before the change).</param>
    /// <param name="NewRange">Integer, specify new range (the one after the change).</param>
    local procedure ValidateChangeToRanges(C4BCObjectType: Enum "C4BC Object Type"; RangeType: Option From,"To"; OldRange: Integer; NewRange: Integer)
    var
        C4BCExtensionLine: Record "C4BC Extension Line";

        OldRangeIsInUseErr: Label 'The range can not be change as there are extension lines with IDs from the existing range.';
    begin
        C4BCExtensionLine.SetRange("Assignable Range Code", Rec."Assignable Range Code");
        C4BCExtensionLine.SetRange("Object Type", C4BCObjectType);
        if not C4BCExtensionLine.ShouldCheckChange(RangeType, OldRange, NewRange) then
            exit;
        C4BCExtensionLine.SetFilterOnRangeChange(RangeType, OldRange, NewRange);
        if not C4BCExtensionLine.IsEmpty() then
            Error(OldRangeIsInUseErr);
    end;
}