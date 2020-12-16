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
        IObjectType: Interface "C4BC IObject Type";
        ObjectTypeDoesNotUseIDsErr: Label '%1 object type does not use IDs for identification.', Comment = '%1 - Object type that does not use IDs for identification.';
    begin
        IObjectType := ForObjectType;
        if not IObjectType.HasIDs() then begin
            if ShowError then
                Error(ObjectTypeDoesNotUseIDsErr, ForObjectType);
            exit(false);
        end;
        exit(true);
    end;
}