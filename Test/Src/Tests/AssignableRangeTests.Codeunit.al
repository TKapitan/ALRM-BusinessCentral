codeunit 79000 "C4BC Assignable Range Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;
        BadNewIDErr: Label 'Bad new ID. Expected %1, Received %2.', Locked = true;

    [Test]
    /// <summary> 
    /// Test getting the ID for the first time for specific Assignable Range
    /// </summary>
    procedure TestGettingIDForTheFirstTime()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
        TempInt: Integer;
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table);
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::"XML Port");
        Assert.IsTrue(TempInt = 99000, StrSubstNo(BadNewIDErr, 99000, TempInt));

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_02());
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
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
        TempInt: Integer;
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table);
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_03());
        asserterror C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table);
        Assert.ExpectedError('instance ID and the value must not be empty');
        TempInt := C4BCAssignableRangeHeader.GetNewID("C4BC Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 40000, StrSubstNo(BadNewIDErr, 40000, TempInt));
    end;

    [Test]
    /// <summary> 
    /// Test renaming assignable range
    /// </summary>
    procedure TestRenameExistingAssignableRange()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        asserterror C4BCAssignableRangeHeader.Rename(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01() + '_XX');
        Assert.ExpectedError('can not be renamed');
    end;

    [Test]
    /// <summary> 
    /// Test behavior when the field Range per BC Instances is changed
    /// </summary>
    procedure TestChangeRangePerBCInstances()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        // No Extension Lines for Assignable Range exists

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCAssignableRangeHeader.Validate("Ranges per BC Instance", true);
        C4BCAssignableRangeHeader.Modify(true);
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCAssignableRangeHeader.Validate("Ranges per BC Instance", false);
        C4BCAssignableRangeHeader.Modify(true);

        // //[WHEN] when
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        // //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        asserterror C4BCAssignableRangeHeader.Validate("Ranges per BC Instance", true);
        Assert.ExpectedError('due to the existing extensions');
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_02());
        C4BCAssignableRangeHeader.Validate("Ranges per BC Instance", true);
        C4BCAssignableRangeHeader.Modify(true);
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_03());
        asserterror C4BCAssignableRangeHeader.Validate("Ranges per BC Instance", false); // default value for this is true -> we want to change the value
        Assert.ExpectedError('due to the existing extensions');
    end;

    [Test]
    /// <summary> 
    /// Test condition when the assignable range default range could be deleted.
    /// </summary>
    procedure TestChangeDefaultObjectRange()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        asserterror C4BCAssignableRangeHeader.Validate("Default Range From", C4BCAssignableRangeHeader."Default Range From" + 10);
        Assert.ExpectedError('there are extension lines with');
        C4BCAssignableRangeHeader.Validate("Default Range From", C4BCAssignableRangeHeader."Default Range From" - 1);
        C4BCAssignableRangeHeader.Validate("Default Range To", C4BCAssignableRangeHeader."Default Range To" + 10);
        C4BCAssignableRangeHeader.Validate("Default Range To", C4BCAssignableRangeHeader."Default Range To" - 10);
        asserterror C4BCAssignableRangeHeader.Validate("Default Range To", C4BCAssignableRangeHeader."Default Range From");
        Assert.ExpectedError('there are extension lines with');

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_04());
        C4BCAssignableRangeHeader.Validate("Default Range From", 0);
        C4BCAssignableRangeHeader.Validate("Default Range To", 0);
    end;

    [Test]
    /// <summary> 
    /// Test condition when the assignable range line could be modified.
    /// </summary>
    procedure TestChangeObjectRange()
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[THEN] then
        C4BCAssignableRangeLine.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01(), "C4BC Object Type"::"XML Port", 99000);
        asserterror C4BCAssignableRangeLine.Validate("Object Range To", C4BCAssignableRangeLine."Object Range From");
        Assert.ExpectedError('there are extension lines with');
        C4BCAssignableRangeLine.Validate("Object Range To", C4BCAssignableRangeLine."Object Range From" + 10);
        C4BCAssignableRangeLine.Validate("Object Range To", C4BCAssignableRangeLine."Object Range To" + 10);
        asserterror C4BCAssignableRangeLine.Rename(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01(), "C4BC Object Type"::"XML Port", 98999);
        Assert.ExpectedError('can not be renamed');

        //[THEN] then
        C4BCAssignableRangeLine.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_04(), "C4BC Object Type"::Enum, 100000);
        C4BCAssignableRangeLine.Validate("Object Range From", 0);
        C4BCAssignableRangeLine.Validate("Object Range To", 0);
    end;

    [Test]
    /// <summary> 
    /// Test condition when the object name template could be modified.
    /// </summary>
    procedure TestChangeObjectNameTemplate()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_05());
        C4BCAssignableRangeHeader.Validate("Object Name Template", 'C4BC *');

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_06());
        asserterror C4BCAssignableRangeHeader.Validate("Object Name Template", 'C4BC *');
        Assert.ExpectedError('extension lines that are different from');
    end;

    [Test]
    /// <summary> 
    /// Description for TestDeleteAssignableRangeHeader.
    /// </summary>
    procedure TestDeleteAssignableRangeHeaderFailed()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        asserterror C4BCAssignableRangeHeader.Delete(true);
        Assert.ExpectedError('due to existing related records');
    end;

    [Test]
    /// <summary> 
    /// Description for TestDeleteAssignableRangeHeader.
    /// </summary>
    procedure TestDeleteAssignableRangeHeaderSuccess()
    var
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[THEN] then
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_03());
        C4BCAssignableRangeHeader.Delete(true);
        C4BCAssignableRangeLine.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_03());
        Assert.RecordIsEmpty(C4BCAssignableRangeLine);
    end;

    [Test]
    /// <summary> 
    /// Test condition when the assignable range line could be deleted.
    /// </summary>
    procedure TestDeleteAssignableRangeLine()
    var
        C4BCAssignableRangeLine: Record "C4BC Assignable Range Line";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[THEN] then
        C4BCAssignableRangeLine.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01(), "C4BC Object Type"::"XML Port", 99000);
        asserterror C4BCAssignableRangeLine.Delete(true);
        Assert.ExpectedError('there are extension lines with');

        C4BCAssignableRangeLine.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_04(), "C4BC Object Type"::Enum, 100000);
        C4BCAssignableRangeLine.Delete(true);
    end;
}