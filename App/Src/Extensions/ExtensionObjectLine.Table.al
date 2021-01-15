/// <summary>
/// Table C4BC Extension Object Line (ID 80006).
/// </summary>
table 80006 "C4BC Extension Object Line"
{
    Caption = 'Extension Object Lines';

    fields
    {
        field(1; "Extension Code"; Code[20])
        {
            Caption = 'Extension Code';
            DataClassification = SystemMetadata;
            TableRelation = "C4BC Extension Header".Code where(Code = field("Extension Code"));
        }
        field(3; "Object Type"; Enum "C4BC Object Type")
        {
            Caption = 'Object Type';
            DataClassification = SystemMetadata;
        }
        field(4; "Object ID"; Integer)
        {
            Caption = 'Object ID';
            DataClassification = SystemMetadata;
            Editable = false;
            BlankZero = true;
            TableRelation = "C4BC Extension Object"."Object ID" where("Extension Code" = field("Extension Code"), "Object Type" = field("Object Type"));

            trigger OnValidate()
            begin
                ID := GetNewFieldLineID();
            end;
        }
        field(5; ID; Integer)
        {
            Caption = 'ID';
            Editable = false;
            DataClassification = CustomerContent;
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
        key(PK; "Extension Code", "Object Type", "Object ID", "ID")
        {
            Clustered = true;
        }
    }

    /// <summary> 
    /// Return new field ID for a field
    /// </summary>
    /// <returns>Return variable "Integer", new ID.</returns>
    procedure GetNewFieldLineID(): Integer
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        Rec.CalcFields("Assignable Range Code");
        Rec.TestField("Assignable Range Code");

        C4BCExtensionHeader.Get(Rec."Extension Code");
        C4BCAssignableRangeHeader.Get("Assignable Range Code");
        exit(C4BCAssignableRangeHeader.GetNewFieldID(Rec."Object Type", C4BCExtensionHeader.GetUsageOfExtension()));
    end;

}