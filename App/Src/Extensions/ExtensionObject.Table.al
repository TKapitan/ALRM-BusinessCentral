/// <summary>
/// Table C4BC Extension Object (ID 80003).
/// </summary>
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

            trigger OnValidate()
            begin
                Rec.TestField("Object ID");
                if CheckObjectIDDuplicity() then
                    Error(DuplicitNameErr, Rec.FieldCaption("Object ID"), Rec."Object ID", Rec."Object Type");
                if not IsObjectIDWithinRange() then
                    Error(InvalidObjectIDErr, Rec."Object ID", Rec."Object Type");
            end;
        }
        field(5; "Object Name"; Text[100])
        {
            Caption = 'Object Name';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                C4BCObjectTypeConfiguration: Record "C4BC Object Type Configuration";

                TemplateRule: Text;

                MaxLengthOfNameErr: Label 'The maximal name length for %1 is %2 chars. The current name is %3 chars long.', Comment = '%1 - Object type name, %2 - maximal name length, %3 - current name length';
            begin
                Rec.TestField("Object Name");
                if C4BCObjectTypeConfiguration.IsObjectTypeConfigurationUsed() then begin
                    Rec.TestField("Object Type");
                    C4BCObjectTypeConfiguration.Get(Rec."Object Type");
                    if C4BCObjectTypeConfiguration."Max Name Length" <> 0 then
                        if StrLen(Rec."Object Name") > C4BCObjectTypeConfiguration."Max Name Length" then
                            Error(MaxLengthOfNameErr, Rec."Object Type", StrLen(Rec."Object Name"), C4BCObjectTypeConfiguration."Max Name Length");
                end;
                if CheckObjectNameDuplicity() then
                    Error(DuplicitNameErr, Rec.FieldCaption("Object Name"), Rec."Object Name", Rec."Object Type");
                if not ObjectNameTemplateRulesMet(TemplateRule) then
                    Error(ObjectNameTemplateRulesErr, Rec."Object Name", TemplateRule);
            end;
        }
        field(6; "Created By"; Text[50])
        {
            Caption = 'Created By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(7; "Extends Object Name"; Text[100])
        {
            Caption = 'Extends Object Name';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            var
                ObjectTypeConfiguration: Record "C4BC Object Type Configuration";

                IObjectType: Interface "C4BC IObject Type";
                DoesNotExtendsObjectErr: Label '%1 object type does not extend another object.', Comment = '%1 - object type that extends another object.';
            begin
                if Rec."Extends Object Name" = '' then
                    exit;
                Rec.TestField("Object Type");

                if ObjectTypeConfiguration.IsObjectTypeConfigurationUsed() then begin
                    ObjectTypeConfiguration.Get(Rec."Object Type");
                    if not ObjectTypeConfiguration."Extends Other Objects" then
                        Error(DoesNotExtendsObjectErr, Rec."Object Type");
                end else begin
                    // Deprecated 2021/Q4 ->
                    IObjectType := Rec."Object Type";
                    if not IObjectType.ExtendOtherObjects() then
                        Error(DoesNotExtendsObjectErr, Rec."Object Type");
                    // Deprecated 2021/Q4 <-
                end;
            end;
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
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
    begin
        Rec.TestField("Object Type");
        if "Object ID" = 0 then
            "Object ID" := GetNewObjectID();
        Rec.TestField("Object ID");
        Rec.TestField("Object Name");

        C4BCExtensionHeader.Get(Rec."Extension Code");
        "Extension ID" := C4BCExtensionHeader.ID;
        if GuiAllowed then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
    end;

    trigger OnModify()
    begin
        Rec.TestField("Object Name");
    end;

    trigger OnRename()
    begin
        Rec.TestField("Object Type");
        Rec.TestField("Object ID");
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
        InvalidObjectIDErr: Label 'ID %1 is not within the range specified for object type %2 in this extension.', Comment = '%1 - Used Object ID, %2 - Used Object Type';
        DuplicitNameErr: Label '%1 "%2" for %3 is already in use.', Comment = '%1 - Field that has already used value, %2 - Value of that field, %3 - Object type that use this name.';
        ObjectNameTemplateRulesErr: Label 'Object name "%1" does not meet template rules defined in assignable range header. Template rules are: "%2"', Comment = '%1 - Name of object that does not meet rules, %2 - template rules';

    /// <summary> 
    /// Return a new object ID for this line. If the line already has ID, the ID is returned and new is not assigned.
    /// </summary>
    /// <returns>Return variable "Integer", ID of the object.</returns>
    procedure GetNewObjectID(): Integer
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";

        C4BCALRMManagement: Codeunit "C4BC ALRM Management";
    begin
        if Rec."Object ID" <> 0 then
            exit(Rec."Object ID");

        if not C4BCALRMManagement.UseObjectTypeIDs(Rec."Object Type", false) then
            exit(GetNewImaginaryObjectID());

        C4BCExtensionHeader.Get(Rec."Extension Code");
        Rec.CalcFields("Assignable Range Code");
        Rec.TestField("Assignable Range Code");
        C4BCAssignableRangeHeader.Get("Assignable Range Code");
        exit(C4BCAssignableRangeHeader.GetNewObjectID("Object Type", C4BCExtensionHeader.GetUsageOfExtension()));
    end;

    /// <summary>
    /// Return a new imaginary object ID that is created just as a placeholder for object types that do not use IDs for identification. The ID is unique, but is managed internally.
    /// </summary>
    /// <returns>Return variable "Integer", imaginary ID of the object.</returns>
    procedure GetNewImaginaryObjectID(): Integer
    var
        C4BCExtensionObject: Record "C4BC Extension Object";

        C4BCALRMManagement: Codeunit "C4BC ALRM Management";
    begin
        if Rec."Object ID" <> 0 then
            exit(Rec."Object ID");

        if C4BCALRMManagement.UseObjectTypeIDs(Rec."Object Type", false) then
            exit(GetNewObjectID());

        C4BCExtensionObject.LockTable();
        C4BCExtensionObject.SetRange("Extension Code", Rec."Extension Code");
        C4BCExtensionObject.SetRange("Object Type", Rec."Object Type");
        if C4BCExtensionObject.FindLast() then
            exit(C4BCExtensionObject."Object ID" + 1);
        exit(1);
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
    /// Return a boolean value indicating whether the specified object ID already exists for currenct object type.
    /// </summary>
    /// <returns>Return variable "Boolean", true = duplicit</returns>
    local procedure CheckObjectIDDuplicity(): Boolean
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        C4BCExtensionHeader.Get(Rec."Extension Code");
        C4BCAssignableRangeHeader.Get(C4BCExtensionHeader."Assignable Range Code");
        exit(C4BCAssignableRangeHeader.IsObjectIDAlreadyInUse(Rec."Object Type", Rec."Object ID", C4BCExtensionHeader.GetUsageOfExtension()));
    end;

    /// <summary>
    /// Return a boolean value indicating whether the specified object ID is within allowed range for the object type and assignable range.
    /// </summary>
    /// <returns>Return variable "Boolean", true = the ID is within allowed ranges.</returns>
    local procedure IsObjectIDWithinRange(): Boolean
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
    begin
        C4BCExtensionHeader.Get(Rec."Extension Code");
        C4BCAssignableRangeHeader.Get(C4BCExtensionHeader."Assignable Range Code");
        exit(C4BCAssignableRangeHeader.IsObjectIDFromRange(Rec."Object Type", Rec."Object ID"));
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

    /// <summary> 
    /// Check whether the name template rule is met or not
    /// </summary>
    /// <param name="TemplateRule">Text, used rule as a filter string.</param>
    /// <returns>Return variable "Boolean".</returns>
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