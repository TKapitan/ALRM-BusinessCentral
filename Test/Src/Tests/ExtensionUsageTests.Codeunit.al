codeunit 79001 "ART Extension Usage Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;


    [Test]
    /// <summary> 
    /// Test object name duplicity.
    /// </summary>
    procedure TestObjectNameDuplicity()
    var
        ARTExtensionObject: Record "ART Extension Object";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        ARTObjectRangeTestLibrary.SetObjectNameTemplate();
        ARTObjectRangeTestLibrary.SetExtensionUsage();
        ARTExtensionObject.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionObject.SetRange("Object Type", ARTExtensionObject."Object Type"::"Table Extension");
        ARTExtensionObject.FindSet();
        ARTExtensionObject.Validate("Object Name", 'ART My Object');
        ARTExtensionObject.Modify(true);
        Commit();

        ARTExtensionObject.Next(1);

        //[THEN] then
        repeat
            asserterror ARTExtensionObject.Validate("Object Name", 'ART My Object');
            Assert.ExpectedError('is already in use.');
        until ARTExtensionObject.Next() < 1;
    end;

    [Test]
    /// <summary> 
    /// Test object name duplicity.
    /// </summary>
    procedure TestObjectNameDuplicityPerBusinessCentralInstance()
    var
        ARTExtensionHeader: Record "ART Extension Header";
        ARTExtensionObject: Record "ART Extension Object";
        ARTAssignableRangeHeader: Record "ART Assignable Range Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();
        Commit();

        //[WHEN] when
        ARTObjectRangeTestLibrary.SetObjectNameTemplate();
        ARTObjectRangeTestLibrary.SetExtensionUsage();
        ARTAssignableRangeHeader.Get(ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTAssignableRangeHeader."Ranges per BC Instance" := true;
        ARTAssignableRangeHeader.Modify(false);
        // Extension that has Usage
        ARTExtensionHeader.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.FindSet();

        ARTExtensionObject.SetRange("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.SetRange("Object Type", ARTExtensionObject."Object Type"::"Table Extension");
        ARTExtensionObject.FindFirst();
        ARTExtensionObject.Validate("Object Name", 'ART My Object');
        ARTExtensionObject.Modify(true);

        //[THEN] then
        Clear(ARTExtensionObject);
        // Extension that does not have Usage
        ARTExtensionHeader.Next(2);
        ARTExtensionObject.SetRange("Extension Code", ARTExtensionHeader.Code);
        ARTExtensionObject.SetRange("Object Type", ARTExtensionObject."Object Type"::"Table Extension");
        ARTExtensionObject.FindFirst();
        asserterror ARTExtensionObject.Validate("Object Name", 'ART My Object');
        Assert.ExpectedError('There is no Extension Usage within the filter.');
    end;

    [Test]
    /// <summary> 
    /// Test delete extension with linked usage
    /// </summary>
    procedure TestDeleteExtension()
    var
        ARTExtensionHeader: Record "ART Extension Header";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        ARTObjectRangeTestLibrary.SetExtensionUsage();
        Commit();

        ARTExtensionHeader.SetRange("Assignable Range Code", ARTObjectRangeTestLibrary.ARTAssignableRangeHeader_Code_01());
        ARTExtensionHeader.FindFirst();

        //[THEN] then
        asserterror ARTExtensionHeader.Delete(true);
        Assert.ExpectedError('Extension header cannot be deleted because it is used by atleast one Business Central instance');
    end;
}
