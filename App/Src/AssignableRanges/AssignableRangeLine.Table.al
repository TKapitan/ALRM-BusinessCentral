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
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Object Type"; Enum "C4BC Object Type")
        {
            Caption = 'Object Type';
            DataClassification = SystemMetadata;
        }
        field(4; "Object Range From"; Integer)
        {
            Caption = 'Object Range From';
            MinValue = 0;
            DataClassification = SystemMetadata;
        }
        field(5; "Object Range To"; Integer)
        {
            Caption = 'Object Range To';
            MinValue = 0;
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Assignable Range Code", "Line No.")
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

    // TODO Ondelete/Onmodify Check whether it's used somewhere
}