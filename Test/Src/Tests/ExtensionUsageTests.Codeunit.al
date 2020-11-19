codeunit 79001 "C4BC Extension Usage Tests"
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
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetObjectNameTemplate();
        C4BCObjectRangeTestLibrary.SetExtensionUsage();
        C4BCExtensionObject.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionObject.SetRange("Object Type", C4BCExtensionObject."Object Type"::"Table Extension");
        C4BCExtensionObject.FindSet();
        C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
        C4BCExtensionObject.Modify(true);
        C4BCExtensionObject.Next(1);

        //[THEN] then
        repeat
            asserterror C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
            Assert.ExpectedError('Object name with the same object type cannot be duplicit.');
        until C4BCExtensionObject.Next() < 1;
    end;

    [Test]
    /// <summary> 
    /// Test object name duplicity.
    /// </summary>
    procedure TestObjectNameDuplicityPerBusinessCentralInstance()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCExtensionObject: Record "C4BC Extension Object";
        C4BCAssignableRangeHeader: Record "C4BC Assignable Range Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetObjectNameTemplate();
        C4BCObjectRangeTestLibrary.SetExtensionUsage();
        C4BCAssignableRangeHeader.Get(C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCAssignableRangeHeader."Ranges per BC Instance" := true;
        C4BCAssignableRangeHeader.Modify(false);
        // Extension that has Usage
        C4BCExtensionHeader.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.FindSet();

        C4BCExtensionObject.SetRange("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.SetRange("Object Type", C4BCExtensionObject."Object Type"::"Table Extension");
        C4BCExtensionObject.FindFirst();
        C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
        C4BCExtensionObject.Modify(true);

        //[THEN] then
        Clear(C4BCExtensionObject);
        // Extension that does not have Usage
        C4BCExtensionHeader.Next(2);
        C4BCExtensionObject.SetRange("Extension Code", C4BCExtensionHeader.Code);
        C4BCExtensionObject.SetRange("Object Type", C4BCExtensionObject."Object Type"::"Table Extension");
        C4BCExtensionObject.FindFirst();
        asserterror C4BCExtensionObject.Validate("Object Name", 'C4BC My Object');
        Assert.ExpectedError('Yes, the IDs must be assigned using procedure that specify business central instance ID');
    end;

    [Test]
    /// <summary> 
    /// Test delete extension with linked usage
    /// </summary>
    procedure TestDeleteExtension()
    var
        C4BCExtensionHeader: Record "C4BC Extension Header";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetExtensionUsage();
        C4BCExtensionHeader.SetRange("Assignable Range Code", C4BCObjectRangeTestLibrary.C4BCAssignableRangeHeader_Code_01());
        C4BCExtensionHeader.FindFirst();

        //[THEN] then
        asserterror C4BCExtensionHeader.Delete(true);
        Assert.ExpectedError('Extension header cannot be deleted because it is used by atleast one Business Central instance');
    end;
}
