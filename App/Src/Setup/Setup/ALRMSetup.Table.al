/// <summary>
/// Table C4BC ALRM Setup (ID 80007).
/// </summary>
table 80007 "C4BC ALRM Setup"
{
    Caption = 'ALRM Setup';
    DrillDownPageId = "C4BC ALRM Setup";
    LookupPageId = "C4BC ALRM Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(5; "Minimal API Version"; Enum "C4BC API Version")
        {
            Caption = 'Minimal API Version';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    /// <summary>
    /// Check whether the specified API version is within allowed version.
    /// </summary>
    /// <param name="CalledAPIVersion">Enum "C4BC API Version", specifies used API version.</param>
    procedure CheckAPIVersion(CalledAPIVersion: Enum "C4BC API Version")
    var
        ErrorTextErr: Label 'It is neccessary to use minimal API version %1 but %2 was used.', Comment = '%1 - Minimal supported API Version, %2 - Used API Version';
    begin
        if Rec."Minimal API Version".AsInteger() > CalledAPIVersion.AsInteger() then
            Error(ErrorTextErr, Rec."Minimal API Version", CalledAPIVersion);
    end;
}