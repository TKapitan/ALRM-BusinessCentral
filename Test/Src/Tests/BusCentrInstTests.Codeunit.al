codeunit 79004 "ART Bus. Centr. Inst. Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit Assert;

    [Test]
    /// <summary> 
    /// Test delete business central instance with linked records.
    /// </summary>
    procedure TestDeleteBusinessCentralInstance()
    var
        ARTExtensionUsage: Record "ART Extension Usage";
        ARTBusinessCentralInstance: Record "ART Business Central Instance";
        ARTObjectRangeTestLibrary: Codeunit "ART Object Range Test Library";
    begin
        //[GIVEN] given
        ARTObjectRangeTestLibrary.InitializeAssignableRanges();
        ARTObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        ARTObjectRangeTestLibrary.SetExtensionUsage();
        Commit();

        //[THEN] then
        ARTBusinessCentralInstance.Get(ARTObjectRangeTestLibrary.ARTBusinessCentralInstance_Code_02());
        ARTBusinessCentralInstance.Delete(true);
        ARTBusinessCentralInstance.Get(ARTObjectRangeTestLibrary.ARTBusinessCentralInstance_Code_01());
        asserterror ARTBusinessCentralInstance.Delete(true);
        Assert.ExpectedError('due to the existing');

        //[WHEN] when
        ARTExtensionUsage.SetRange("Business Central Instance Code", ARTObjectRangeTestLibrary.ARTBusinessCentralInstance_Code_01());
        ARTExtensionUsage.DeleteAll(false);

        //[THEN] then
        ARTBusinessCentralInstance.Get(ARTObjectRangeTestLibrary.ARTBusinessCentralInstance_Code_01());
        ARTBusinessCentralInstance.Delete(true);
    end;
}