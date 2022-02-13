/// <summary>
/// Table C4BC Extension Usage (ID 80004).
/// </summary>
table 80004 "C4BC Extension Usage"
{
    Caption = 'Extension Usage';
    LookupPageId = "C4BC Extension Usage List";
    DrillDownPageId = "C4BC Extension Usage List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Extension Code"; Code[20])
        {
            Caption = 'Extension Code';
            TableRelation = "C4BC Extension Header".Code;
            DataClassification = CustomerContent;
        }
        field(2; "Business Central Instance Code"; Code[20])
        {
            Caption = 'Business Central Instance Code';
            TableRelation = "C4BC Business Central Instance"."Code";
            DataClassification = CustomerContent;
        }
        field(10; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(11; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
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

    local procedure TestRangesPerInstanceUsage()
    var
        C4BCExtensionUsage: Record "C4BC Extension Usage";
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";

        ExtensionWithPerRangesMustHaveOnlyOneUsageErr: Label 'Extension with %1 = %2 has to have usage in one Business Central instance only.', Comment = '%1 - Field Caption, %2 - Field Value';
    begin
        C4BCExtensionHeader.Get(Rec."Extension Code");
        C4BCExtensionHeader.TestField("Assignable Range Code");
        C4BCAssignableRangeHeader.Get(C4BCExtensionHeader."Assignable Range Code");
        if C4BCAssignableRangeHeader."Ranges per BC Instance" then begin
            C4BCExtensionUsage.SetRange("Extension Code", Rec."Extension Code");
            C4BCExtensionUsage.SetFilter("Business Central Instance Code", '<>%1', Rec."Business Central Instance Code");
            C4BCExtensionUsage.SetRange("Ending Date", 0D);
            if not C4BCExtensionUsage.IsEmpty() then
                Error(ExtensionWithPerRangesMustHaveOnlyOneUsageErr, C4BCAssignableRangeHeader.FieldCaption("Ranges per BC Instance"), true);
        end;
    end;
}