table 80003 "C4BC Extension Line"
{
    Caption = 'Extension Line';

    fields
    {
        field(1; "Extension Code"; Code[20])
        {
            Caption = 'Extension Code';
            DataClassification = SystemMetadata;
            TableRelation = "C4BC Extension Header".Code where(Code = field("Extension Code"));
        }
        field(2; "Extension ID"; Guid)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
            TableRelation = "C4BC Extension Header".ID;
        }
        field(3; "Object Type"; Enum "C4BC Object Type")
        {
            Caption = 'Object Type';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                "Object ID" := GetNewObjectID();
            end;
        }
        field(4; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(5; "Object Name"; Text[100])
        {
            Caption = 'Object Name';
            DataClassification = SystemMetadata;
        }
        field(6; "Created By"; Text[50])
        {
            Caption = 'Created By';
            DataClassification = SystemMetadata;
        }

        field(100; "Assignable Range Code"; Code[20])
        {
            Caption = 'Assignable Range Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("C4BC Extension Header"."Assignable Range Code" where("Code" = field("Extension Code")));
        }
        field(101; "Bus. Central Instance Filter"; Code[20])
        {
            Caption = 'Business Central Instance Filter';
            FieldClass = FlowFilter;
        }
        field(102; "Bus. Central Instance Linked"; Boolean)
        {
            Caption = 'Bus. Central Instance Linked';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = exist("C4BC Extension Usage" where("Extension Code" = field("Extension Code"), "Business Central Instance Code" = field("Bus. Central Instance Filter")));
        }
    }

    keys
    {
        key(PK; "Extension Code", "Object Type", "Object ID")
        {
            Clustered = true;
        }
    }

    /// <summary> 
    /// Return a new object ID for this line. If the line already has ID, the ID is returned and new is not assigned.
    /// </summary>
    /// <returns>Return variable "Integer", ID of the object.</returns>
    procedure GetNewObjectID(): Integer
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        if Rec."Object ID" <> 0 then
            exit(Rec."Object ID");

        Rec.CalcFields("Assignable Range Code");
        Rec.TestField("Assignable Range Code");
        C4BCAssignableRangeHeader.Get("Assignable Range Code");
        exit(C4BCAssignableRangeHeader.GetNewID("Object Type"));
    end;
}