/// <summary>
/// Report C4BC Create License File (ID 80000).
/// </summary>
report 80000 "C4BC Create License File"
{
    Caption = 'Create License Object Range CSV file';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;

    dataset
    {
        dataitem("C4BC Extension Usage"; "C4BC Extension Usage")
        {
            trigger OnPreDataItem()
            begin
                "C4BC Extension Usage".SetRange("Business Central Instance Code", ForBCInstanceCode);
                if ToDate <> 0D then begin
                    "C4BC Extension Usage".SetFilter("Starting Date", '<=%1', ToDate);
                    "C4BC Extension Usage".SetFilter("Ending Date", '>=%1|%2', ToDate, 0D);
                end;

                if not TempC4BCAssignableRangeLine.IsTemporary() then
                    Error('');
                TempC4BCAssignableRangeLine.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            var
                C4BCExtensionObject: Record "C4BC Extension Object";

                C4BCIObjectLicensing: Interface "C4BC IObject Type";
                CurrObjectID: Integer;
            begin
                C4BCExtensionObject.SetAutoCalcFields("Assignable Range Code");
                C4BCExtensionObject.SetRange("Extension Code", "C4BC Extension Usage"."Extension Code");
                if C4BCExtensionObject.FindSet() then
                    repeat
                        CurrObjectID := C4BCExtensionObject."Object ID";
                        C4BCIObjectLicensing := C4BCExtensionObject."Object Type";
                        if C4BCIObjectLicensing.IsLicensed() then begin
                            Clear(TempC4BCAssignableRangeLine);

                            TempC4BCAssignableRangeLine.SetRange("Assignable Range Code", C4BCExtensionObject."Assignable Range Code");
                            TempC4BCAssignableRangeLine.SetRange("Object Type", C4BCExtensionObject."Object Type");
                            TempC4BCAssignableRangeLine.SetRange("Object Range From", CurrObjectID + 1);
                            if TempC4BCAssignableRangeLine.FindFirst() then
                                // Add new object at the beginning of existing range
                                TempC4BCAssignableRangeLine.Rename(C4BCExtensionObject."Assignable Range Code", C4BCExtensionObject."Object Type", CurrObjectID)
                            else begin
                                TempC4BCAssignableRangeLine.SetRange("Object Range From");
                                TempC4BCAssignableRangeLine.SetRange("Object Range To", CurrObjectID - 1);
                                if TempC4BCAssignableRangeLine.FindFirst() then begin
                                    // Add new object at the end of existing range
                                    TempC4BCAssignableRangeLine."Object Range To" := CurrObjectID;
                                    TempC4BCAssignableRangeLine.Modify(false);
                                end else begin
                                    // Create new range
                                    Clear(TempC4BCAssignableRangeLine);
                                    TempC4BCAssignableRangeLine.Init();
                                    TempC4BCAssignableRangeLine."Assignable Range Code" := C4BCExtensionObject."Assignable Range Code";
                                    TempC4BCAssignableRangeLine."Object Type" := C4BCExtensionObject."Object Type";
                                    TempC4BCAssignableRangeLine."Object Range From" := CurrObjectID;
                                    TempC4BCAssignableRangeLine."Object Range To" := CurrObjectID;
                                    TempC4BCAssignableRangeLine.Insert(false);
                                end;
                            end;
                        end;
                    until C4BCExtensionObject.Next() < 1;
            end;

            trigger OnPostDataItem()
            var
                ExportedText: TextBuilder;

                CSVHeaderTxt: Label 'ObjectType,FromObjectID,ToObjectID,Read,Insert,Modify,Delete,Execute,AvailableRange,Used,ObjectTypeRemaining,CompanyObjectPermissionID', Locked = true;
            begin
                Clear(TempC4BCAssignableRangeLine);
                if not TempC4BCAssignableRangeLine.FindSet() then
                    exit;

                ExportedText.AppendLine(CSVHeaderTxt);
                repeat
                    ExportedText.AppendLine(BuildLicenseLine(TempC4BCAssignableRangeLine));
                until TempC4BCAssignableRangeLine.Next() < 1;
                ExportLicenseFile(ExportedText);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    Caption = 'General';
                    field(ForBCInstanceCodeField; ForBCInstanceCode)
                    {
                        Caption = 'For Business Central Instance';
                        ToolTip = 'Specifies code of the Business Central instance for which we want to export the license.';
                        TableRelation = "C4BC Business Central Instance".Code;
                        ApplicationArea = All;
                    }
                    field(ToDateField; ToDate)
                    {
                        Caption = 'To Date';
                        ToolTip = 'Specifies to which date we want to create list of used objects.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    trigger OnInitReport()
    begin
        ToDate := WorkDate();
    end;

    var
        TempC4BCAssignableRangeLine: Record "C4BC Assignable Range Line" temporary;
        ForBCInstanceCode: Code[20];
        ToDate: Date;

    /// <summary> 
    /// Create a file line with license details for specific range of used objects
    /// </summary>
    /// <param name="TempExpC4BCAssignableRangeLine">PRecord "C4BC Assignable Range Line" temporary, specifies details of the current range.</param>
    /// <returns>Return variable "Text", details about current range in the requested format.</returns>
    local procedure BuildLicenseLine(TempExpC4BCAssignableRangeLine: Record "C4BC Assignable Range Line" temporary): Text
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";

        BuildedLine: TextBuilder;
        FirstRangeID, LastRangeID : Integer;

        SplitingCharTxt: Label ',', Locked = true;
        DirectPermissionTxt: Label 'Direct', Locked = true;
        NullTxt: Label '0', Locked = true;
    begin
        BuildedLine.Append(Format(GetObjectTypeFormattedForLicenseGenerator(TempExpC4BCAssignableRangeLine."Object Type")));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempExpC4BCAssignableRangeLine."Object Range From"));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempExpC4BCAssignableRangeLine."Object Range To"));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(DirectPermissionTxt));
        BuildedLine.Append(SplitingCharTxt);

        C4BCAssignableRangeHeader.Get(TempExpC4BCAssignableRangeLine."Assignable Range Code");
        FirstRangeID := C4BCAssignableRangeHeader.GetVeryFirstObjectIDFromRangeBasedOnObjectID(TempExpC4BCAssignableRangeLine."Object Type", TempExpC4BCAssignableRangeLine."Object Range From");
        LastRangeID := C4BCAssignableRangeHeader.GetVeryLastObjectIDFromRangeBasedOnObjectID(TempExpC4BCAssignableRangeLine."Object Type", TempExpC4BCAssignableRangeLine."Object Range To");

        BuildedLine.Append(Format(FirstRangeID) + ' - ' + Format(LastRangeID));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(Format(TempExpC4BCAssignableRangeLine."Object Range To" - TempExpC4BCAssignableRangeLine."Object Range From" + 1));
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(NullTxt);
        BuildedLine.Append(SplitingCharTxt);
        BuildedLine.Append(NullTxt);
        exit(BuildedLine.ToText());
    end;

    /// <summary> 
    /// Description for GetObjectTypeFormattedForLicenseGenerator.
    /// </summary>
    /// <param name="OriginalC4BCObjectType">Parameter of type Enum "C4BC Object Type".</param>
    /// <returns>Return variable "Text".</returns>
    local procedure GetObjectTypeFormattedForLicenseGenerator(OriginalC4BCObjectType: Enum "C4BC Object Type"): Text
    var
        IsHandled: Boolean;
        TempText: Text;
    begin
        OnGetObjectTypeFormattedForLicenseGenerator(IsHandled, OriginalC4BCObjectType, TempText);
        if IsHandled then
            exit(TempText);

        case OriginalC4BCObjectType of
            OriginalC4BCObjectType::Table:
                exit('TableData');
            OriginalC4BCObjectType::"XML Port":
                exit('XMLPort');
            else
                exit(Format(OriginalC4BCObjectType));
        end;
    end;

    /// <summary> 
    /// Create and download file that contains license details
    /// </summary>
    /// <param name="ExportedText">TextBuilder, contains text that should be exported as a context of the downloaded file.</param>
    local procedure ExportLicenseFile(var ExportedText: TextBuilder)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";

        OutStream: OutStream;
    begin
        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(ExportedText.ToText());
        FileManagement.BLOBExportWithEncoding(TempBlob, 'ObjectPermissionExport.csv', true, TextEncoding::UTF8);
    end;

    [IntegrationEvent(false, false)]
    /// <summary> 
    /// Integration Event that is called when the object type enum is translated for license generator
    /// </summary>
    /// <param name="IsHandled">Boolean, if true, the value of ReturnAsObjectType parameter is returned and process ends.</param>
    /// <param name="OriginalC4BCObjectType">Enum "C4BC Object Type", specifies which object type should be translated.</param>
    /// <param name="ReturnAsObjectType">Text, return value (how the object type should be called in license generator).</param>
    local procedure OnGetObjectTypeFormattedForLicenseGenerator(IsHandled: Boolean; OriginalC4BCObjectType: Enum "C4BC Object Type"; var ReturnAsObjectType: Text)
    begin
    end;
}