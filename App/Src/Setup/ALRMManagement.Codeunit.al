/// <summary>
/// Codeunit C4BC ALRM Management (ID 80003).
/// </summary>
codeunit 80003 "C4BC ALRM Management"
{
    SingleInstance = true;

    /// <summary>
    /// Check whether the object type in parameter has IDs for identification.
    /// </summary>
    /// <param name="ForObjectType">Enum "C4BC Object Type", Specifies object type we want to check for IDs.</param>
    /// <param name="ShowError">Boolean, Specifies, whether the error should be shown in case on object type that does not use IDs.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure UseObjectTypeIDs(ForObjectType: Enum "C4BC Object Type"; ShowError: Boolean): Boolean
    var
        C4BCObjectTypeConfiguration: Record "C4BC Object Type Configuration";

        IObjectType: Interface "C4BC IObject Type";
        ObjectTypeDoesNotUseIDsErr: Label '%1 object type does not use IDs for identification.', Comment = '%1 - Object type that does not use IDs for identification.';

        HasID: Boolean;
    begin
        if C4BCObjectTypeConfiguration.IsObjectTypeConfigurationUsed() then begin
            C4BCObjectTypeConfiguration.Get(ForObjectType);
            HasID := C4BCObjectTypeConfiguration."Has ID";
        end else begin
            // Deprecated 2021/Q4 ->
            IObjectType := ForObjectType;
            HasID := IObjectType.HasIDs();
            // Deprecated 2021/Q4 <-
        end;

        IObjectType := ForObjectType;
        if not HasID then begin
            if ShowError then
                Error(ObjectTypeDoesNotUseIDsErr, ForObjectType);
            exit(false);
        end;
        exit(true);
    end;
}