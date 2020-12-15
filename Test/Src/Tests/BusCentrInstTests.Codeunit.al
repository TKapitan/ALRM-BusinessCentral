codeunit 79004 "C4BC Bus. Centr. Inst. Tests"
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
        C4BCExtensionUsage: Record "C4BC Extension Usage";
        C4BCBusinessCentralInstance: Record "C4BC Business Central Instance";
        C4BCObjectRangeTestLibrary: Codeunit "C4BC Object Range Test Library";
    begin
        //[GIVEN] given
        C4BCObjectRangeTestLibrary.InitializeAssignableRanges();
        C4BCObjectRangeTestLibrary.InitializeExtensions();

        //[WHEN] when
        C4BCObjectRangeTestLibrary.SetExtensionUsage();
        Commit();

        //[THEN] then
        C4BCBusinessCentralInstance.Get(C4BCObjectRangeTestLibrary.C4BCBusinessCentralInstance_Code_02());
        C4BCBusinessCentralInstance.Delete(true);
        C4BCBusinessCentralInstance.Get(C4BCObjectRangeTestLibrary.C4BCBusinessCentralInstance_Code_01());
        asserterror C4BCBusinessCentralInstance.Delete(true);
        Assert.ExpectedError('due to the existing');

        //[WHEN] when
        C4BCExtensionUsage.SetRange("Business Central Instance Code", C4BCObjectRangeTestLibrary.C4BCBusinessCentralInstance_Code_01());
        C4BCExtensionUsage.DeleteAll(false);

        //[THEN] then
        C4BCBusinessCentralInstance.Get(C4BCObjectRangeTestLibrary.C4BCBusinessCentralInstance_Code_01());
        C4BCBusinessCentralInstance.Delete(true);
    end;
}