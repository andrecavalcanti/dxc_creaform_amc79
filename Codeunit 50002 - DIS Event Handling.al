codeunit 50001 "DXC DIS"
{
    // version EC1.02


    trigger OnRun();
    begin
    end;

    local procedure "--CU5100918---"();
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 5100918, 'OnBeforeConvertValueByTag', '', true, true)]
    local procedure HandleBeforeConvertValueByTagOnDISConversionMgt(var SourceCodeTag : Code[20];var FldValue : Variant);
    var
        FirstDate : Date;
        LastDate : Date;
    begin

        case SourceCodeTag of
          'CURRMONTH':
            CurrMonthFilter(FldValue);
          'CRMDATETIME2DATE':
            DateTimeToDate(FldValue);
        end;
    end;

    procedure "--- Source Code Tag ---"();
    begin
    end;

    local procedure CurrMonthFilter(var FldValue : Variant);
    var
        FirstDate : Date;
        LastDate : Date;
    begin

        FirstDate := CALCDATE('<-CM>',TODAY);
        LastDate := CALCDATE('<CM>',TODAY);
        FldValue := STRSUBSTNO('%1..%2',FirstDate,LastDate);
    end;

    local procedure DateTimeToDate(var FldValue : Variant);
    var
        DateValue : Date;
        DateStr : Text;
    begin

        DateStr := COPYSTR(FldValue,1,10);
        DateStr := COPYSTR(DateStr, 6, 2) + COPYSTR(DateStr, 9, 2) + COPYSTR(DateStr, 3, 2);
        EVALUATE(DateValue,DateStr);
        FldValue := DateValue;
    end;
}

