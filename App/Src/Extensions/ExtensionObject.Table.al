table 80003 "C4BC Extension Object"
{
    Caption = 'Extension Object';

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
            BlankZero = true;
        }
        field(5; "Object Name"; Text[100])
        {
            Caption = 'Object Name';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                TemplateRule: Text;
            begin
                Rec.TestField("Object Name");
                if CheckObjectNameDuplicity() then
                    Error(DuplicitObjectNameErr);
                if not ObjectNameTemplateRulesMet(TemplateRule) then
                    Error(ObjectNameTemplateRulesErr, TemplateRule);
            end;
        }
        field(6; "Created By"; Text[50])
        {
            Caption = 'Created By';
            DataClassification = SystemMetadata;
            Editable = false;
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

    trigger OnInsert()
    begin
        if GuiAllowed then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
    end;

    trigger OnDelete()
    var
        C4BCExtensionObjectLine: Record "C4BC Extension Object Line";
    begin
        C4BCExtensionObjectLine.SetRange("Extension Code", Rec."Extension Code");
        C4BCExtensionObjectLine.SetRange("Object Type", Rec."Object Type");
        C4BCExtensionObjectLine.SetRange("Object ID", Rec."Object ID");
        C4BCExtensionObjectLine.DeleteAll(true);
    end;

    var
        DuplicitObjectNameErr: Label 'Object name with the same object type cannot be duplicit.';
        ObjectNameTemplateRulesErr: Label 'Object name does not meet template rules defined in assignable range header. Template rules are: "%1"', Comment = '%1 = template rules';

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
        exit(C4BCAssignableRangeHeader.GetNewObjectID("Object Type"));
    end;

    /// <summary> 
    /// Specifies whether the change of the ID range should be checked. If the new range is wider than the previous, the range mustn't be checked.
    /// </summary>
    /// <param name="RangeType">Option (From,To), specify type of the range we want to validate.</param>/// 
    /// <param name="OldRange">Integer, specify old range (the one before the change).</param>
    /// <param name="NewRange">Integer, specify new range (the one after the change).</param>
    /// <returns>Return variable "Boolean", whether the change should be validated.</returns>
    procedure ShouldCheckChange(RangeType: Option From,"To"; OldRange: Integer; NewRange: Integer): Boolean
    begin
        case RangeType of
            RangeType::From:
                if NewRange < OldRange then
                    exit(false);
            RangeType::"To":
                if NewRange > OldRange then
                    exit(false);
            else
                exit(false);
        end;
        exit(true);
    end;

    /// <summary> 
    /// Set the filter on the Object ID field using old and new Object ID range.
    /// </summary>
    /// <param name="RangeType">Option (From,To), specify type of the range we want to validate.</param>/// 
    /// <param name="OldRange">Integer, specify old range (the one before the change).</param>
    /// <param name="NewRange">Integer, specify new range (the one after the change).</param>
    procedure SetFilterOnRangeChange(RangeType: Option From,"To"; OldRange: Integer; NewRange: Integer)
    begin
        if not ShouldCheckChange(RangeType, OldRange, NewRange) then
            exit;

        case RangeType of
            RangeType::From:
                SetRange("Object ID", OldRange, NewRange - 1);
            RangeType::"To":
                SetRange("Object ID", NewRange + 1, OldRange);
        end;
    end;

    /// <summary>
    /// Return a boolean value indicating whether the specified object name already exists for currenct object type.
    /// </summary>
    /// <returns>Return variable "Boolean", true = duplicit</returns>
    local procedure CheckObjectNameDuplicity(): Boolean
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        C4BCExtensionHeader.Get(Rec."Extension Code");
        C4BCAssignableRangeHeader.Get(C4BCExtensionHeader."Assignable Range Code");
        exit(C4BCAssignableRangeHeader.IsObjectNameAlreadyInUse(Rec."Object Type", Rec."Object Name", C4BCExtensionHeader.GetUsageOfExtension()));
    end;

    local procedure ObjectNameTemplateRulesMet(var TemplateRule: Text): Boolean
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        TempC4BCExtensionObject: Record "C4BC Extension Object" temporary;
    begin
        Rec.CalcFields("Assignable Range Code");
        Rec.TestField("Assignable Range Code");
        if C4BCAssignableRangeHeader.Get(Rec."Assignable Range Code") then
            if C4BCAssignableRangeHeader."Object Name Template" <> '' then begin
                TemplateRule := C4BCAssignableRangeHeader."Object Name Template";
                TempC4BCExtensionObject."Object Name" := Rec."Object Name";
                TempC4BCExtensionObject.Insert(false);
                TempC4BCExtensionObject.SetFilter("Object Name", C4BCAssignableRangeHeader."Object Name Template");
                if not TempC4BCExtensionObject.IsEmpty then
                    exit(true);
            end else
                exit(true);
    end;
}