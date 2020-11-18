codeunit 79000 "C4BC Assignable Range Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        BadNewIDErr: Label 'Bad new ID. Expected %1, Received %2.', Locked = true;
        C4BCAssignableRangeHeader_Code_01Txt: Label 'RANGE1';
        C4BCAssignableRangeHeader_Code_02Txt: Label 'RANGE2';
        C4BCAssignableRangeHeader_Code_03Txt: Label 'RANGE3';

    [Test]
    /// <summary> 
    /// Test getting the ID for the first time for specific Assignable Range
    /// </summary>
    procedure TestGettingIDForTheFirstTime()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        TempInt: Integer;
    begin
        Initialize();

        C4BCAssignableRangeHeader.Get(C4BCAssignableRangeHeader_Code_01Txt);
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table);
        Assert.IsTrue(TempInt = 50000, StrSubstNo(BadNewIDErr, 50000, TempInt));
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Report);
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));

        C4BCAssignableRangeHeader.Get(C4BCAssignableRangeHeader_Code_02Txt);
        asserterror C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table);
        Assert.AssertNothingInsideFilter();
    end;

    [Test]
    /// <summary> 
    /// Test overloaded public method GetNewID when the one should be used for specific records, the second one without any limitations
    /// </summary>
    procedure TestAccessingGetNewIDOverloadedMethods()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        TempInt: Integer;
    begin
        Initialize();

        C4BCAssignableRangeHeader.Get(C4BCAssignableRangeHeader_Code_01Txt);
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table);
        Assert.IsTrue(TempInt = 50000, StrSubstNo(BadNewIDErr, 50000, TempInt));
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 50000, StrSubstNo(BadNewIDErr, 50000, TempInt));

        C4BCAssignableRangeHeader.Get(C4BCAssignableRangeHeader_Code_03Txt);
        asserterror C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table);
        Assert.ExpectedError('instance ID and the value must not be empty');
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));
    end;

    /// <summary> 
    /// Initializace records for assignable range tests
    /// </summary>
    local procedure Initialize()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
    begin
        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_01Txt;
        C4BCAssignableRangeHeader."Default Range From" := 30000;
        C4BCAssignableRangeHeader."Default Range To" := 39000;
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeLine."Assignable Range Code" := C4BCAssignableRangeHeader_Code_01Txt;
        C4BCAssignableRangeLine."Object Type" := C4BCAssignableRangeLine."Object Type"::Table;
        C4BCAssignableRangeLine."Object Range From" := 50000;
        C4BCAssignableRangeLine."Object Range To" := 50000;
        C4BCAssignableRangeLine.Insert();
        Clear(C4BCAssignableRangeLine);

        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_02Txt;
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);

        C4BCAssignableRangeHeader.Code := C4BCAssignableRangeHeader_Code_03Txt;
        C4BCAssignableRangeHeader."Ranges per BC Instance" := true;
        C4BCAssignableRangeHeader."Default Range From" := 30000;
        C4BCAssignableRangeHeader."Default Range To" := 39000;
        C4BCAssignableRangeHeader.Insert();
        Clear(C4BCAssignableRangeHeader);
    end;
}