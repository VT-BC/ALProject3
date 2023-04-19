codeunit 57501 ReservStatusProcess
{
    procedure AutoReservSalesOrder(SalesHeader: Record "Sales Header");
    var
        SalesLine: Record "Sales Line";
        ReservPage: Page Reservation;
        ResStatus: Option "To be processed","No reservation","Partly","Completely";
    begin
        SalesLine.RESET;
        SalesLine.SetRange(SalesLine."Document Type", SalesHeader."Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("No.", '<>%1', '');
        SalesLine.SetFilter(Reserve, '<>%1', SalesLine.Reserve::Never);
        IF SalesLine.FindSet() then
            Repeat
                If (SalesLine."Outstanding Qty. (Base)" - SalesLine."Reserved Qty. (Base)") > 0 THEN begin
                    //ReservEntry.SetIgnoreTracking(True);
                    ReservPage.SetSalesLine(SalesLine);
                    ReservPage.AutoReserve;
                    //ReservPage.
                end;
            until SalesLine.Next() = 0;

        ResStatus := GetReservStatus(SalesHeader);
        //error('2 ' + format(SalesHeader."No.") + ' ' + Format(ResStatus));
        If ResStatus <> SalesHeader."Reservation Status" then Begin
            SalesHeader."Reservation Status" := ResStatus;
            SalesHeader.Modify();
        end;
    end;

    procedure GetReservStatus(SalesHeader: Record "Sales Header") ReturnValue: Option
    var
        SalesLine1: Record "Sales Line";
        FullReserv: Boolean;
        NoReserv: Boolean;
        BaseResQty: Decimal;

    begin
        NoReserv := TRUE;
        FullReserv := TRUE;
        SalesLine1.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine1.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine1.SETRANGE(Type, SalesLine1.Type::Item);
        SalesLine1.SetFilter("No.", '<>%1', '');
        SalesLine1.SetFilter(Reserve, '<>%1', SalesLine1.Reserve::Never);
        IF SalesLine1.FINDSET THEN
            REPEAT
                BaseResQty := CalcReservedOnInventory(SalesLine1, TRUE); // In Base UoM  
                NoReserv := NoReserv AND (BaseResQty = 0);
                FullReserv := FullReserv AND (BaseResQty = SalesLine1."Outstanding Qty. (Base)");
            UNTIL SalesLine1.NEXT = 0;

        IF SalesLine1.ISEMPTY THEN
            ReturnValue := 0
        //ResStatus := ResStatus::" "
        ELSE
            IF FullReserv THEN
                ReturnValue := 3
            //ResStatus := ResStatus::Completely
            ELSE
                IF NoReserv THEN
                    ReturnValue := 1
                //ResStatus := ResStatus::No
                ELSE
                    ReturnValue := 2
        //ResStatus := ResStatus::Partially;
        //EXIT(ResStatus);
    end;

    procedure CalcReservedOnInventory(RecOrRecRef: Variant; InBaseUoM: Boolean) ResQty: Decimal
    var
        RecRef: RecordRef;
        SalLine: Record "Sales Line";
        SalLineRes: Codeunit "Sales Line-Reserve";
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
    begin
        IF RecOrRecRef.ISRECORD THEN
            RecRef.GETTABLE(RecOrRecRef)
        ELSE
            RecRef := RecOrRecRef;
        ResQty := 0;
        CASE RecRef.NUMBER OF
            DATABASE::"Sales Line":
                BEGIN
                    RecRef.SETTABLE(SalLine);
                    SalLineRes.FilterReservFor(ResEntry, SalLine);
                END;

        /*
            DATABASE::"Transfer Line":
                BEGIN
                    RecRef.SETTABLE(TransLine);
                    TransLineReserve.FilterReservFor(ResEntry, TransLine, 0); // 0 for Outbound
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    RecRef.SETTABLE(PurLine);
                    PurLineReserve.FilterReservFor(ResEntry, PurLine);
                END;
            DATABASE::"Service Line":
                BEGIN
                    RecRef.SETTABLE(ServLine);
                    ServLineReserve.FilterReservFor(ResEntry, ServLine);
                END;
        */
        END;

        ResEntry.SETRANGE(Positive, FALSE);
        ResEntry.SETRANGE("Reservation Status", ResEntry."Reservation Status"::Reservation);
        IF ResEntry.FINDSET THEN
            REPEAT
                IF ResEntry2.GET(ResEntry."Entry No.", NOT ResEntry.Positive) THEN
                    IF ResEntry2."Source Type" = DATABASE::"Item Ledger Entry" THEN
                        IF InBaseUoM THEN
                            ResQty += ResEntry2."Quantity (Base)"
                        ELSE
                            ResQty += ResEntry2.Quantity;
            UNTIL ResEntry.NEXT = 0;

    end;

}