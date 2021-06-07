/// <summary>
/// Table ART Extension Usage (ID 74179004).
/// </summary>
table 74179004 "ART Extension Usage"
{
    Caption = 'Extension Usage';
    LookupPageId = "ART Extension Usage List";
    DrillDownPageId = "ART Extension Usage List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Extension Code"; Code[20])
        {
            Caption = 'Extension Code';
            TableRelation = "ART Extension Header".Code;
            DataClassification = CustomerContent;
        }
        field(2; "Business Central Instance Code"; Code[20])
        {
            Caption = 'Business Central Instance Code';
            TableRelation = "ART Business Central Instance"."Code";
            DataClassification = CustomerContent;
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(11; "Ending Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (xRec."Ending Date" <> 0D) and (Rec."Ending Date" = 0D) then
                    TestRangesPerInstanceUsage()
            end;
        }
    }

    keys
    {
        key(PK; "Extension Code", "Business Central Instance Code", "Starting Date")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        TestRangesPerInstanceUsage()
    end;

    trigger OnRename()
    var
        CannotBeRenamedErr: Label 'The record can not be renamed.';
    begin
        Error(CannotBeRenamedErr);
    end;

    local procedure TestRangesPerInstanceUsage()
    var
        ARTExtensionUsage: Record "ART Extension Usage";
        ARTExtensionHeader: Record "ART Extension Header";
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";

        ExtensionWithPerRangesMustHaveOnlyOneUsageErr: Label 'Extension with %1 = %2 has to have usage in one Business Central instance only.', Comment = '%1 - Field Caption, %2 - Field Value';
    begin
        ARTExtensionHeader.Get(Rec."Extension Code");
        ARTExtensionHeader.TestField("Assignable Range Code");
        ARTAssignableRangeHeader.Get(ARTExtensionHeader."Assignable Range Code");
        if ARTAssignableRangeHeader."Ranges per BC Instance" then begin
            ARTExtensionUsage.SetRange("Extension Code", Rec."Extension Code");
            ARTExtensionUsage.SetFilter("Business Central Instance Code", '<>%1', Rec."Business Central Instance Code");
            ARTExtensionUsage.SetRange("Ending Date", 0D);
            if not ARTExtensionUsage.IsEmpty() then
                Error(ExtensionWithPerRangesMustHaveOnlyOneUsageErr, ARTAssignableRangeHeader.FieldCaption("Ranges per BC Instance"), true);
        end;
    end;
}