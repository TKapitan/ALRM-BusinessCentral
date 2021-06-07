codeunit 79000 "ART Assignable Range Tests"
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
    procedure TestGettingObjectIDForTheFirstTime()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
        TempInt: Integer;
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        TempInt := ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::Table, '');
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));

        TempInt := ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::"XML Port", '');
        Assert.IsTrue(TempInt = 99000, StrSubstNo(BadNewIDErr, 99000, TempInt));

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_02());
        asserterror ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::Table, '');
        Assert.AssertNothingInsideFilter();

        asserterror ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::"Table Extension", '');
        Assert.AssertNothingInsideFilter();
    end;

    [Test]
    /// <summary> 
    /// Test overloaded public method GetNewObjectID when the one should be used for specific records, the second one without any limitations
    /// </summary>
    procedure TestAccessingGetNewObjectIDOverloadedMethods()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
        TempInt: Integer;
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        TempInt := ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::Table, '');
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));

        TempInt := ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 30000, StrSubstNo(BadNewIDErr, 30000, TempInt));

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_03());
        asserterror ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::Table, '');
        Assert.ExpectedError('instance ID and the value must not be empty');

        TempInt := ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 40000, StrSubstNo(BadNewIDErr, 40000, TempInt));

        asserterror ARTAssignableRangeHeader.GetNewObjectID("ART Object Type"::Table, '');
        Assert.ExpectedError('instance ID and the value must not be empty');
    end;

    [Test]
    /// <summary> 
    /// Test renaming assignable range
    /// </summary>
    procedure TestRenameExistingAssignableRange()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        asserterror ARTAssignableRangeHeader.Rename(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01() + '_XX');
        Assert.ExpectedError('can not be renamed');
    end;

    [Test]
    /// <summary> 
    /// Test behavior when the field Range per BC Instances is changed on ranges that are not in use
    /// </summary>
    procedure TestChangeRangePerBCInstancesThatAreNotInUse()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        // No Extension Lines for Assignable Range exists
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeHeader.Validate("Ranges per BC Instance", true);
        ARTAssignableRangeHeader.Modify(true);

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeHeader.Validate("Ranges per BC Instance", false);
        ARTAssignableRangeHeader.Modify(true);

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeHeader.Validate("Ranges per BC Instance", true);
        ARTAssignableRangeHeader.Modify(true);
    end;

    [Test]
    /// <summary> 
    /// Test behavior when the field Range per BC Instances is changed on ranges that are already in use
    /// </summary>
    procedure TestChangeRangePerBCInstancesThatAreInUse()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_02());
        ARTAssignableRangeHeader.Validate("Ranges per BC Instance", true);
        ARTAssignableRangeHeader.Modify(true);
        ARTAssignableRangeHeader.Validate("Ranges per BC Instance", false);
        ARTAssignableRangeHeader.Modify(true);

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        asserterror ARTAssignableRangeHeader.Validate("Ranges per BC Instance", true);
        Assert.ExpectedError('due to the existing extensions');

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_03());
        asserterror ARTAssignableRangeHeader.Validate("Ranges per BC Instance", false);
        Assert.ExpectedError('due to the existing extensions');
    end;


    [Test]
    /// <summary> 
    /// Test condition when the assignable range default range could be deleted.
    /// </summary>
    procedure TestChangeDefaultObjectRange()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());

        asserterror ARTAssignableRangeHeader.Validate("Default Object Range From", ARTAssignableRangeHeader."Default Object Range From" + 10);
        Assert.ExpectedError('there are extension lines with');
        ARTAssignableRangeHeader.Validate("Default Object Range From", ARTAssignableRangeHeader."Default Object Range From" - 1);
        ARTAssignableRangeHeader.Validate("Default Object Range To", ARTAssignableRangeHeader."Default Object Range To" + 10);
        ARTAssignableRangeHeader.Validate("Default Object Range To", ARTAssignableRangeHeader."Default Object Range To" - 10);
        asserterror ARTAssignableRangeHeader.Validate("Default Object Range To", ARTAssignableRangeHeader."Default Object Range From");
        Assert.ExpectedError('there are extension lines with');

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_04());
        ARTAssignableRangeHeader.Validate("Default Object Range From", 0);
        ARTAssignableRangeHeader.Validate("Default Object Range To", 0);
    end;

    [Test]
    /// <summary> 
    /// Test condition when the assignable range line could be modified.
    /// </summary>
    procedure TestChangeObjectRange()
    var
        ARTAssignableRangeLine: Record "ART Assignable Range Line";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[THEN] then
        ARTAssignableRangeLine.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01(), "ART Object Type"::"XML Port", 99000);
        asserterror ARTAssignableRangeLine.Validate("Object Range To", ARTAssignableRangeLine."Object Range From");
        Assert.ExpectedError('there are extension lines with');
        ARTAssignableRangeLine.Validate("Object Range To", ARTAssignableRangeLine."Object Range From" + 10);
        ARTAssignableRangeLine.Validate("Object Range To", ARTAssignableRangeLine."Object Range To" + 10);

        ARTAssignableRangeLine.Rename(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01(), "ART Object Type"::"XML Port", 98999);
        ARTAssignableRangeLine.Rename(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01(), "ART Object Type"::"XML Port", 99000);
        asserterror ARTAssignableRangeLine.Rename(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01(), "ART Object Type"::"XML Port", 99001);
        Assert.ExpectedError('there are extension lines with');

        ARTAssignableRangeLine.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_04(), "ART Object Type"::Enum, 100000);
        ARTAssignableRangeLine.Validate("Object Range From", 0);
        ARTAssignableRangeLine.Validate("Object Range To", 0);
    end;

    [Test]
    /// <summary> 
    /// Test condition when the object name template could be modified.
    /// </summary>
    procedure TestChangeObjectNameTemplate()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_05());
        ARTAssignableRangeHeader.Validate("Object Name Template", 'ART *');
        ARTAssignableRangeHeader.Validate("Object Name Template", '');
        ARTAssignableRangeHeader.Validate("Object Name Template", 'ART *');

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_06());
        asserterror ARTAssignableRangeHeader.Validate("Object Name Template", 'ART *');
        Assert.ExpectedError('extension lines that are different from');
    end;

    [Test]
    /// <summary> 
    /// Description for TestDeleteAssignableRangeHeader.
    /// </summary>
    procedure TestDeleteAssignableRangeHeaderFailed()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        asserterror ARTAssignableRangeHeader.Delete(true);
        Assert.ExpectedError('due to existing related records');
    end;

    [Test]
    /// <summary> 
    /// Description for TestDeleteAssignableRangeHeader.
    /// </summary>
    procedure TestDeleteAssignableRangeHeaderSuccess()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTAssignableRangeLine: Record "ART Assignable Range Line";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_05());
        ARTAssignableRangeHeader.Delete(true);
        ARTAssignableRangeLine.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_05());
        Assert.RecordIsEmpty(ARTAssignableRangeLine);
    end;

    [Test]
    /// <summary> 
    /// Test condition when the assignable range line could be deleted.
    /// </summary>
    procedure TestDeleteAssignableRangeLine()
    var
        ARTAssignableRangeLine: Record "ART Assignable Range Line";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[THEN] then
        ARTAssignableRangeLine.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01(), "ART Object Type"::"XML Port", 99000);
        asserterror ARTAssignableRangeLine.Delete(true);
        Assert.ExpectedError('there are extension lines with');

        ARTAssignableRangeLine.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_04(), "ART Object Type"::Enum, 100000);
        ARTAssignableRangeLine.Delete(true);
    end;

    [Test]
    /// <summary> 
    /// Test overloaded public method GetNewFieldID when the one should be used for specific records, the second one without any limitations
    /// </summary>
    procedure TestAccessingGetNewFieldIDOverloadedMethods()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
        TempInt: Integer;
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeAssignableFieldRanges();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        TempInt := ARTAssignableRangeHeader.GetNewFieldID("ART Object Type"::Table, '');
        Assert.IsTrue(TempInt = 200000, StrSubstNo(BadNewIDErr, 200000, TempInt));
        TempInt := ARTAssignableRangeHeader.GetNewFieldID("ART Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 200000, StrSubstNo(BadNewIDErr, 200000, TempInt));

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_03());
        asserterror ARTAssignableRangeHeader.GetNewFieldID("ART Object Type"::Table, '');
        Assert.ExpectedError('instance ID and the value must not be empty');
        TempInt := ARTAssignableRangeHeader.GetNewFieldID("ART Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 300000, StrSubstNo(BadNewIDErr, 300000, TempInt));
    end;

    [Test]
    /// <summary> 
    /// Test getting the ID for the first time for specific Assignable Range
    /// </summary>
    procedure TestGettingFieldIDForTheFirstTime()
    var
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
        TempInt: Integer;
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeAssignableFieldRanges();
        Commit();

        //[THEN] then
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        TempInt := ARTAssignableRangeHeader.GetNewFieldID("ART Object Type"::Table, '');
        Assert.IsTrue(TempInt = 200000, StrSubstNo(BadNewIDErr, 200000, TempInt));
        TempInt := ARTAssignableRangeHeader.GetNewFieldID("ART Object Type"::Table, 'IGNORED_BCINSTANCE');
        Assert.IsTrue(TempInt = 200000, StrSubstNo(BadNewIDErr, 200000, TempInt));

        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_02());
        asserterror ARTAssignableRangeHeader.GetNewFieldID("ART Object Type"::Table, '');
        Assert.ExpectedError('must have a value');
    end;

    [Test]
    procedure TestCreatingSpecialRangeForUsedObjectType()
    var
        ARTAssignableRangeLine: Record "ART Assignable Range Line";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();

        //[WHEN] when
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[THEN] then
        ARTAssignableRangeLine.Init();
        ARTAssignableRangeLine.Validate("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeLine.Validate("Object Type", ARTAssignableRangeLine."Object Type"::Table);
        ARTAssignableRangeLine.Validate("Object Range From", 5);
        ARTAssignableRangeLine.Validate("Object Range To", 10);
        asserterror ARTAssignableRangeLine.Insert(true);
        Assert.ExpectedError('header object range is in use hence it is not possible to define special range');

        Clear(ARTAssignableRangeLine);
        ARTAssignableRangeLine.Init();
        ARTAssignableRangeLine.Validate("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeLine.Validate("Object Type", ARTAssignableRangeLine."Object Type"::"Enum Extension");
        ARTAssignableRangeLine.Validate("Object Range From", 5);
        ARTAssignableRangeLine.Validate("Object Range To", 10);
        ARTAssignableRangeLine.Insert(true);

        Clear(ARTAssignableRangeLine);
        ARTAssignableRangeLine.Init();
        ARTAssignableRangeLine.Validate("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeLine.Validate("Object Type", ARTAssignableRangeLine."Object Type"::"Table Extension");
        ARTAssignableRangeLine.Validate("Object Range From", 15);
        ARTAssignableRangeLine.Validate("Object Range To", 20);
        asserterror ARTAssignableRangeLine.Insert(true);
        Assert.ExpectedError('header object range is in use hence it is not possible to define special range');
    end;
}