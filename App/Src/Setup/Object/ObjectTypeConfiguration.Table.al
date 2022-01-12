/// <summary>
/// Table C4BC Object Type Configuration (ID 80008).
/// </summary>
table 80008 "C4BC Object Type Configuration"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Object Type"; Enum "C4BC Object Type")
        {
            Caption = 'Object Type';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Is Licensed"; Boolean)
        {
            Caption = 'Is Licensed';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if not Rec."Is Licensed" then
                    ClearIncludedObjectIDRange();
            end;
        }
        field(20; "Has ID"; Boolean)
        {
            Caption = 'Has ID';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if not Rec."Has ID" then
                    ClearIncludedObjectIDRange();
            end;
        }
        field(21; "Extends Other Objects"; Boolean)
        {
            Caption = 'Extends Other Objects';
            DataClassification = SystemMetadata;
        }

        field(30; "Max Name Length"; Integer)
        {
            Caption = 'Max Name Length';
            DataClassification = SystemMetadata;
        }

        field(40; "Included Object ID From"; Integer)
        {
            Caption = 'Included Object ID From';
            DataClassification = CustomerContent;
            MinValue = 0;
            BlankZero = true;

            trigger OnValidate()
            begin
                Rec.TestField("Is Licensed");
                Rec.TestField("Has ID");

                if Rec."Included Object ID From" > Rec."Included Object ID To" then
                    if Rec."Included Object ID To" = 0 then
                        Rec.Validate("Included Object ID To", Rec."Included Object ID From")
                    else
                        Rec.FieldError("Included Object ID From");
            end;
        }
        field(41; "Included Object ID To"; Integer)
        {
            Caption = 'Included Object ID To';
            DataClassification = CustomerContent;
            MinValue = 0;
            BlankZero = true;

            trigger OnValidate()
            begin
                Rec.TestField("Is Licensed");
                Rec.TestField("Has ID");

                if Rec."Included Object ID To" < Rec."Included Object ID From" then
                    Rec.FieldError("Included Object ID To");
            end;
        }
    }

    keys
    {
        key(PK; "Object Type")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Specifies whether the object ID is included in the base BC license.
    /// </summary>
    /// <param name="ObjectID">Object ID to check</param>
    /// <returns>True when the object ID is included</returns>
    procedure IsObjectIDIncluded(ObjectID: Integer): Boolean
    begin
        if ObjectID = 0 then
            exit(false);
        exit((ObjectID >= Rec."Included Object ID From") and (ObjectID <= Rec."Included Object ID To"));
    end;

    local procedure ClearIncludedObjectIDRange()
    begin
        Rec.Validate("Included Object ID From", 0);
        Rec.Validate("Included Object ID To", 0);
    end;
}