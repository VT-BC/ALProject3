codeunit 57500 SetReservStatus
{
    TableNo = "Job Queue Entry";

    var
        SalesHeader: Record "Sales Header";
        ReservSalesHeader: Codeunit 57501;

    trigger OnRun();
    begin
        ProcessSales();
    end;

    local procedure ProcessSales()
    begin
        SalesHeader.RESET;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", '101011');
        IF SalesHeader.FindFirst() then
            repeat
                //error('sadas ' + format(SalesHeader.Count));
                ReservSalesHeader.Run(SalesHeader);

                IF ReservSalesHeader.Run(SalesHeader) then
                    IF SalesHeader."Reservation Status" <> SalesHeader."Reservation Status"::"To be processed" then
                        SalesHeader.MODIFY;
            until SalesHeader.Next() = 0;
    end;
}